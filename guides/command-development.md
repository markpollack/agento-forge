# Forge Command Development Guide

How to develop, maintain, and sync the `/forge-*` Claude Code slash commands.

## Architecture

All forge commands live in two locations:

| Location | Role |
|----------|------|
| `~/projects/agento-forge/.claude/commands/` | Git-tracked source of truth |
| `~/.claude/commands/` | Active deployment (Claude Code reads these) |

The two copies are **identical**. User-specific paths are resolved at runtime via environment variables, not hardcoded in the files.

## Environment Variables

Set in `~/.bashrc` (or `~/.zshrc`):

```bash
# Forge methodology env vars (used by /forge-* Claude Code commands)
export AGENTO_FORGE_HOME=~/projects/agento-forge
export AGENT_EXPERIMENT_HOME=~/projects/agent-experiment
export AGENT_EXPERIMENT_TEMPLATE_HOME=~/projects/agent-experiment-template
```

Commands reference these via `{agento-forge}` placeholders in the prose and a Configuration table at the top. Optional vars (e.g., `ARXIV_BATCH_PIPELINE`, `KB_FEDERATION_FILE`) are only needed by specific commands.

## Development Workflow

### Iterating on a command

1. **Edit the agento-forge copy** (git-tracked):
   ```bash
   $EDITOR ~/projects/agento-forge/.claude/commands/forge-project.md
   ```

2. **Copy to the active deployment**:
   ```bash
   cp ~/projects/agento-forge/.claude/commands/forge-project.md ~/.claude/commands/
   ```

3. **Verify** they match:
   ```bash
   diff ~/.claude/commands/forge-project.md ~/projects/agento-forge/.claude/commands/forge-project.md
   ```

4. **Test** by running the command in a Claude Code session.

5. **Commit** in agento-forge when satisfied.

If you prefer to iterate in `~/.claude/commands/` first (faster test loop), reverse the copy direction in step 2 before committing.

### Bulk sync check

```bash
for f in forge-project forge-research forge-steward forge-research-kb forge-kb forge-eval-agent plan-to-roadmap; do
  diff -q ~/.claude/commands/$f.md ~/projects/agento-forge/.claude/commands/$f.md 2>&1
done
```

No output = all identical.

## Adding a New Command

1. Create the file in `~/projects/agento-forge/.claude/commands/{name}.md`
2. Use the env-var Configuration pattern (copy from any existing forge command)
3. Copy to `~/.claude/commands/`
4. Test in a Claude Code session

## Configuration Section Pattern

Every command should have a Configuration section that follows this pattern:

```markdown
## Configuration

Paths are resolved via environment variables. Set these before running the command,
or add them to your shell profile.

| Variable | Default | Description |
|----------|---------|-------------|
| `AGENTO_FORGE_HOME` | `$HOME/projects/agento-forge` | Root of the agento-forge checkout |

**Path references in this command use placeholders**:
- `{agento-forge}` → `$AGENTO_FORGE_HOME`
```

## Cross-References

Commands reference agento-forge content (templates, concepts, variant docs, phase definitions) via `{agento-forge}/path` placeholders. When agento-forge content moves or renames, grep all commands for the old path:

```bash
grep -r "old-filename" ~/projects/agento-forge/.claude/commands/
```

## Keeping Commands in Sync with Upstream

When the libraries that commands reference (agent-experiment-template, agent-workflow, agent-client, agent-journal) change their Maven coordinates, APIs, or class names:

1. Read the template's `pom.xml` for current artifact names and groupIds
2. Update the dependency snippet in `forge-eval-agent.md` (the only command with Maven dependency guidance)
3. Update the SDK choice table in `forge-eval-agent.md` if invoker classes changed
4. Copy to `~/.claude/commands/`

The canonical source for current dependency versions is always `~/projects/agent-experiment-template/pom.xml`.

## History

- **2026-06-01**: Migrated all commands from hardcoded paths to env vars. Eliminated the two-copy divergence pattern where agento-forge had generic paths and ~/.claude/ had personalized paths. Now identical everywhere.
- **Pre-migration**: agento-forge copies used relative paths or "expects to run from repo root" notes. ~/.claude/ copies had absolute `/home/mark/...` paths. Required manual sync with path stripping.
