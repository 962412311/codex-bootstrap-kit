# Codex Skill Scope

This repository packages the public Karpathy vendor import used by its global
rules. It does not install or archive other skills, plugins, or runtime state.

## Local maintenance scope

The local skill entrypoints reviewed on 2026-09-06 are:

- `arm-crosscompile-test`: the configured QtWorkData ARM host workflow.
- `chronicle`: screen-history lookup, subject to runtime prerequisites.
- `hatch-pet`: Codex v2 animated pet creation and validation.
- `imagegen-game-art-pipeline`: generated game art and asset delivery.
- `neat-freak`: project documentation and handoff reconciliation.
- `stage-based-execution`: repeatable operations with verifiable stages.
- `karpathy-guidelines`: the public vendor principles, preserved unchanged.

Skill names and descriptions can enter initial context; skill bodies and
references should be loaded only for matching work. Keep descriptions short
and specific. Generic commands such as Git or SSH do not identify an ARM
deployment task.

## Boundaries

The active catalog is supplied by each client. Do not treat a historical list
as an allowlist, restore removed skills from it, or edit versioned plugin
caches to change discovery. Local skill edits need separate maintenance;
review them when reinstalling or updating their source packages.

Official `.system` skills, automatically managed skills/plugins, private
project skills, memories, sessions, caches, credentials and trust settings
are excluded from this repository. The vendor import excludes its `.git/`.

Record scope changes here; do not copy additional skill contents into the
repository without an explicit decision to vendor them.
