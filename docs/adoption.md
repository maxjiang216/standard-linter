# Adopting this standards repo

## 1) CI: reusable workflow (recommended)

In each consumer repository, add `.github/workflows/code-standards.yml` (or any name) with the following pattern.

Replace `YOUR_ORG/code-standards` with the real GitHub location and **pin a tag** (for example `v1` or `v1.0.0`):

```yaml
name: Code Standards

on:
  pull_request:

jobs:
  standards:
    uses: YOUR_ORG/code-standards/.github/workflows/standards.yml@v1
    with:
      python: true
      cpp: true
      rust: true
      javascript: true
      go: true
```

Disable languages you do not use, for example:

```yaml
with:
  python: true
  cpp: false
  rust: false
  javascript: true
  go: false
```

The job checks out the **consumer** repository, downloads config files from the pinned `code-standards` ref, then runs format checks, linters, and bug/type tools in a fixed order.

## 2) Local: `pre-commit` + downloaded configs (no submodules)

From the root of a consumer repository:

```bash
export STANDARDS_REPO=YOUR_ORG/code-standards
export STANDARDS_REF=v1
curl -fsSL "https://raw.githubusercontent.com/${STANDARDS_REPO}/${STANDARDS_REF}/scripts/bootstrap.sh" | bash
```

The bootstrap script drops `.pre-commit-config.yaml` and populates `.code-standards/` with the same configs that CI uses.

If you do not have `pre-commit` yet:

```bash
pipx install pre-commit
# or: python -m pip install --user pre-commit
pre-commit install
pre-commit run --all-files
```

## 3) C++ and `compile_commands.json`

`clang-tidy` requires a compilation database. Typical CMake:

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
# optionally: ln -s build/compile_commands.json compile_commands.json
```

If no database is present, CI and local `clang-tidy` hooks skip the tool with a message; `clang-format` and `cppcheck` still run.

## 4) Versioning

- Pin a **major** tag in workflows, for example `@v1`.
- Breaking changes to rules or layout should be released as `@v2` and documented in [RELEASING.md](../RELEASING.md).
