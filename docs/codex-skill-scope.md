# Skill 与插件范围

2026-09-06 的本机维护决定如下。运行配置不随本仓库部署，实际加载以客户端为准。

| 类别 | 状态 |
|---|---|
| `arm-crosscompile-test`、`neat-freak` | 保留。分别提供具体 ARM 环境知识与文档同步能力 |
| `chronicle`、`hatch-pet`、`imagegen-game-art-pipeline` | 用户确认停用，文件留存 |
| `stage-based-execution`、`karpathy-guidelines` | 通用流程重复，停用自动加载；原资料留存 |
| `docx`、`pdf`、`mcp-builder` 本地技能 | 沿用停用状态 |
| `template-creator`、`visualize` | 用户确认停用 |
| `superpowers` | 停用，避免重新带入重复的全局流程 |
| `deep-research-work` | 用户明确保留 |
| 浏览器、桌面操作、GitHub、Codex 管理及插件管理 | 保留常用开发和操作能力 |
| 官方系统技能 | 由客户端维护，保留 |

本地 `skills.config` 使用实际 SKILL.md 路径。账户侧预置插件不能仅凭本地 enabled 标记判定已停用；默认模板库通过其连接器 `connector_openai_default_templates` 的开关控制，并核实有效状态。

本仓库只保留公开 Karpathy 原文，不复制私有技能、插件缓存、凭据、会话或记忆。停用时优先保留可恢复文件；重新安装或升级后，用原生技能和插件清单检查实际加载结果。
