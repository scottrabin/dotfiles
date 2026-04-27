---
name: reflect
description: Analyze the current session (or session + history) and propose targeted updates to global/local Claude settings and CLAUDE.md files. Use when user invokes /reflect, asks to reflect on the session, or wants to tune future Claude sessions.
argument-hint: [session|history]
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
---

# Reflect

Analyze the session and propose targeted updates to Claude settings and CLAUDE.md files that make future sessions more productive and token-efficient.

**Scope boundary**: Cover settings.json and CLAUDE.md only. Do NOT touch or propose changes to auto-memory files (`~/.claude/projects/*/memory/`) — those are maintained by the memory system. Do not add to CLAUDE.md content that belongs in memory (user profile facts, per-session feedback, project state).

**Global vs. local**:
- Global (`~/.claude/`) — cross-project user preferences; how Claude should behave regardless of repo
- Local (`./CLAUDE.md`, `./.claude/settings.json`) — project-specific facts all contributors share; no personal preferences

## Step 0: Parse argument

`$ARGUMENTS` is `session` (default if empty) or `history`.

If `history`: before proceeding, ask the user to confirm ("Analyze past session transcripts for this project too? This may use additional tokens."). Wait for confirmation. If declined, fall back to `session` mode.

## Step 1: Read existing configuration

Read these files (skip gracefully if absent):

- `~/.claude/CLAUDE.md`
- `~/.claude/settings.json`
- `./CLAUDE.md`
- `./.claude/settings.json`

Note which sections and allow-rules already exist — proposals that duplicate existing config should be skipped.

## Step 2: Locate past transcripts (history mode only)

```bash
project_key=$(pwd | sed 's|/|-|g' | sed 's/^-//')
ls ~/.claude/projects/$project_key/ 2>/dev/null | sort -r | head -10
```

Read the 5 most recent transcript files. Scan for patterns that are absent from the current session (recurring permission prompts, repeated file reads, recurring exploratory chains). Limit transcript reading to avoid token waste — read each file once, extract relevant events, then discard.

## Step 3: Run analysis passes

Work through these passes over the current conversation (and transcripts if history mode). Record concrete evidence for each finding — a vague "Claude explored the codebase" is not sufficient; cite specific tool calls or exchanges.

### Pass 1 — Permission prompts → allowlist candidates

Identify tools that required user approval this session. A tool call that required approval but is safe and routine is a strong candidate for `permissions.allow`.

- Read-only, cross-project tools (Read, Glob, Grep, LS, `Bash(find:*)`) → global settings
- Project-specific commands (`Bash(make:*)`, `Bash(npm test:*)`) → local settings
- Skip anything that was legitimately risky (destructive ops, external network calls with side effects)

### Pass 2 — Repeated file reads → CLAUDE.md documentation candidates

Identify files read more than once in the session. Key facts from those files may belong in CLAUDE.md so future sessions don't re-read them.

- Project config/architecture files → local CLAUDE.md
- Do not paste raw file content into CLAUDE.md; distill the essential fact (e.g., "Build: `make`" not the whole Makefile)

### Pass 3 — Exploratory chains → missing architecture docs

Look for sequences of 3+ Grep/Bash/LS/Glob calls made to answer a single structural question ("where is X?", "how does Y work?"). Each such chain signals a gap in local CLAUDE.md architecture documentation.

For each gap: propose a concise addition (1–4 lines) that would have short-circuited the exploration.

### Pass 4 — Communication friction → instruction candidates

Look for exchanges where:
- Claude asked a clarifying question and the user gave a simple factual answer → that fact may belong in CLAUDE.md
- Claude proposed an approach and the user redirected with a preference about *how* to work, not *what* to do → candidate for global CLAUDE.md

Do NOT capture here: corrections about user's personal situation or past experiences (→ memory), or one-off decisions specific to this task.

### Pass 5 — Token waste → efficiency improvements

Look for:
- Large file reads where a targeted grep would have sufficed → Bash allowlist or CLAUDE.md guidance
- Multiple subagent spawns for queries that didn't need isolation → note for global CLAUDE.md tool-usage guidance
- Questions answered early in session that Claude re-derived later → CLAUDE.md completeness gap

## Step 4: Deduplicate and filter

For each candidate proposal:
1. Check if it duplicates existing config or CLAUDE.md content → drop it
2. Check if it belongs in auto-memory instead of CLAUDE.md → drop it (memory covers: user profile, per-correction feedback, project state, external resource pointers)
3. Verify it's grounded in specific session evidence → drop it if not

## Step 5: Output structured proposals

Present ALL proposals before asking for confirmation. Use this format exactly:

---

```
## Reflect: Session Analysis

**Scope**: [session | session + N past transcripts]
**Proposals**: X global, Y local
**Primary gain**: [one sentence — the most impactful single change]

---

### Global Changes (~/.claude/)

#### settings.json
**Evidence**: [cite specific tool call or exchange]
```diff
 "permissions": {
   "allow": [
+    "Bash(find:*)"
   ]
 }
```

#### CLAUDE.md
**Evidence**: [cite specific exchange]
```diff
+## Tool Usage
+- [new rule]
```

---

### Local Changes (./)

#### CLAUDE.md
**Evidence**: [cite]
```diff
+## Architecture
+- [key fact that would have avoided re-exploration]
```

#### .claude/settings.json  _(create if absent)_
**Evidence**: [cite]
```diff
+{
+  "permissions": {
+    "allow": ["Bash(make:*)"]
+  }
+}
```

---

**Recommendation**: Apply all [X] proposals. To skip any, name them (e.g., "skip the settings.json change").
```

---

## Step 6: Apply approved changes

After the user responds:
- If "apply all" or equivalent: apply every proposal
- If selective: apply only the named ones, skip the rest
- Use Edit for existing files; append or insert minimally — do not restructure
- Use Write to create `.claude/settings.json` if it doesn't exist (create `.claude/` dir first with Bash if needed)
- Report each change applied in one line: `✓ ~/.claude/settings.json — added Bash(find:*) to allowlist`
