#!/usr/bin/env bash
set -euo pipefail

STANDARDS_REPO="${STANDARDS_REPO:-OWNER/code-standards}"
STANDARDS_REF="${STANDARDS_REF:-v1}"
DEST="${DEST:-.code-standards}"
RAW_BASE="https://raw.githubusercontent.com/${STANDARDS_REPO}/${STANDARDS_REF}"

mkdir -p "${DEST}/python" "${DEST}/cpp" "${DEST}/rust" "${DEST}/javascript" "${DEST}/go"

curl -fsSL "${RAW_BASE}/configs/python/ruff.toml" -o "${DEST}/python/ruff.toml"
curl -fsSL "${RAW_BASE}/configs/python/mypy.ini" -o "${DEST}/python/mypy.ini"
curl -fsSL "${RAW_BASE}/configs/cpp/.clang-format" -o "${DEST}/cpp/.clang-format"
curl -fsSL "${RAW_BASE}/configs/cpp/.clang-tidy" -o "${DEST}/cpp/.clang-tidy"
curl -fsSL "${RAW_BASE}/configs/cpp/cppcheck.suppressions" -o "${DEST}/cpp/cppcheck.suppressions"
curl -fsSL "${RAW_BASE}/configs/rust/rustfmt.toml" -o "${DEST}/rust/rustfmt.toml"
curl -fsSL "${RAW_BASE}/configs/rust/clippy.toml" -o "${DEST}/rust/clippy.toml"
curl -fsSL "${RAW_BASE}/configs/javascript/prettier.config.cjs" -o "${DEST}/javascript/prettier.config.cjs"
curl -fsSL "${RAW_BASE}/configs/javascript/eslint.config.mjs" -o "${DEST}/javascript/eslint.config.mjs"
curl -fsSL "${RAW_BASE}/configs/javascript/tsconfig.lint.json" -o "${DEST}/javascript/tsconfig.lint.json"
curl -fsSL "${RAW_BASE}/configs/go/.golangci.yml" -o "${DEST}/go/.golangci.yml"
