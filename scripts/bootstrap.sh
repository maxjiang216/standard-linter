#!/usr/bin/env bash
set -euo pipefail

STANDARDS_REPO="maxjiang216/standard-linter"
STANDARDS_REF="main"
CONFIGS_ONLY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ref) STANDARDS_REF="$2"; shift 2 ;;
    --configs-only) CONFIGS_ONLY=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

RAW_BASE="https://raw.githubusercontent.com/${STANDARDS_REPO}/${STANDARDS_REF}"

echo "Downloading configs from ${STANDARDS_REPO}@${STANDARDS_REF}..."
mkdir -p .code-standards/{python,cpp,rust,javascript,go,bash}

curl -fsSL "${RAW_BASE}/configs/python/ruff.toml"           -o .code-standards/python/ruff.toml
curl -fsSL "${RAW_BASE}/configs/python/mypy.ini"            -o .code-standards/python/mypy.ini
curl -fsSL "${RAW_BASE}/configs/cpp/.clang-format"          -o .code-standards/cpp/.clang-format
curl -fsSL "${RAW_BASE}/configs/cpp/.clang-tidy"            -o .code-standards/cpp/.clang-tidy
curl -fsSL "${RAW_BASE}/configs/cpp/cppcheck.suppressions"  -o .code-standards/cpp/cppcheck.suppressions
curl -fsSL "${RAW_BASE}/configs/rust/rustfmt.toml"          -o .code-standards/rust/rustfmt.toml
curl -fsSL "${RAW_BASE}/configs/rust/clippy.toml"           -o .code-standards/rust/clippy.toml
curl -fsSL "${RAW_BASE}/configs/javascript/prettier.config.cjs" -o .code-standards/javascript/prettier.config.cjs
curl -fsSL "${RAW_BASE}/configs/javascript/eslint.config.mjs"   -o .code-standards/javascript/eslint.config.mjs
curl -fsSL "${RAW_BASE}/configs/javascript/tsconfig.lint.json"  -o .code-standards/javascript/tsconfig.lint.json
curl -fsSL "${RAW_BASE}/configs/go/.golangci.yml"           -o .code-standards/go/.golangci.yml
curl -fsSL "${RAW_BASE}/configs/bash/.shellcheckrc"         -o .code-standards/bash/.shellcheckrc

echo "Configs written to .code-standards/"

if [[ "${CONFIGS_ONLY}" == true ]]; then
  exit 0
fi

# Step 2: install lint.sh
mkdir -p scripts
curl -fsSL "${RAW_BASE}/scripts/lint.sh" -o scripts/lint.sh
chmod +x scripts/lint.sh
echo "Installed scripts/lint.sh"

# Step 3: pre-commit config
if [[ -f .pre-commit-config.yaml ]]; then
  echo "Skipping .pre-commit-config.yaml (already exists)"
else
  curl -fsSL "${RAW_BASE}/consumer-templates/pre-commit-config.yaml" \
    -o .pre-commit-config.yaml
  echo "Created .pre-commit-config.yaml"
fi

# Step 4: GitHub Actions workflow
if [[ -f .github/workflows/code-standards.yml ]]; then
  echo "Skipping .github/workflows/code-standards.yml (already exists)"
else
  mkdir -p .github/workflows
  curl -fsSL "${RAW_BASE}/consumer-templates/code-standards.yml" \
    -o .github/workflows/code-standards.yml
  echo "Created .github/workflows/code-standards.yml"
fi

# Step 5: CLAUDE.md
if [[ -f CLAUDE.md ]]; then
  echo "Note: CLAUDE.md already exists — merge manually with:"
  echo "  curl -fsSL ${RAW_BASE}/consumer-templates/CLAUDE.md"
else
  curl -fsSL "${RAW_BASE}/consumer-templates/CLAUDE.md" -o CLAUDE.md
  echo "Created CLAUDE.md"
fi

# Step 6: .gitignore
if [[ -f .gitignore ]]; then
  if grep -q '\.code-standards/' .gitignore; then
    echo ".code-standards/ already in .gitignore"
  else
    echo '.code-standards/' >> .gitignore
    echo "Added .code-standards/ to .gitignore"
  fi
else
  echo '.code-standards/' > .gitignore
  echo "Created .gitignore with .code-standards/"
fi

# Step 7: pre-commit install
if command -v pre-commit > /dev/null 2>&1 && [[ -d .git ]]; then
  pre-commit install
  echo "pre-commit hooks installed"
else
  echo "Note: pre-commit not found or not in a git repo. Run 'pre-commit install' manually."
fi

echo ""
echo "Bootstrap complete. Next steps:"
echo "  1. Edit .github/workflows/code-standards.yml — set language flags for this repo"
echo "  2. Run: bash scripts/lint.sh"
echo "  3. Commit the added files (not .code-standards/ — it's in .gitignore)"
