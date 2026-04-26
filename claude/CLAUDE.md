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

## Tool Usage
- Prefer built-in tools (Read, Glob, Grep, LS) over Bash; if the Bash equivalent would require a permission prompt, always use the built-in.
