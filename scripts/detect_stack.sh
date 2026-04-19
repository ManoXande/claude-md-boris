#!/usr/bin/env bash
# detect_stack.sh — inspeciona um diretório e devolve um resumo JSON do stack detectado.
# Uso: ./detect_stack.sh <diretorio-projeto>
# Saída: JSON no stdout com { "stack", "lang", "commands", "framework", "has_git", "file_count", "suggested_mode" }

set -euo pipefail

DIR="${1:-.}"
cd "$DIR"

# helpers -----------------------------------------------------------
json_escape() { python3 -c 'import json,sys;print(json.dumps(sys.stdin.read().strip()))'; }

has() { [ -f "$1" ] || [ -d "$1" ]; }

first_script() {
  # $1 = package.json, $2 = script name
  python3 - <<PY 2>/dev/null || true
import json, sys
try:
    data = json.load(open("$1"))
    print(data.get("scripts", {}).get("$2", ""))
except Exception:
    pass
PY
}

# counts ------------------------------------------------------------
HAS_GIT=false
[ -d ".git" ] && HAS_GIT=true

FILE_COUNT=$(find . -maxdepth 4 \
  -type f \
  \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \
     -o -name "*.py" -o -name "*.rb" -o -name "*.go" -o -name "*.rs" \
     -o -name "*.java" -o -name "*.kt" -o -name "*.cs" -o -name "*.php" \
     -o -name "*.swift" -o -name "*.c" -o -name "*.cpp" -o -name "*.h" \) \
  -not -path "./node_modules/*" \
  -not -path "./.venv/*" \
  -not -path "./venv/*" \
  -not -path "./target/*" \
  -not -path "./dist/*" \
  -not -path "./build/*" \
  2>/dev/null | wc -l | tr -d ' ')

# stack detection ---------------------------------------------------
STACK="unknown"
LANG="unknown"
FRAMEWORK="none"
BUILD_CMD=""
TEST_CMD=""
LINT_CMD=""
DEV_CMD=""

if has package.json; then
  STACK="node"
  LANG="javascript"
  has tsconfig.json && LANG="typescript"

  BUILD_CMD=$(first_script package.json build)
  TEST_CMD=$(first_script package.json test)
  LINT_CMD=$(first_script package.json lint)
  DEV_CMD=$(first_script package.json dev)

  [ -n "$BUILD_CMD" ] && BUILD_CMD="npm run build"
  [ -n "$TEST_CMD" ]  && TEST_CMD="npm test"
  [ -n "$LINT_CMD" ]  && LINT_CMD="npm run lint"
  [ -n "$DEV_CMD" ]   && DEV_CMD="npm run dev"

  # framework sniff
  grep -q '"next"'         package.json 2>/dev/null && FRAMEWORK="next.js"
  grep -q '"nuxt"'         package.json 2>/dev/null && FRAMEWORK="nuxt"
  grep -q '"vite"'         package.json 2>/dev/null && FRAMEWORK="vite"
  grep -q '"@remix-run/"'  package.json 2>/dev/null && FRAMEWORK="remix"
  grep -q '"express"'      package.json 2>/dev/null && FRAMEWORK="express"
  grep -q '"fastify"'      package.json 2>/dev/null && FRAMEWORK="fastify"
  grep -q '"react"'        package.json 2>/dev/null && [ "$FRAMEWORK" = "none" ] && FRAMEWORK="react"

  has bun.lockb       && { BUILD_CMD="bun run build"; TEST_CMD="bun test"; DEV_CMD="bun dev"; }
  has pnpm-lock.yaml  && { BUILD_CMD="pnpm build";    TEST_CMD="pnpm test"; DEV_CMD="pnpm dev"; }
  has yarn.lock       && { BUILD_CMD="yarn build";    TEST_CMD="yarn test"; DEV_CMD="yarn dev"; }

elif has pyproject.toml || has requirements.txt || has setup.py; then
  STACK="python"
  LANG="python"
  TEST_CMD="pytest"
  has manage.py && { FRAMEWORK="django"; DEV_CMD="python manage.py runserver"; TEST_CMD="python manage.py test"; }
  if has pyproject.toml; then
    grep -q 'fastapi'  pyproject.toml 2>/dev/null && { FRAMEWORK="fastapi"; DEV_CMD="uvicorn main:app --reload"; }
    grep -q 'flask'    pyproject.toml 2>/dev/null && { FRAMEWORK="flask";   DEV_CMD="flask run"; }
    grep -q '\[tool.ruff\]' pyproject.toml 2>/dev/null && LINT_CMD="ruff check ."
    grep -q '\[tool.poetry\]' pyproject.toml 2>/dev/null && TEST_CMD="poetry run pytest"
    grep -q '\[tool.uv\]'     pyproject.toml 2>/dev/null && TEST_CMD="uv run pytest"
  fi
  has ruff.toml    && LINT_CMD="ruff check ."
  has .flake8      && LINT_CMD="flake8 ."

elif has Cargo.toml; then
  STACK="rust"; LANG="rust"; FRAMEWORK="cargo"
  BUILD_CMD="cargo build"; TEST_CMD="cargo test"; LINT_CMD="cargo clippy"

elif has go.mod; then
  STACK="go"; LANG="go"; FRAMEWORK="go"
  BUILD_CMD="go build ./..."; TEST_CMD="go test ./..."; LINT_CMD="go vet ./..."

elif has pom.xml; then
  STACK="java"; LANG="java"; FRAMEWORK="maven"
  BUILD_CMD="mvn package"; TEST_CMD="mvn test"

elif has build.gradle || has build.gradle.kts; then
  STACK="java"; LANG="java"; FRAMEWORK="gradle"
  BUILD_CMD="./gradlew build"; TEST_CMD="./gradlew test"

elif has Gemfile; then
  STACK="ruby"; LANG="ruby"
  has config.ru && FRAMEWORK="rack/rails"
  TEST_CMD="bundle exec rspec"

elif has composer.json; then
  STACK="php"; LANG="php"
  has artisan && FRAMEWORK="laravel"
  TEST_CMD="composer test"

else
  FILE_COUNT_INT=$(printf '%d' "$FILE_COUNT")
  if [ "$FILE_COUNT_INT" -eq 0 ]; then
    STACK="empty"
  fi
fi

# suggested mode ----------------------------------------------------
SUGGESTED_MODE="lite"
FILE_COUNT_INT=$(printf '%d' "$FILE_COUNT")
if [ "$HAS_GIT" = "true" ] && [ "$FILE_COUNT_INT" -ge 5 ] && [ "$STACK" != "unknown" ]; then
  SUGGESTED_MODE="full"
fi
if has .claude/CLAUDE.md || has CLAUDE.md; then
  SUGGESTED_MODE="update"
fi

# emit JSON ---------------------------------------------------------
HAS_GIT_PY=$([ "$HAS_GIT" = "true" ] && echo True || echo False)
python3 - <<PY
import json
print(json.dumps({
  "stack": "$STACK",
  "lang": "$LANG",
  "framework": "$FRAMEWORK",
  "commands": {
    "build": "$BUILD_CMD",
    "test":  "$TEST_CMD",
    "lint":  "$LINT_CMD",
    "dev":   "$DEV_CMD",
  },
  "has_git": $HAS_GIT_PY,
  "file_count": int("$FILE_COUNT_INT"),
  "suggested_mode": "$SUGGESTED_MODE",
}, indent=2))
PY
