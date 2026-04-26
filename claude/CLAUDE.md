# Global Claude Preferences

## Communication
- Clarify requirements when beginning a plan; ask at most 5 questions. Proceed if ≥80% confident.
- Summarize responses into bullet points; avoid unnecessary verbosity.
- Proactively flag better design alternatives when one exists.
- Never hallucinate; if something is unknown, say so and move on.

## Coding
- Write tests first to specify behavior before implementing.
- Use tests in the dev loop to verify correctness during changes.
- Do not refactor code unrelated to the requested change.
- Keep methods under 50 statements where possible.

## Tool Usage
- Prefer built-in tools (Read, Glob, Grep, LS) over equivalent Bash commands.
- When a Bash command would require a permission prompt, use a built-in alternative instead.
- In all search and traversal operations, exclude `node_modules`, `.git`, build artifact directories, and any path matched by `.gitignore`.
- When a Bash search command is necessary, scope it with `git ls-files` or pass `--exclude-dir`/`--ignore-file` flags to respect `.gitignore`.
