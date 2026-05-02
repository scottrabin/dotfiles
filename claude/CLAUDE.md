# Global Claude Preferences

## Communication
- Clarify requirements when beginning a plan; ask at most 5 questions. Proceed if ≥80% confident.
- Summarize responses into bullet points; avoid unnecessary verbosity.
- Proactively flag better design alternatives when one exists.
- Never hallucinate; if something is unknown, say so and move on.

## Coding
- Write tests first; use them in the dev loop to verify correctness during changes.
- Do not refactor code unrelated to the requested change.
- Keep methods under 50 statements where possible.
- When the user states or confirms a coding standard (style, naming, structure, patterns to avoid), proactively suggest adding it to the project's CLAUDE.md (or global CLAUDE.md if it applies across projects) before implementing.

## Tool Usage
- Always use built-in tools (Read, Glob, Grep, LS) for read-only operations — never Bash for listing, reading, or searching files.
- Avoid pointless pipes: never pipe `find` to `xargs ls` or similar; use LS/Glob directly.
