#!/usr/bin/env bash
# setup-github.sh — publica este diretório no GitHub com segurança.
# Uso:
#   bash setup-github.sh
#   bash setup-github.sh "docs: add language detection"
#   COMMIT_MESSAGE="docs: add language detection" bash setup-github.sh
#
# Comportamento:
# - Se ainda não houver repo git, inicializa e faz o primeiro commit.
# - Se o repo remoto ainda não existir, cria via gh CLI.
# - Se já existir git/remote, apenas commita o que mudou e faz push.

set -euo pipefail

REPO_NAME="${REPO_NAME:-claude-md-boris}"
REPO_DESC="${REPO_DESC:-Skill para Claude Code/Cowork gerar e manter CLAUDE.md seguindo a metodologia do Boris Cherny (Anthropic), com triagem automática, detecção de idioma e stack, entrevista no idioma do usuário e loop de lições aprendidas.}"
VISIBILITY="${VISIBILITY:-public}"   # ou "private"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
COMMIT_MESSAGE="${1:-${COMMIT_MESSAGE:-chore: sync repository updates}}"

command -v git >/dev/null 2>&1 || { echo "ERRO: git não encontrado."; exit 1; }
command -v gh  >/dev/null 2>&1 || { echo "ERRO: gh CLI não encontrado. Instale em https://cli.github.com"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "ERRO: gh não autenticado. Rode: gh auth login"; exit 1; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo ">> Diretório: $SCRIPT_DIR"

if [ -z "$(git config user.email || true)" ] || [ -z "$(git config user.name || true)" ]; then
  echo "ERRO: git user.name/user.email não configurados."
  echo "Configure antes com:"
  echo "  git config --global user.email 'seu@email.com'"
  echo "  git config --global user.name 'Seu Nome'"
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo ">> git init (${DEFAULT_BRANCH})"
  git init -b "$DEFAULT_BRANCH" >/dev/null
fi

CURRENT_BRANCH="$(git branch --show-current 2>/dev/null || true)"
if [ -z "$CURRENT_BRANCH" ]; then
  CURRENT_BRANCH="$DEFAULT_BRANCH"
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo ">> Remote origin não encontrado"
  if gh repo view "$REPO_NAME" >/dev/null 2>&1; then
    REMOTE_URL="$(gh repo view "$REPO_NAME" --json url -q .url)"
    echo ">> Repositório remoto já existe. Adicionando origin -> $REMOTE_URL"
    git remote add origin "$REMOTE_URL"
  else
    echo ">> Criando repositório GitHub (${VISIBILITY})"
    gh repo create "$REPO_NAME" \
      --"$VISIBILITY" \
      --description "$REPO_DESC" >/dev/null
    REMOTE_URL="$(gh repo view "$REPO_NAME" --json url -q .url)"
    git remote add origin "$REMOTE_URL"
  fi
fi

REPO_REF="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "$REPO_NAME")"

echo ">> Remote origin: $(git remote get-url origin)"
echo ">> Repositório GitHub: $REPO_REF"
echo ">> Sincronizando descrição do repositório"
gh repo edit "$REPO_REF" --description "$REPO_DESC" >/dev/null

if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
  echo ">> git add -A"
  git add -A
  if git diff --cached --quiet; then
    echo ">> Nenhuma mudança staged após git add -A"
  else
    echo ">> git commit"
    git commit -m "$COMMIT_MESSAGE" >/dev/null
  fi
else
  echo ">> Nenhuma mudança local para commit"
fi

if git ls-remote --exit-code --heads origin "$CURRENT_BRANCH" >/dev/null 2>&1; then
  git fetch origin "$CURRENT_BRANCH" >/dev/null 2>&1

  LOCAL_SHA="$(git rev-parse "$CURRENT_BRANCH")"
  REMOTE_SHA="$(git rev-parse "origin/$CURRENT_BRANCH")"
  BASE_SHA="$(git merge-base "$CURRENT_BRANCH" "origin/$CURRENT_BRANCH")"

  if [ "$LOCAL_SHA" = "$REMOTE_SHA" ]; then
    echo ">> Branch já está sincronizada com origin/$CURRENT_BRANCH"
  elif [ "$REMOTE_SHA" = "$BASE_SHA" ]; then
    echo ">> git push -u origin $CURRENT_BRANCH"
    git push -u origin "$CURRENT_BRANCH"
  elif [ "$LOCAL_SHA" = "$BASE_SHA" ]; then
    echo "ERRO: origin/$CURRENT_BRANCH está à frente do local. Faça pull/rebase antes do push."
    exit 1
  else
    echo "ERRO: branch local e remota divergiram. Resolva o merge/rebase antes do push."
    exit 1
  fi
else
  echo ">> git push -u origin $CURRENT_BRANCH"
  git push -u origin "$CURRENT_BRANCH"
fi

REPO_URL="$(gh repo view "$REPO_REF" --json url -q .url)"
echo ""
echo "============================================================"
echo "  ✓ Repositório sincronizado com sucesso!"
echo "  URL: $REPO_URL"
echo "============================================================"
