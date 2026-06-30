# Codex Skill Scope

This repository does not back up or install automatically managed skill
contents. It records the curated local scope that is expected in the active
Codex environment, and separately archives the public Karpathy vendor import
referenced by the global Agent rule tree.

## Tracked Scope

The following non-system skill names are allowed in the current local Codex
setup:

- `doc-coauthoring`
- `docx`
- `mcp-builder`
- `modbus-semantics`
- `mthings-config`
- `mthings-to-ini`
- `mthings-xml-config`
- `neat-freak`
- `patch-context-hygiene`
- `pdf`
- `pptx`
- `protocol-alarm-records`
- `protocol-business-cropping`
- `protocol-config-audit`
- `protocol-excel-point-table`
- `protocol-modeling`
- `protocol-reporting`
- `protocol-source-intake`
- `protocol-write-points`
- `test-driven-development`
- `web-access`
- `xlsx`

## Explicitly Not Backed Up

- Official Codex system skills under `.system`, including `imagegen`,
  `openai-docs`, `plugin-creator`, `skill-creator`, and `skill-installer`.
- Automatically installed or auto-updated skill/plugin trees.
- Private project skills and project-specific runtime snapshots.
- Codex session history, memories, shell snapshots, caches, and local trust
  entries from `config.toml`.
- The `.git/` directory inside `vendor_imports/andrej-karpathy-skills/`.

## Maintenance Rule

If the active local skill list changes, update this document as a scope record
only. Do not copy skill directories into this repository unless there is a
separate explicit decision to vendor a specific public skill or public vendor
import used by the global Agent rule tree.
