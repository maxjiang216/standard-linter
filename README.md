# code-standards

Central formatter, linter, and type/bug check configuration for multiple repositories. The goal is a **stable, uniform policy** (especially for AI-generated code) so that style and obvious issues are enforced automatically in CI and locally.

## What this repository provides

- **Config files** under [`configs/`](configs/) for: Python, C++, Rust, JavaScript/TypeScript, and Go
- A **reusable GitHub Actions workflow** at [`.github/workflows/standards.yml`](.github/workflows/standards.yml) that:
  1. Downloads those configs (no submodules) into `.code-standards/`
  2. Runs **format checks** first, then **linters**, then **type / memory / bug** tools
- A **[`pre-commit`](.pre-commit-config.yaml)** config aligned with the same files
- **Scripts** to bootstrap consumer repos: [`scripts/bootstrap.sh`](scripts/bootstrap.sh), [`scripts/download-configs.sh`](scripts/download-configs.sh)
- [Docs: adoption](docs/adoption.md) and [docs: tools](docs/tools.md)

## Defaults

| Item            | Value                                                              |
| --------------- | ------------------------------------------------------------------ |
| Line length     | 100 characters                                                     |
| Indent          | 4 spaces (Go uses `gofmt` / tabs per Go convention)                |
| JS/TS indent    | 2 spaces                                                           |
| Quotes          | Double quotes in Python and JavaScript/TypeScript where configured |
| Trailing commas | On where the formatter supports it                                 |

## Add to a new repository (fewest steps)

### A) One workflow file in the consumer repo

1. In GitHub, create a repository (or use an existing one).
2. Add `.github/workflows/code-standards.yml`:

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

3. Commit and open a pull request. The job will fail on any check that does not follow the standard.

Replace `YOUR_ORG` with your org or user name. Turn off any language you do not need via `with:` flags.

### B) Local checks with `pre-commit` (optional but recommended)

```bash
export STANDARDS_REPO=YOUR_ORG/code-standards
export STANDARDS_REF=v1
curl -fsSL "https://raw.githubusercontent.com/${STANDARDS_REPO}/${STANDARDS_REF}/scripts/bootstrap.sh" | bash
pre-commit run --all-files
```

## Working **inside** this repository

`pre-commit` expects `.code-standards/` to exist. For contributors, mirror `configs/` into `.code-standards/` once:

```bash
bash scripts/install-local-standards.sh
npm install
pre-commit install
pre-commit run --all-files
```

`npm install` picks up pinned JS dev tools from `package.json` (ESLint, Prettier, TypeScript) for local editor and script use. CI installs the same tools with `npm install` inside the workflow.

## Go: `golangci-lint` v2

The shared Go config uses **`version: "2"`**, so you need the **golangci-lint v2** binary (v1 will error on that file). Install or upgrade:

```bash
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
```

CI installs the same module path in the reusable workflow.

## C++: `compile_commands.json` and `clang-tidy`

- `clang-tidy` is slow; in CI it runs only on **changed** C++ files in a pull request, and only if a compilation database is present.
- If there is no `compile_commands.json` in the project root (or `build/compile_commands.json`), `clang-tidy` is skipped and a warning is printed. `clang-format` and `cppcheck` still run.

## Releasing and versioning

See [RELEASING.md](RELEASING.md). Consumer workflows should always pin a tag such as `v1` so updates are intentional.

## License

This repository is intended to be vendor-neutral. Add a `LICENSE` file in your own fork; default to MIT if you are unsure.
