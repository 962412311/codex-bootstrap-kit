@RTK.md

Global patch rule: always use the `patch-context-hygiene` skill before any file edit, even on the first attempt. Re-read the exact target file block from the current workspace state before every `apply_patch`, verify the target path spelling/casing/workspace root first, and if a patch fails, fetch fresh context and retry with a smaller hunk instead of reusing stale lines.
