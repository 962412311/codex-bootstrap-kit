# Codex Tooling

这个仓库维护当前已验证的 Codex 初始化工具集和全局 Agent 规则树。
它可以用于在新环境中复现 `$HOME/.codex` 下的全局 Agent 入口及其
子结构，但不是完整的 `$HOME/.codex` 运行态备份，也不负责自动安装
或更新 skills。

## 内容

- [codex-home/AGENTS.md](codex-home/AGENTS.md)：Codex 初始化 Agent 规则入口
- [codex-home/BOOTSTRAP.md](codex-home/BOOTSTRAP.md)：新会话默认加载的压缩启动规则
- [codex-home/GLOBAL-AGENT.md](codex-home/GLOBAL-AGENT.md)：按需读取的完整全局规则总纲
- [codex-home/KARPATHY-INTEGRATION.md](codex-home/KARPATHY-INTEGRATION.md)：Karpathy vendor 原则与本地规则的作用域说明
- [codex-home/RTK.md](codex-home/RTK.md)：RTK 命令代理约定
- [codex-home/path.sh](codex-home/path.sh)：Codex PATH 与 `apply_patch` wrapper 配置
- [codex-home/global-rules/](codex-home/global-rules/)：按任务类型拆分的全局规则树
- [codex-home/vendor_imports/andrej-karpathy-skills/](codex-home/vendor_imports/andrej-karpathy-skills/)：代码任务按需引用的公开 vendor import，排除其 `.git/`
- [scripts/codex-agent-tree/package.sh](scripts/codex-agent-tree/package.sh)：把 `codex-home/` 打成部署包
- [scripts/codex-agent-tree/deploy.sh](scripts/codex-agent-tree/deploy.sh)：从源码树或部署包白名单覆盖 `$HOME/.codex`
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

## 打包

生成可直接部署的归档包：

```bash
scripts/codex-agent-tree/package.sh
```

默认输出：

- `dist/codex-global-agent-tree.tar.gz`
- `dist/codex-global-agent-tree.tar.gz.sha256`
- `dist/codex-global-agent-tree.files`

## macOS 兼容性

打包和部署脚本按 macOS 默认环境编写，不需要 GNU coreutils：

- shell：`/bin/sh`
- 打包/解包：系统 `tar`
- 临时目录：系统 `mktemp`
- 覆盖同步：系统 `rsync`
- 校验：优先使用系统 `shasum`

打包和解包时会设置 `COPYFILE_DISABLE=1`，避免 macOS AppleDouble
元数据进入归档或恢复目录。

## 覆盖部署

从当前源码树覆盖部署到当前用户的 `$HOME/.codex`：

```bash
scripts/codex-agent-tree/deploy.sh
```

从打包产物覆盖部署：

```bash
scripts/codex-agent-tree/deploy.sh --archive dist/codex-global-agent-tree.tar.gz
```

部署到其他目标目录：

```bash
scripts/codex-agent-tree/deploy.sh --archive dist/codex-global-agent-tree.tar.gz --target /path/to/.codex
```

部署脚本只覆盖以下白名单路径：

- `AGENTS.md`
- `BOOTSTRAP.md`
- `GLOBAL-AGENT.md`
- `KARPATHY-INTEGRATION.md`
- `RTK.md`
- `path.sh`
- `global-rules/`
- `vendor_imports/andrej-karpathy-skills/`

它不会删除或覆盖 `auth.json`、`config.toml`、`state*.sqlite*`、`sessions/`、
`memories/`、`cache/`、`plugins/` 等 Codex 运行态文件。

## 差异检查

需要确认仓库归档与当前本机全局 Agent 文件树一致时，执行：

```bash
diff -u "$HOME/.codex/AGENTS.md" codex-home/AGENTS.md
diff -u "$HOME/.codex/BOOTSTRAP.md" codex-home/BOOTSTRAP.md
diff -u "$HOME/.codex/RTK.md" codex-home/RTK.md
diff -u "$HOME/.codex/path.sh" codex-home/path.sh
diff -u "$HOME/.codex/GLOBAL-AGENT.md" codex-home/GLOBAL-AGENT.md
diff -u "$HOME/.codex/KARPATHY-INTEGRATION.md" codex-home/KARPATHY-INTEGRATION.md
diff -qr -x .DS_Store "$HOME/.codex/global-rules" codex-home/global-rules
diff -qr -x .git -x .DS_Store "$HOME/.codex/vendor_imports/andrej-karpathy-skills" \
  codex-home/vendor_imports/andrej-karpathy-skills
```

## 验证

恢复或更新后，至少执行：

```bash
zsh -n "$HOME/.codex/path.sh"
find codex-home -type f | sort
diff -u "$HOME/.codex/AGENTS.md" codex-home/AGENTS.md
diff -u "$HOME/.codex/BOOTSTRAP.md" codex-home/BOOTSTRAP.md
diff -u "$HOME/.codex/GLOBAL-AGENT.md" codex-home/GLOBAL-AGENT.md
diff -u "$HOME/.codex/KARPATHY-INTEGRATION.md" codex-home/KARPATHY-INTEGRATION.md
diff -u "$HOME/.codex/RTK.md" codex-home/RTK.md
diff -u "$HOME/.codex/path.sh" codex-home/path.sh
```

## 不纳入仓库

- 官方自带的 `.system` skills
- 自动安装或自动更新的 skill/plugin 目录
- 私有项目 skills
- Codex 会话、记忆、缓存、shell snapshots
- `auth.json`、`config.toml`、`state*.sqlite*`
- 本机 `config.toml` 里的项目 trust 列表和其他本地状态
- vendor import 里的 `.git/`

## 维护原则

- 初始化文件和全局规则以当前充分验证的 `$HOME/.codex` 内容为准
- `codex-home/` 原样镜像当前全局 Agent 文件树，不额外改写路径
- skill 只维护裁剪范围记录，不默认备份 skill 内容
- 不写入任何明文密钥、令牌、密码
- 不新增自动安装或自动更新流程，除非另有明确决定
