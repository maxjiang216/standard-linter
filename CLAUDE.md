# standard-linter

This repo ships linting/formatting configs and tooling to other repos.
There is no runtime code here — no compiled binaries, no Python packages.

## Before every commit

**Always run `bash scripts/lint.sh` before committing.** This repo lints its
own shell scripts via shellcheck, and CI will reject anything it catches. Do
not rely on CI to find errors — fix them locally first.

```bash
bash scripts/lint.sh --fix   # auto-fix what can be fixed
bash scripts/lint.sh         # confirm everything passes
git add ...
git commit ...
```

If `.code-standards/` is missing (fresh clone), set it up once:

```bash
bash scripts/bootstrap.sh --configs-only
```

## Structure

- `configs/<lang>/` — source config files, distributed to consumer repos
- `consumer-templates/` — files bootstrap.sh copies into consumer repos
- `scripts/bootstrap.sh` — run once in a consumer repo to set it up
- `scripts/lint.sh` — primary lint runner for AI agents and local use
- `.github/workflows/standards.yml` — reusable workflow called by consumer repos

## The three lists that must stay in sync

When you add or rename a config file, update all three places:

1. `configs/<lang>/` — the file itself
2. `scripts/bootstrap.sh` — the `curl` download step
3. `.github/workflows/standards.yml` — the "Download standards configs" step

## Adding a new language

1. Create `configs/<lang>/` with the tool config file(s)
2. Add a `bash` input (boolean, default true) to `standards.yml`
3. Add curl lines in `bootstrap.sh` and `standards.yml` download step
4. Add tool install + lint steps in `standards.yml`
5. Add detection + tool invocations in `scripts/lint.sh`
6. Add a pre-commit hook in `consumer-templates/pre-commit-config.yaml`
   and `.pre-commit-config.yaml`
