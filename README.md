# Codex Tooling

这个仓库用于归档和部署当前 `$HOME/.codex` 的全局 Agent 规则树，不是完整的 Codex 运行态备份。

## 内容

- `codex-home/`：可部署到 `$HOME/.codex` 的 Agent 文件树，按当前全局配置原样镜像
- `codex-home/path.sh`：Codex 启动 PATH 脚本
- `codex-home/global-rules/`：按任务类型拆分的全局规则
- `codex-home/vendor_imports/andrej-karpathy-skills/`：全局规则链依赖的公开 vendor import，排除 `.git/`
- `scripts/codex-agent-tree/package.sh`：生成部署包
- `scripts/codex-agent-tree/deploy.sh`：白名单覆盖部署到目标 `.codex`
- `dist/codex-global-agent-tree.tar.gz`：当前已生成的部署包

## 使用

生成部署包：

```bash
scripts/codex-agent-tree/package.sh
```

部署到当前用户：

```bash
scripts/codex-agent-tree/deploy.sh --archive dist/codex-global-agent-tree.tar.gz
```

部署到指定目录：

```bash
scripts/codex-agent-tree/deploy.sh --archive dist/codex-global-agent-tree.tar.gz --target /path/to/.codex
```

扔给 Codex 的一句话：

```text
请在这个仓库中运行 scripts/codex-agent-tree/deploy.sh --archive dist/codex-global-agent-tree.tar.gz，完整部署 Codex 启动脚本 path.sh 和 AGENTS.md 引用的全局 Agent 结构树，并验证目标 $HOME/.codex 的白名单文件树与 codex-home/ 一致。
```

## Codex 启动脚本

`codex-home/path.sh` 会在 Codex 启动时整理 `PATH`：

- 加入 `$HOME/.local/bin`
- 加入 `$HOME/.codex/npm-global/bin`
- 根据当前平台选择 `@openai/codex-*` optional package 的 vendor path
- 提供稳定的 `apply_patch` / `applypatch` wrapper

部署后它会覆盖目标 `$HOME/.codex/path.sh`。如果只想更新启动脚本，可以只复制这个文件：

```bash
cp codex-home/path.sh "$HOME/.codex/path.sh"
```

## 部署边界

部署脚本只覆盖：

- `AGENTS.md`
- `BOOTSTRAP.md`
- `GLOBAL-AGENT.md`
- `KARPATHY-INTEGRATION.md`
- `RTK.md`
- `path.sh`
- `global-rules/`
- `vendor_imports/andrej-karpathy-skills/`

不会覆盖或删除：

- `auth.json`
- `config.toml`
- `state*.sqlite*`
- `sessions/`
- `memories/`
- `cache/`
- `plugins/`
- `log/`

## macOS

脚本兼容 macOS 默认工具链：`/bin/sh`、BSD `tar`、BSD `mktemp`、系统 `rsync`、`shasum`。打包和解包时使用 `COPYFILE_DISABLE=1`，避免 AppleDouble 元数据进入归档。
