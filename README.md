# standard-linter

Central formatter, linter, and type/bug-check configuration for multiple
repositories. Consumer repos pull configs on demand — no submodules, no
vendored tooling. Enforces a stable, uniform policy in CI and locally,
especially for AI-generated code.

---

## Install in a new repo (3 steps)

### Step 1 — Run bootstrap

From the root of your repo:

```bash
curl -fsSL https://raw.githubusercontent.com/maxjiang216/standard-linter/main/scripts/bootstrap.sh | bash
```

This creates four files and populates `.code-standards/` (which is gitignored):

```
your-repo/
├── .pre-commit-config.yaml        ← pre-commit hooks for all languages
├── .github/
│   └── workflows/
│       └── code-standards.yml    ← CI workflow (calls this repo's reusable workflow)
├── CLAUDE.md                     ← coding conventions for AI agents
└── scripts/
    └── lint.sh                   ← local lint runner
```

### Step 2 — Set your language flags

Open `.github/workflows/code-standards.yml`. It looks like this:

```yaml
name: Code Standards

on:
  pull_request:
  push:
    branches: [main]

jobs:
  standards:
    uses: maxjiang216/standard-linter/.github/workflows/standards.yml@main
    with:
      python: true      # ← set true/false for each language your repo uses
      cpp: false
      rust: false
      javascript: false
      go: false
      bash: true
```

Set each flag to `true` or `false`. The defaults are `python: true, bash: true`;
everything else is `false`. Only enabled languages run in CI.

### Step 3 — Commit

```bash
git add .pre-commit-config.yaml \
        .github/workflows/code-standards.yml \
        CLAUDE.md \
        scripts/lint.sh
git commit -m "chore: add standard-linter"
```

Push. CI will run on your next pull request.

---

## Running checks locally

```bash
bash scripts/lint.sh              # check everything
bash scripts/lint.sh --fix        # auto-fix formatting, then re-check
bash scripts/lint.sh --lang go    # check one language only
```

Missing tools are skipped with an install hint — no errors if a tool isn't
installed locally.

---

## For AI agents

Run `bash scripts/lint.sh` before every commit. Run `bash scripts/lint.sh --fix`
first to auto-fix formatting, then address remaining errors manually. See
`CLAUDE.md` for naming conventions, comment style, and language-specific rules.

---

## Tools per language

| Language | Format | Lint | Type / bug check |
|---|---|---|---|
| Python | ruff | ruff | mypy (strict) |
| C++ | clang-format | clang-tidy | cppcheck |
| Rust | rustfmt | clippy | — |
| JavaScript / TypeScript | prettier | eslint | tsc --noEmit |
| Go | gofmt | golangci-lint v2 | — |
| Bash | — | shellcheck | — |

## Style defaults

| Language | Line length | Indent | Quotes |
|---|---|---|---|
| Python | 80 | 4 spaces | double |
| C++ | 80 | 2 spaces | — |
| Rust | 80 | 4 spaces | — |
| JavaScript / TypeScript | 80 | 2 spaces | double |
| Go | 80 | tabs (gofmt) | — |
| Bash | 80 | 2 spaces | — |

---

## Versioning

The bootstrap default is `@main`. Once this repo is stable, pin to a tag so
updates are intentional:

```yaml
uses: maxjiang216/standard-linter/.github/workflows/standards.yml@v1
```

---

## Working inside this repo

```bash
bash scripts/bootstrap.sh --configs-only   # populate .code-standards/
pre-commit install
bash scripts/lint.sh
```

See [RELEASING.md](RELEASING.md) for how to cut a version tag.
