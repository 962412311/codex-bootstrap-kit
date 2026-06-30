# 03-priority

## 目的
本文件定义规则冲突时的优先级，防止执行过程中随意解释或混用规范。

---

## 优先级顺序
默认情况下，发生冲突时按以下顺序执行：

1. 用户当前明确指令
2. `.agent/local/90-project-specific.md`
3. 对应任务模块规范
4. `$HOME/.codex/global-rules/core/*`
5. `$HOME/.codex/GLOBAL-AGENT.md`
6. 通用最佳实践

上层覆盖下层，局部覆盖全局，明确要求覆盖默认偏好。

### 代码任务的特殊优先级层
当任务属于代码相关工作（写代码、改代码、调试、修 bug、重构、测试、评审、构建修复、影响软件行为的配置修改）时，在第 2 层与第 3 层之间插入 Karpathy 层：

1. 用户当前明确指令
2. `.agent/local/90-project-specific.md`
3. `$HOME/.codex/vendor_imports/andrej-karpathy-skills/CLAUDE.md`
4. `$HOME/.codex/KARPATHY-INTEGRATION.md`
5. 对应任务模块规范
6. `$HOME/.codex/global-rules/core/*`
7. `$HOME/.codex/GLOBAL-AGENT.md`
8. 通用最佳实践

对代码任务：
- `dev/*`、`delivery/*`、`core/*` 默认作为执行细则，而不是首要行为总纲
- 不得用本地执行细则反向覆盖 Karpathy 的显式假设、简单优先、手术式改动、目标驱动验证

---

## 冲突处理原则

### 1. 不自行折中
当两个规则冲突时，不要擅自发明第三套折中规则。应直接按优先级执行。

### 2. 不因个人偏好覆盖项目规范
如果个人习惯、通用建议与项目约定冲突，优先遵守项目约定。

### 3. 无局部规范时，回退到上层
如果 `.agent/local/90-project-specific.md` 不存在或未覆盖当前问题，则回退到对应模块规范。

### 4. 规范缺失时，先补最小规则
若现有规范无法覆盖当前场景，不要直接自由发挥。应先补最小规则，再继续执行。

---

## 适用说明
- 本文件适用于开发、文档、知识管理、Git、部署等所有任务类型
- 读取顺序应尽量靠前
- 执行时如出现歧义，先查本文件，再查对应模块
