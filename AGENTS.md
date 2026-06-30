# Repository Maintenance Notes

这个仓库用于维护当前已验证的 Codex 初始化工具集。

约定：

- `codex-home/` 只放需要手动同步到 `$HOME/.codex` 的初始化文件
- `docs/codex-skill-scope.md` 只记录裁剪后的 skill 范围，不备份 skill 内容
- 官方自带 `.system` skills 不纳入仓库
- 自动安装或自动更新的 skill/plugin 目录不纳入仓库
- 私有项目 skills、会话、记忆、缓存、shell snapshots 不纳入仓库
- 不要把任何明文密钥、令牌、密码写进仓库文件
- Git 登录建议使用本机的 credential helper 管理，不要把凭据固化进文档
- 提交信息尽量短而明确，方便后续按 Codex 初始化文件回溯

修改 `codex-home/` 下文件时，应先和当前 `$HOME/.codex` 对应文件对比，确认这是经过验证的有效配置。
