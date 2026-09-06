# 默认上下文维护

目标是保留必要偏好与专项能力，避免通用流程替模型重复做决定。2026-09-06 的第二轮审查已移除旧的 17 份通用细则。

## 加载关系

- `AGENTS.md` 原生自动加载，保存默认中文、目标导向、自主判断与历史检索入口。
- `BOOTSTRAP.md`、`GLOBAL-AGENT.md` 保留旧引用兼容性，不再要求读取规则树。
- `global-rules/README.md` 保留部署目录结构，避免旧部署脚本失效；不恢复历史通用要求。
- Karpathy 原文保留为可选资料，不作为代码任务的额外强制层。
- 技能和插件是独立的加载来源；是否停用看有效配置与实际目录，不能仅看文件是否还在。

## 本机配置

已有记忆配置继续使用 `memories.use_memories = false`，保留生成与按需检索。实际停用项目见 [技能与插件范围](codex-skill-scope.md)。本仓库的部署脚本不覆盖 `config.toml`。

本地技能用 `[[skills.config]]` 的 `path` 和 `enabled = false` 停用。插件配置与账户侧状态可能不同；默认模板连接器使用 `[apps.connector_openai_default_templates] enabled = false` 控制。不要通过删除版本化缓存冒充功能关闭，也不要把卸载失败报告为成功。

## 验证与生效

- 用当前客户端附带二进制的 `debug prompt-input` 检查全局偏好与静态技能目录，用 `plugin list --json` 检查插件状态。
- `app-server config/read` 显示配置值及来源；结合 `app/installed` 的可调用快照核对连接器是否暴露。元数据存在不代表功能已启用，快照缺席也不能替代有效配置检查。输出时只保留相关字段。
- 静态提示词不包含全部桌面内置提示词、工具定义或动态记忆；字节和字符变化不能称为完整会话 token 降幅。
- 检查引用、技能格式、归档内容与本机镜像。保留旧版本或本机备份以便恢复。
- 配置用于后续初始化。重启客户端并使用新任务确认；当前任务已保存的上下文不会被删除。

通用建议可以按任务需要调整。具体的数据契约、设备操作条件和当前用户要求仍需据实判断，不把“最少改动”“固定阶段”“固定文档目录”作为完成目标的替代指标。

## 官方依据

- [AGENTS.md 加载规则](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [配置参考](https://learn.chatgpt.com/docs/config-file/config-reference)
- [本地记忆](https://learn.chatgpt.com/docs/customization/memories)
