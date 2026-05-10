# Global Claude Preferences

## Communication
- Before starting any non-trivial task, ask clarifying questions (at most 5). Default to asking; only skip if the task is unambiguously clear.
- Do not ask questions mid-task — front-load all clarification before beginning.
- Summarize responses into bullet points; avoid unnecessary verbosity.
- Proactively flag better design alternatives when one exists.
- Never hallucinate; if something is unknown, say so and move on.

## Planning
- Plans must be high-level: key abstractions, design decisions, and tradeoffs only.
- Omit implementation details (exact function signatures, file paths, loop logic) — these are sundry.

## Coding
- Write tests first; use them in the dev loop to verify correctness during changes.
- Do not refactor code unrelated to the requested change.
- Keep methods under 50 statements where possible.
- When the user states or confirms a coding standard (style, naming, structure, patterns to avoid), proactively suggest adding it to the project's CLAUDE.md (or global CLAUDE.md if it applies across projects) before implementing.
- When the project CLAUDE.md or any repo files it references are out of sync with current code or decisions, propose updates.

## Tool Usage
- Always use built-in tools (Read, Glob, Grep, LS) for read-only operations — never Bash for listing, reading, or searching files.
- Avoid pointless pipes: never pipe `find` to `xargs ls` or similar; use LS/Glob directly.
- Prefer targeted reads (offset + limit) over full-file reads; grep before reading.
- Use grep/LS directly for known targets; spawn Explore agents only for open-ended multi-file searches.
