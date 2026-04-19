# Catálogo de Perguntas (base PT-BR)

Use como biblioteca. Nunca mande tudo de uma vez. Em cada rodada, pegue no máximo 4 perguntas realmente úteis pra esse projeto, dadas as coisas que você já detectou.

**Idioma:** as perguntas abaixo estão em PT-BR como base. Se o idioma detectado do usuário for outro (ver `language-detection.md`), traduza labels e options mantendo o sentido — termos técnicos estáveis (TypeScript, snake_case, Plan Mode, TDD) ficam como estão. Mantenha a opção recomendada marcada com "(Recommended)" ou equivalente traduzido ("(Recomendado)", "(Recomendada)", "(Recommandé)").

## Rodada 1 — Contexto do projeto

**Tipo do projeto** — `header: Tipo`
- App de produção com usuários reais
- Side-project / MVP
- Projeto de estudo / aprendizado
- Biblioteca / ferramenta interna
- Projeto de cliente

**Nível de rigor com testes** — `header: Testes`
- TDD estrito (teste antes do código) (Recommended pra produção)
- Cobertura razoável de testes nas partes críticas
- Só o essencial — smoke test e pronto
- Sem testes (protótipo)

**Quem vai usar esse CLAUDE.md** — `header: Público`
- Só eu
- Meu time pequeno (2-5 pessoas)
- Time maior / open source
- Não sei ainda

**Modo de trabalho preferido** — `header: Plan Mode`
- Sempre Plan Mode antes de qualquer tarefa (Recommended)
- Só em tarefas com 3+ passos
- Deixa na minha mão, pergunta se tiver dúvida

## Rodada 2 — Regras de código (pule as que já deu pra inferir pelo lint/config)

**Estilo de nomes** — só pergunte se não houver `.eslintrc`, `ruff.toml` etc.
- camelCase (JS/TS padrão)
- snake_case (Python padrão)
- Mix por convenção da linguagem (Recommended)
- Tenho regra customizada (abre campo livre)

**TypeScript strictness** (só se for TS)
- Strict mode + proibir `any` (Recommended)
- Strict mode, mas `any` pode em casos difíceis
- Não strict

**Tamanho de função**
- Máx 30 linhas (Recommended)
- Máx 50 linhas
- Sem regra fixa

**Comentários**
- Comentário só onde explica *por que*, não *o que* (Recommended)
- Docstrings/JSDoc em toda função pública
- Sem regra

## Rodada 3 — Histórico (opcional, se o usuário quiser)

**Erros recorrentes que você já viu** (campo livre, múltiplas linhas)
- Ex: "esquecer de tratar `null` em respostas de API"
- Ex: "commitar sem rodar lint"
- Ex: "usar `console.log` em prod"

Essa lista vira a seção **Forbidden Patterns** diretamente.

**Subagentes** — `header: Subagentes`
- Usar sempre que possível pra manter contexto limpo (Recommended)
- Só em tarefas grandes
- Deixa na minha mão

## Perguntas situacionais

Use só quando o contexto pedir:

- Ambiente de deploy (Vercel, AWS, Railway, bare metal) — se o usuário mencionar deploy
- CI existente — se já vir `.github/workflows`
- Versionamento de DB — se houver `migrations/` ou `prisma/`
- Política de commits (Conventional Commits? squash merge?) — só se o time for grande
