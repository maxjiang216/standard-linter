# Tools and defaults

| Language   | Formatting     | Lint / style                   | Type / safety / memory            |
| ---------- | -------------- | ------------------------------ | --------------------------------- |
| Python     | `ruff format`  | `ruff check`                   | `mypy`                            |
| C++        | `clang-format` | `clang-tidy` (PR-changed only) | `cppcheck`                        |
| Rust       | `rustfmt`      | `clippy`                       | (compiler + clippy)               |
| JavaScript | `prettier`     | `eslint`                       | `tsc --noEmit` (TS)               |
| Go         | `gofmt` (tabs) | `golangci-lint`                | `staticcheck` / `govet` / `gosec` |

**Defaults (non-Go):** line length 100, 4-space indent, double quotes in Python, 2 spaces in JS/TS, trailing commas where supported.

**Go:** `gofmt` uses tabs per language convention; the shared config enforces 100 columns where applicable (e.g. `lll` in golangci-lint settings).

**C++ `clang-tidy`:** only runs on changed source files in PR-style runs and only if `compile_commands.json` exists (project root or `build/compile_commands.json`).
