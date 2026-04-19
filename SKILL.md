---
name: claude-md-boris
description: Cria e mantém o arquivo CLAUDE.md de um projeto seguindo a metodologia do Boris Cherny (Anthropic) — faz triagem pra decidir entre versão completa ou lite, detecta stack automaticamente (package.json, pyproject.toml, Cargo.toml, go.mod, etc.), roda uma entrevista em português pra completar os gaps, gera CLAUDE.md + tasks/todo.md + tasks/lessons.md, e fecha o loop de auto-melhoria atualizando o arquivo com lições aprendidas. Use sempre que o usuário pedir para "criar CLAUDE.md", "configurar regras do projeto pro Claude", "inicializar Claude Code no projeto", "setup do Claude Code", "padronizar o projeto pra IA", "atualizar o CLAUDE.md", "adicionar uma lição no CLAUDE.md", "registrar esse erro pra não repetir", ou mencionar Boris Cherny / template do Boris / metodologia CLAUDE.md. Também dispare proativamente quando o usuário estiver começando um projeto novo com Claude Code ou depois de uma correção importante que mereça virar regra permanente.
---

# CLAUDE.md Boris — Gerador e Mantenedor

Skill baseada na metodologia pública do Boris Cherny (criador do Claude Code / Anthropic) e nas convenções da comunidade (ver `references/sources.md`).

Ela faz quatro coisas bem feitas:

1. **Triagem** — decide se o projeto merece um CLAUDE.md completo ou uma versão lite (não polua projetinhos).
2. **Auto-detecção** — lê o sistema de arquivos pra inferir stack, comandos, convenções, evitando perguntar o óbvio.
3. **Entrevista mínima** — só pergunta o que não deu pra detectar, em português, com opções sugeridas.
4. **Loop de auto-melhoria** — depois de criado, oferece comandos pra registrar lições aprendidas e manter o arquivo vivo.

O conteúdo gerado é bilíngue: perguntas e conversas em PT-BR; o CLAUDE.md em inglês (padrão de comunidade, é o que o Claude Code lê melhor e o que facilita colaboração em repos públicos). Se o usuário pedir em PT, honre o pedido.

---

## Quando rodar (gatilhos)

Ative esta skill quando o usuário disser coisas como:

- "cria um CLAUDE.md pra esse projeto"
- "quero configurar o Claude Code aqui"
- "inicializa a pasta .claude"
- "adiciona essa regra no CLAUDE.md pra não repetir"
- "registra essa lição"
- "atualiza o CLAUDE.md com o que acabamos de aprender"
- menções ao Boris Cherny / template Boris / metodologia da Anthropic
- depois de uma correção relevante ("a gente errou aqui, não deixa acontecer de novo")

Se o usuário só pediu uma dúvida conceitual ("o que é CLAUDE.md?"), responda direto sem ativar o fluxo completo.

---

## Fluxo de execução

Siga estes passos em ordem. Pule etapas que não se aplicam, mas nunca pule a triagem.

### Passo 1 — Triagem (obrigatório)

Antes de qualquer coisa, decida entre três modos. Leia `references/triage-rules.md` pra critérios detalhados. Resumo:

| Modo | Quando usar | O que gera |
|---|---|---|
| **Full** | Projeto de verdade: tem repositório, mais de um arquivo de código, build/test/lint, time ou planos de crescer | CLAUDE.md completo (~80-120 linhas), tasks/todo.md, tasks/lessons.md, .claude/ |
| **Lite** | Script solto, protótipo, pasta de scratch, tarefa one-off | CLAUDE.md curto (~20-30 linhas), sem tasks/ |
| **Update** | Projeto já tem CLAUDE.md e usuário quer adicionar/corrigir uma regra | Só edita o arquivo existente (seção "Padrões Proibidos" ou cria `tasks/lessons.md`) |

Sinais pra ignorar o modo Full e ir direto no Lite:
- o diretório tem < 5 arquivos de código
- não tem git inicializado
- é claramente um rascunho (`/tmp`, `Desktop`, pasta com "test"/"scratch" no nome)
- o usuário disse "é só pra brincar / testar / ver"

Se a triagem ficar ambígua, **pergunte** em vez de chutar:
> "Antes de prosseguir: isso é um projeto que vai crescer (aí faço o setup completo com `.claude/`, `tasks/todo.md` e `tasks/lessons.md`) ou é algo mais simples (aí faço um CLAUDE.md enxuto de ~20 linhas)?"

### Passo 2 — Auto-detecção

Se o usuário já abriu uma pasta/projeto, rode a detecção antes de perguntar nada. Use `scripts/detect_stack.sh` ou equivalente. O script lê:

- `package.json` → Node/TS/JS, scripts de build/test/lint, framework (Next, Nuxt, Vite, Remix, etc.)
- `pyproject.toml`, `requirements.txt`, `Pipfile`, `setup.py` → Python, framework (FastAPI, Django, Flask, Pandas, etc.)
- `Cargo.toml` → Rust
- `go.mod` → Go
- `pom.xml`, `build.gradle*` → Java/Kotlin
- `composer.json` → PHP
- `Gemfile` → Ruby
- `.csproj`, `.sln` → .NET
- `tsconfig.json` / `deno.json` / `bun.lockb` → variantes JS
- `Dockerfile`, `docker-compose.yml` → infra
- `.github/workflows/*` → CI
- `.eslintrc*`, `.prettierrc*`, `ruff.toml`, `.rubocop.yml`, `biome.json` → estilo de código existente

Extraia daí:
- **stack principal** (linguagem + framework)
- **comandos** (build / test / lint / dev / start)
- **layout** (onde fica `src/`, `tests/`, etc. — use `ls` / glob)
- **convenções já existentes** (indentação, quote style, lint rules)

Guarde o resultado num scratchpad. Só pergunte ao usuário o que não der pra inferir.

Se estiver rodando em Cowork e não tem pasta conectada: use `request_cowork_directory` pra pedir a pasta do projeto. Se o usuário não quiser conectar, caia no modo manual (entrevista completa).

### Passo 3 — Entrevista mínima

Use **AskUserQuestion** (uma chamada só, 2-4 perguntas) pra fechar os gaps. A lista completa de perguntas possíveis está em `references/interview-questions.md` — escolha só as que fazem sentido pro caso.

Regras pra perguntar bem:

- **Nunca** pergunte o que detectou. Se `package.json` tem `"scripts": {"test": "vitest"}`, não pergunte qual é o comando de teste.
- **Sempre** ofereça opções recomendadas (coloque "(Recommended)" na primeira).
- **Limite-se** a 4 perguntas por rodada. Melhor duas rodadas curtas do que um questionário comprido.
- **Contexto primeiro, regras depois**: primeira rodada pergunta sobre o projeto (tipo, audiência, nível de rigor); segunda rodada pergunta sobre regras específicas de código.

Perguntas de alto valor (sempre úteis quando faltam):
1. Tipo de projeto / qual é o "porquê" dele (produção, side-project, estudo, cliente)
2. Nível de rigor de testes (TDD estrito / cobertura razoável / só o essencial)
3. Regras específicas do time (ex.: "nunca `any` em TS", "funções ≤ 30 linhas", "snake_case em Python")
4. Padrões proibidos já conhecidos (erros antigos que não podem voltar)
5. Uso de subagentes e Plan Mode (sim sempre / só em tarefas grandes / decidir na hora)

### Passo 4 — Geração dos arquivos

Leia o template apropriado em `assets/`:

- `assets/CLAUDE.md.template` — versão full (padrão Boris, ~100 linhas)
- `assets/CLAUDE.md.lite.template` — versão lite (~20-25 linhas)
- `assets/tasks-todo.md.template` — todo list do fluxo
- `assets/tasks-lessons.md.template` — arquivo de lições

Substitua os placeholders entre `{{...}}` com o que foi detectado/respondido. Se algum placeholder ficou sem resposta, deixe um TODO explícito em vez de inventar:

```
Build: `{{BUILD_CMD}}`  ← vira:  Build: `npm run build`
                       ← ou:    Build: `TODO: preencher comando de build`
```

Crie a estrutura no diretório do projeto (ou no outputs se não houver pasta conectada):

```
.claude/
  CLAUDE.md
tasks/
  todo.md
  lessons.md
```

> **Importante:** o local canônico é `.claude/CLAUDE.md` (padrão oficial), não `CLAUDE.md` na raiz. Commitar em git é recomendado pro time inteiro usar o mesmo. Mencione isso ao entregar.

Opcional (pergunte se quiser): criar também `.claude/local.md` (gitignored, notas pessoais) e adicionar entradas no `.gitignore`.

### Passo 5 — Loop de auto-melhoria

Depois de gerar, explique ao usuário em ≤ 4 linhas como manter isso vivo:

> Pronto. Daqui pra frente, sempre que você me corrigir ou eu errar, me diga **"registra essa lição"** e eu atualizo o `CLAUDE.md` + `tasks/lessons.md` com a regra nova. Revise o arquivo 1× por semana (uns 5 min). O Claude Code lê `.claude/CLAUDE.md` automaticamente em toda sessão.

Quando o usuário disser "registra essa lição" / "adiciona essa regra" / "atualiza o CLAUDE.md":

1. Pergunte brevemente qual foi a lição (uma frase) — ou infira do contexto recente se estiver óbvio.
2. Formule uma regra curta no padrão:
   - **Padrão**: o erro em uma frase
   - **Regra**: o que fazer (em linguagem imperativa)
   - **Por quê**: a razão (curta)
3. Adicione na seção "Forbidden patterns / Padrões Proibidos" do CLAUDE.md **e** em `tasks/lessons.md` (o lessons é append-only, com data).
4. Confirme ao usuário: mostre o diff do que mudou. Não adicione mais nada sem confirmação.

Se o arquivo CLAUDE.md estiver passando de ~150 linhas, sugira mover regras específicas pra `.claude/rules/<tema>.md` e importar com `@rules/<tema>.md`.

### Passo 6 — Entrega

Mostre ao usuário o caminho absoluto do arquivo (use `computer://` link quando estiver em Cowork) e termine com **um** convite pra revisar. Não enrole.

---

## Princípios do template (não pode violar)

Se o usuário pedir algo que contraria o espírito da metodologia, explique educadamente e ofereça alternativa:

- **Enxuto**: ideal 80-120 linhas, teto 150. Acima disso, quebre em `.claude/rules/`.
- **Universal no root**: `.claude/CLAUDE.md` vale pro projeto inteiro; contexto de subpasta vai em `<subpasta>/CLAUDE.md`.
- **Vivo**: regras vêm de correções reais, não de achismo. Nada de encher o arquivo com conselhos genéricos.
- **Commitado**: `.claude/CLAUDE.md` e `tasks/*` no git. `.claude/local.md` gitignored.
- **Plan Mode por padrão**: toda tarefa com ≥ 3 passos ou decisão arquitetural entra em Plan Mode antes de escrever código.

---

## Detalhes & casos especiais

Consulte os arquivos de referência quando precisar de detalhe:

- `references/triage-rules.md` — critérios completos pra decidir full/lite/update
- `references/interview-questions.md` — catálogo de perguntas possíveis (PT-BR)
- `references/stack-detection.md` — mapa arquivo → stack → comandos
- `references/lessons-loop.md` — formato exato das lições e do diff
- `references/sources.md` — referências públicas que fundamentam a metodologia

---

## Formato final da resposta ao usuário

Depois que os arquivos estiverem criados, responda curto (≤ 6 linhas) com:

1. Um resumo em uma frase do que foi gerado.
2. Link `computer://` pro CLAUDE.md (e pros outros arquivos se relevante).
3. Lembrete de uma frase sobre o loop de lições ("me diga 'registra essa lição' quando eu errar").

Não reescreva o conteúdo do arquivo no chat — o usuário abre o link.
