# Instalação detalhada

Guia passo-a-passo pra três cenários diferentes.

## Pré-requisitos

- [Claude Code](https://code.claude.com) instalado (CLI ou Cowork)
- `git` (pra clonar) — opcional se você for usar download direto

## Cenário 1 — Instalação global (padrão)

Essa é a melhor pra quem vai usar em vários projetos.

```bash
# 1. Cria a pasta de skills globais, se ainda não existe
mkdir -p ~/.claude/skills

# 2. Clona o repo pra lá
git clone https://github.com/SEU-USUARIO/claude-md-boris.git ~/.claude/skills/claude-md-boris

# 3. Dá permissão de execução ao script de detecção
chmod +x ~/.claude/skills/claude-md-boris/scripts/detect_stack.sh
```

Reinicie o Claude Code e pronto.

## Cenário 2 — Instalação por projeto (time compartilha)

Quando você quer que todo mundo do time use a mesma skill commitada no repo do projeto.

```bash
# dentro do seu projeto
mkdir -p .claude/skills

# opção A: copiar a pasta (mais simples)
cp -R /caminho/para/claude-md-boris .claude/skills/

# opção B: submodule (recomendado pra manter atualizado)
git submodule add https://github.com/SEU-USUARIO/claude-md-boris.git .claude/skills/claude-md-boris
git commit -m "add claude-md-boris skill"
```

## Cenário 3 — Instalação sem git

Se você só quer baixar o zip e colocar na pasta:

```bash
# download
curl -L https://github.com/SEU-USUARIO/claude-md-boris/archive/refs/heads/main.tar.gz \
  | tar -xz -C ~/.claude/skills/

# renomeia (o tar vem com sufixo -main)
mv ~/.claude/skills/claude-md-boris-main ~/.claude/skills/claude-md-boris

# permissão
chmod +x ~/.claude/skills/claude-md-boris/scripts/detect_stack.sh
```

## Verificando a instalação

Abra o Claude Code e digite:

```
/memory
```

Você deve ver `claude-md-boris` na lista de skills carregadas. Se não ver, os motivos comuns são:

- Pasta no lugar errado → deve ficar em `~/.claude/skills/claude-md-boris/` ou `.claude/skills/claude-md-boris/`
- Sem `SKILL.md` na raiz da pasta → o arquivo tem que se chamar exatamente `SKILL.md` (maiúsculas)
- Frontmatter YAML quebrado → não edite o topo do `SKILL.md` sem manter os dois `---`

## Primeiro uso

Abra um projeto seu e digite no Claude Code:

```
cria um CLAUDE.md pra esse projeto seguindo a metodologia do Boris
```

A skill vai:

1. Detectar seu stack via `scripts/detect_stack.sh`.
2. Te fazer 2-4 perguntas via múltipla escolha.
3. Criar `.claude/CLAUDE.md`, `tasks/todo.md`, `tasks/lessons.md`.
4. Te explicar como manter vivo com o loop de lições.

## Troubleshooting

### A skill não dispara quando peço

Verifique:
- `/memory` mostra `claude-md-boris`? Se não, reinstale.
- Você está numa sessão iniciada **depois** da instalação? Precisa reiniciar.
- Tente disparar explicitamente: *"use a skill claude-md-boris para criar o CLAUDE.md"*.

### O script de detecção retorna stack=unknown

Possíveis motivos:
- A pasta não tem marcadores reconhecidos (`package.json`, `pyproject.toml`, etc.).
- Você está numa subpasta sem esses arquivos — mude pra raiz do projeto.
- Stack não suportada ainda — abra uma issue com o tipo do projeto.

### O CLAUDE.md ficou grande demais

Se passou de 150 linhas:
1. Mova regras específicas pra `.claude/rules/<tema>.md`.
2. No `CLAUDE.md` principal, substitua a seção por `@rules/<tema>.md`.
3. Consolide a seção "Forbidden Patterns" (ver `references/lessons-loop.md`).

### Quero contribuir / reportar bug

Abra uma issue ou PR no repositório. Sugestões de novos stacks, frameworks e cenários de triagem são bem-vindas.
