# Codex Tooling

这个仓库只维护当前已验证的 Codex 初始化工具集。它不是完整的
`$HOME/.codex` 备份，也不负责自动安装或更新 skills。

## 内容

- [codex-home/AGENTS.md](codex-home/AGENTS.md)：Codex 初始化 Agent 规则入口
- [codex-home/RTK.md](codex-home/RTK.md)：RTK 命令代理约定
- [codex-home/path.sh](codex-home/path.sh)：Codex PATH 与 `apply_patch` wrapper 配置
- [docs/codex-skill-scope.md](docs/codex-skill-scope.md)：当前裁剪后的 skill 范围记录
- [AGENTS.md](AGENTS.md)：仓库维护规则

## 安装 Codex CLI

macOS 不需要区分 Intel 或 Apple Silicon，直接安装最新版本：

```bash
npm install -g @openai/codex@latest
```

Linux 同样使用这一条 npm 安装命令。平台架构由 Codex npm 包的
optional dependency 和 `codex-home/path.sh` 在运行时识别。

## 平台支持

`codex-home/path.sh` 运行时支持以下 Codex npm optional package 布局：

- Linux x64：`@openai/codex-linux-x64`
- Linux arm64：`@openai/codex-linux-arm64`
- macOS Intel：`@openai/codex-darwin-x64`
- macOS Apple Silicon：`@openai/codex-darwin-arm64`

## 手动同步

需要覆盖当前本机 Codex 初始化文件时，先检查差异，再复制：

```bash
diff -u "$HOME/.codex/AGENTS.md" codex-home/AGENTS.md
diff -u "$HOME/.codex/RTK.md" codex-home/RTK.md
diff -u "$HOME/.codex/path.sh" codex-home/path.sh

cp codex-home/AGENTS.md "$HOME/.codex/AGENTS.md"
cp codex-home/RTK.md "$HOME/.codex/RTK.md"
cp codex-home/path.sh "$HOME/.codex/path.sh"
```

## 不纳入仓库

- 官方自带的 `.system` skills
- 自动安装或自动更新的 skill/plugin 目录
- 私有项目 skills
- Codex 会话、记忆、缓存、shell snapshots
- 本机 `config.toml` 里的项目 trust 列表和其他本地状态

## 维护原则

- 初始化文件以当前充分验证的 `$HOME/.codex` 内容为准
- skill 只维护裁剪范围记录，不默认备份 skill 内容
- 不写入任何明文密钥、令牌、密码
- 不新增自动安装或自动更新流程，除非另有明确决定
