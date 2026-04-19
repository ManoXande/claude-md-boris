#!/usr/bin/env bash
# setup-github.sh — inicializa git, cria repo no GitHub via gh CLI e faz push
# Uso: bash setup-github.sh
# Pré-requisito: gh CLI instalado e autenticado (gh auth status)

set -euo pipefail

REPO_NAME="claude-md-boris"
REPO_DESC="Skill para Claude Code/Cowork gerar e manter CLAUDE.md seguindo a metodologia do Boris Cherny (Anthropic), com triagem automática, detecção de stack, entrevista em PT-BR e loop de lições aprendidas."
VISIBILITY="public"   # ou "private"

# 0. Checks
command -v git >/dev/null 2>&1 || { echo "ERRO: git não encontrado."; exit 1; }
command -v gh  >/dev/null 2>&1 || { echo "ERRO: gh CLI não encontrado. Instale em https://cli.github.com"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "ERRO: gh não autenticado. Rode: gh auth login"; exit 1; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo ">> Diretório: $SCRIPT_DIR"

# 1. Limpa .git quebrado (caso exista de tentativa anterior)
if [ -d ".git" ]; then
  echo ">> .git existente encontrado — removendo pra começar limpo."
  rm -rf .git
fi

# 2. Inicializa
echo ">> git init"
git init -b main >/dev/null

# 3. Configs locais (usa a config global do usuário; só garante que existe)
if [ -z "$(git config user.email || true)" ]; then
  echo "AVISO: git user.email não configurado. Configure antes com:"
  echo "  git config --global user.email 'seu@email.com'"
  echo "  git config --global user.name 'Seu Nome'"
  exit 1
fi

# 4. Primeiro commit
echo ">> git add + commit"
git add .
git commit -m "feat: initial release of claude-md-boris skill

- SKILL.md with triage (full/lite/update), auto-detection, bilingual
  interview, and lessons-loop workflow
- Boris Cherny / Anthropic CLAUDE.md templates (full ~65 lines + lite)
- detect_stack.sh supporting Node, Python, Rust, Go, Java, Ruby, PHP, .NET
- References: triage-rules, interview-questions (PT-BR), stack-detection,
  lessons-loop, sources
- README, INSTALL, LICENSE (MIT), .gitignore" >/dev/null

# 5. Cria repo no GitHub
echo ">> gh repo create (${VISIBILITY})"
if gh repo view "$REPO_NAME" >/dev/null 2>&1; then
  echo "AVISO: repositório $REPO_NAME já existe na sua conta. Pulando criação."
  REMOTE_URL="$(gh repo view "$REPO_NAME" --json sshUrl -q .sshUrl)"
else
  gh repo create "$REPO_NAME" \
    --"$VISIBILITY" \
    --description "$REPO_DESC" \
    --source . \
    --remote origin \
    --push
  echo ">> Push inicial concluído via gh repo create --push"
  REMOTE_URL="$(gh repo view "$REPO_NAME" --json sshUrl -q .sshUrl)"
fi

# 6. Se gh create não fez push (caso o repo já existia), faz manual
if ! git remote get-url origin >/dev/null 2>&1; then
  echo ">> Adicionando remote e fazendo push"
  git remote add origin "$REMOTE_URL"
  git push -u origin main
fi

# 7. Resultado
REPO_URL="$(gh repo view "$REPO_NAME" --json url -q .url)"
echo ""
echo "============================================================"
echo "  ✓ Repositório criado e enviado com sucesso!"
echo "  URL: $REPO_URL"
echo "============================================================"
