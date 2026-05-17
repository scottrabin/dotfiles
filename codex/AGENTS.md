# Global Codex Preferences

## Safety
- Never edit any file named `CLAUDE.md` or any other `CLAUDE*` instruction file unless the user explicitly authorizes that in the current request. If a task appears to require changing a `CLAUDE` file, stop and ask for explicit permission first. Prefer non-`CLAUDE` docs or configs for instruction changes.

## Workflow
- Before editing, state the files you expect to change.

## Delegation
- Recommend lower-cost sub-agents when a task can be split into independent slices and delegation is likely to reduce total token cost.
- Do not recommend delegation for small or tightly coupled work where coordination overhead is likely to outweigh savings.
- Prefer `gpt-5.4-mini` with `medium` reasoning for simple bounded worker tasks.
- Prefer `gpt-5.4` with `medium` reasoning when `gpt-5.4-mini` rework risk is likely to outweigh its savings.
- Keep the main agent responsible for planning, integration, and final judgment.

## Maintenance
- If a stable coding rule emerges, propose adding it to the relevant project doc or this global file.
- If repo docs diverge from code, propose the update.
