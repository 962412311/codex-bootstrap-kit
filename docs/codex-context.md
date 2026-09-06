# Codex 上下文维护

规则层和运行环境注入层分别维护。本文以 2026-09-06 的 Codex 0.153.4 验证为基准。

## 加载关系

| 来源 | 用途与加载方式 |
|---|---|
| `~/.codex/AGENTS.md` | 全局默认约定，原生自动加载 |
| `BOOTSTRAP.md` | 兼容旧引用，指向同一份默认约定，已加载则跳过 |
| `GLOBAL-AGENT.md` | 按需索引，定位单个规则文件 |
| `global-rules/` | 按任务读取的短细则，保留旧路径兼容性 |
| `KARPATHY-INTEGRATION.md` 与 vendor | 原则来源与范围，按需读取，vendor 原文不改 |
| 项目规则 | Codex 原生的项目/目录指令与项目明确指定的局部规则 |
| 记忆、技能目录、插件工具、内置提示词 | 由客户端和运行配置独立提供，不受 Markdown 中“不要加载”的文字控制 |

`AGENTS.md` 里的 `@` 路径只是文本引用，当前原生渲染器不会把它展开成文件正文。因此默认约定直接放在 AGENTS.md，避免每个任务都先读一次 BOOTSTRAP.md。

## 记忆

需要轻量启动且保留后台记忆生成时，合并到本机已有配置：

```toml
[features]
memories = true

[memories]
use_memories = false
```

此设置停止默认注入既有记忆，`generate_memories` 保留原设置；历史相关任务通过 AGENTS.md 中的检索指引按需查找。不要直接编辑生成的摘要和索引来控制加载。

已有外部上下文过滤设置时，正式键名为 `disable_on_external_context`；旧名 `no_memories_if_mcp_or_web_search` 是兼容别名，不应同时维护两个键。它控制记忆生成资格，与启动注入开关不同。

配置更新用于后续初始化。已有任务中的消息不会被删除；客户端或任务级覆盖仍可能改变最终行为。重启客户端后使用新任务确认。

## 验证与维护

- 用当前客户端附带的 Codex 二进制验证，避免启动 wrapper 的更新或同步副作用。
- `codex debug prompt-input` 可查看静态注入的 AGENTS 与技能目录；它不等同于完整桌面请求，不包含全部内置指令、工具 schema 或动态记忆。
- 原生 app-server 的 `config/read` 可核实 `memories.use_memories` 及来源；不要输出完整配置中的凭据。
- 文本大小按字节或字符比较，并注明范围；不要把 Markdown 压缩率称为整个会话的 token 降幅。
- 规则修改后同步 `codex-home/`，重新打包并在临时目标部署，验证路径、内容与校验和；不要用部署测试覆盖当前运行环境。
- 本地技能只精简选择描述及必要的过期说明，详细操作按需保留。系统技能和版本化插件缓存交由各自更新机制维护。

增加默认规则前确认：它是否跨项目、是否会改变行为、是否已由运行环境或现有规则覆盖。具体主机、账号定位、历史事故与长流程放项目资料或按需入口。

## 参考

- [官方 AGENTS.md 加载规则](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [官方配置参考](https://learn.chatgpt.com/docs/config-file/config-reference)
- [官方本地记忆说明](https://learn.chatgpt.com/docs/customization/memories)
