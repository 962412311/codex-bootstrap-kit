#!/usr/bin/env python3

import json
import re
import subprocess
import sys
from datetime import date, timedelta


ANSI_RE = re.compile(
    r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])"
)


def send(process, message):
    process.stdin.write(
        json.dumps(message, ensure_ascii=False) + "\n"
    )
    process.stdin.flush()


def read_json_message(process):
    """
    从 Codex App Server stdout 中读取下一条有效 JSON 消息。
    自动跳过启动提示、警告、日志及 ANSI 控制字符。
    """
    while True:
        line = process.stdout.readline()

        if line == "":
            return_code = process.poll()
            raise RuntimeError(
                f"Codex App Server 已退出，退出码：{return_code}"
            )

        clean = ANSI_RE.sub("", line).strip()
        if not clean:
            continue

        # 正常 JSON 行
        candidates = [clean]

        # 兼容日志前缀后跟 JSON 的情况
        json_start = clean.find("{")
        if json_start > 0:
            candidates.append(clean[json_start:])

        for candidate in candidates:
            try:
                message = json.loads(candidate)
                if isinstance(message, dict):
                    return message
            except json.JSONDecodeError:
                pass

        print(
            f"[跳过非 JSON 输出] {clean}",
            file=sys.stderr
        )


def wait_response(process, request_id):
    while True:
        message = read_json_message(process)
        if message.get("id") == request_id:
            return message


def compact_tokens(tokens):
    if tokens >= 1_000_000_000:
        return f"{tokens / 1_000_000_000:.3f}B"
    if tokens >= 1_000_000:
        return f"{tokens / 1_000_000:.2f}M"
    if tokens >= 1_000:
        return f"{tokens / 1_000:.2f}K"
    return str(tokens)


try:
    days = int(sys.argv[1]) if len(sys.argv) > 1 else 7
except ValueError:
    print("用法：codex usage [天数]")
    sys.exit(1)

if days < 1 or days > 366:
    print("天数应在 1～366 之间")
    sys.exit(1)


process = subprocess.Popen(
    [
        "codex",
        "app-server",
        "--listen",
        "stdio://",
    ],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    # App Server 的内部刷新日志不属于用量结果。
    stderr=subprocess.DEVNULL,
    text=True,
    bufsize=1,
)

try:
    # 1. 初始化 App Server
    send(process, {
        "method": "initialize",
        "id": 1,
        "params": {
            "clientInfo": {
                "name": "codex_usage_detail",
                "title": "Codex Usage Detail",
                "version": "1.1.0",
            }
        },
    })

    init_response = wait_response(process, 1)

    if "error" in init_response:
        raise RuntimeError(
            f"初始化失败：{init_response['error']}"
        )

    send(process, {
        "method": "initialized",
        "params": {},
    })

    # 2. 获取账户每日 Token 活动
    send(process, {
        "method": "account/usage/read",
        "id": 2,
    })

    usage_response = wait_response(process, 2)

    if "error" in usage_response:
        raise RuntimeError(
            f"Codex 返回错误：{usage_response['error']}"
        )

    result = usage_response.get("result", {})

    buckets = (
        result.get("dailyUsageBuckets")
        or result.get("daily_usage_buckets")
        or []
    )

    if not buckets:
        raise RuntimeError(
            "接口没有返回每日用量数据。请确认当前使用 ChatGPT 账号登录 Codex。"
        )

    # 3. 按日期整理，兼容重复日期
    usage_by_date = {}

    for item in buckets:
        day_string = (
            item.get("startDate")
            or item.get("start_date")
        )

        tokens = item.get("tokens", 0)

        if not day_string:
            continue

        try:
            tokens = max(int(tokens), 0)
        except (TypeError, ValueError):
            continue

        usage_by_date[day_string] = (
            usage_by_date.get(day_string, 0) + tokens
        )

    # 4. 显示最近 N 个自然日，没有记录的日期显示为 0
    end_day = date.today()
    start_day = end_day - timedelta(days=days - 1)

    print()
    print(f"Codex 最近 {days} 天 Token 活动")
    print(f"{'日期':<12} {'Token 数量':>20} {'简写':>12}")
    print("-" * 48)

    total = 0

    for offset in range(days):
        current_day = start_day + timedelta(days=offset)
        day_string = current_day.isoformat()
        tokens = usage_by_date.get(day_string, 0)
        total += tokens

        print(
            f"{day_string:<12} "
            f"{tokens:>20,} "
            f"{compact_tokens(tokens):>12}"
        )

    print("-" * 48)
    print(
        f"{'合计':<12} "
        f"{total:>20,} "
        f"{compact_tokens(total):>12}"
    )

    if days > 0:
        average = total / days
        print(
            f"{'日均':<12} "
            f"{average:>20,.0f} "
            f"{compact_tokens(int(average)):>12}"
        )

    print()
    print("说明：当天数据可能仍在累计，统计日期也可能按服务端时区划分。")

finally:
    if process.poll() is None:
        process.terminate()
        try:
            process.wait(timeout=2)
        except subprocess.TimeoutExpired:
            process.kill()
