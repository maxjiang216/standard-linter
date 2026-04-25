#!/usr/bin/env bash
set -euo pipefail

STANDARDS_REPO="${STANDARDS_REPO:-OWNER/code-standards}"
STANDARDS_REF="${STANDARDS_REF:-v1}"
RAW_BASE="https://raw.githubusercontent.com/${STANDARDS_REPO}/${STANDARDS_REF}"

curl -fsSL "${RAW_BASE}/.pre-commit-config.yaml" -o ".pre-commit-config.yaml"
curl -fsSL "${RAW_BASE}/scripts/download-configs.sh" | STANDARDS_REPO="${STANDARDS_REPO}" STANDARDS_REF="${STANDARDS_REF}" bash

if command -v pre-commit >/dev/null 2>&1; then
  pre-commit install
else
  echo "Installed configs. Install pre-commit, then run: pre-commit install"
fi
