#!/usr/bin/env bash
# Copy configs/ into .code-standards/ for local pre-commit in this repository.
# Consumer repos should use scripts/download-configs.sh against GitHub instead.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${DEST:-${ROOT}/.code-standards}"

mkdir -p "${DEST}/python" "${DEST}/cpp" "${DEST}/rust" "${DEST}/javascript" "${DEST}/go"

cp "${ROOT}/configs/python/ruff.toml" "${DEST}/python/ruff.toml"
cp "${ROOT}/configs/python/mypy.ini" "${DEST}/python/mypy.ini"
cp "${ROOT}/configs/cpp/.clang-format" "${DEST}/cpp/.clang-format"
cp "${ROOT}/configs/cpp/.clang-tidy" "${DEST}/cpp/.clang-tidy"
cp "${ROOT}/configs/cpp/cppcheck.suppressions" "${DEST}/cpp/cppcheck.suppressions"
cp "${ROOT}/configs/rust/rustfmt.toml" "${DEST}/rust/rustfmt.toml"
cp "${ROOT}/configs/rust/clippy.toml" "${DEST}/rust/clippy.toml"
cp "${ROOT}/configs/javascript/prettier.config.cjs" "${DEST}/javascript/prettier.config.cjs"
cp "${ROOT}/configs/javascript/eslint.config.mjs" "${DEST}/javascript/eslint.config.mjs"
cp "${ROOT}/configs/javascript/tsconfig.lint.json" "${DEST}/javascript/tsconfig.lint.json"
cp "${ROOT}/configs/go/.golangci.yml" "${DEST}/go/.golangci.yml"

echo "Wrote shared configs to ${DEST}"
