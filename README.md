# claude-md-boris

> Skill para o Claude (Code / Cowork / Desktop) gerar e manter um `CLAUDE.md` seguindo a metodologia do **Boris Cherny** (criador do Claude Code, Anthropic) e as convenções da comunidade.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Skill](https://img.shields.io/badge/Claude-Skill-orange)
![Language](https://img.shields.io/badge/language-PT--BR%20%2F%20EN-blue)

---

## O que ela resolve

Todo projeto decente que usa Claude Code precisa de um `CLAUDE.md` bem feito. Na prática, 3 coisas falham:

1. O arquivo é escrito uma vez e nunca mais atualizado.
2. Fica ou exagerado (300+ linhas que o Claude ignora) ou raso demais.
3. Não tem um loop pra registrar lições aprendidas.

Esta skill resolve isso com cinco mecanismos:

| Mecanismo | O que faz |
|---|---|
| **Detecção de idioma** | Identifica se você está falando em PT, EN, ES, FR, etc. e conduz toda a conversa nesse idioma |
| **Triagem** | Decide sozinha entre modo **full** (projeto de verdade), **lite** (script/protótipo) ou **update** (já existe CLAUDE.md) |
| **Auto-detecção de stack** | Lê `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, etc. pra inferir stack, framework e comandos |
| **Entrevista mínima** | Só pergunta o que não deu pra detectar, no seu idioma, via múltipla escolha |
| **Loop de lições** | Comando `"registra essa lição"` anexa regras no `CLAUDE.md` + `tasks/lessons.md` com diff antes de gravar |

**Chat segue o usuário; arquivo segue a comunidade.** O CLAUDE.md gerado fica em inglês por default (compatível com repos públicos e com o Claude Code), mas se você pedir em outro idioma a skill respeita. Detalhes em `references/language-detection.md`.

---

## Instalação

Três formas, escolha a que fizer sentido:

### 1. Global (funciona em todos os seus projetos)

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/SEU-USUARIO/claude-md-boris.git ~/.claude/skills/claude-md-boris
```

### 2. Projeto específico (commitado no git do projeto)

```bash
# dentro da raiz do seu projeto
mkdir -p .claude/skills
git submodule add https://github.com/SEU-USUARIO/claude-md-boris.git .claude/skills/claude-md-boris
```

### 3. Download direto (sem git)

```bash
curl -L https://github.com/SEU-USUARIO/claude-md-boris/archive/refs/heads/main.tar.gz \
  | tar -xz -C ~/.claude/skills/
mv ~/.claude/skills/claude-md-boris-main ~/.claude/skills/claude-md-boris
```

Depois de instalar, reinicie a sessão do Claude Code. Digite `/memory` pra confirmar que a skill foi detectada.

Instruções detalhadas e troubleshooting: ver [INSTALL.md](INSTALL.md).

---

## Como usar

Basta pedir em linguagem natural. Exemplos que disparam a skill:

```
cria um CLAUDE.md pra esse projeto
configura o Claude Code aqui
inicializa a pasta .claude/
padroniza o projeto pra IA
```

E depois, durante o uso:

```
registra essa lição
atualiza o CLAUDE.md com essa regra
não deixa eu repetir esse erro
```

A skill vai rodar automaticamente:

1. Fazer triagem (full / lite / update).
2. Rodar o script de detecção pra inferir stack e comandos.
3. Te perguntar 2-4 coisas que faltaram (ou nada, se detectou tudo).
4. Gerar os arquivos (`.claude/CLAUDE.md`, `tasks/todo.md`, `tasks/lessons.md`).
5. Explicar o loop de lições em uma frase.

---

## Estrutura

```
claude-md-boris/
├── SKILL.md                       ← frontmatter + workflow principal
├── README.md                      ← este arquivo
├── INSTALL.md                     ← instalação detalhada + troubleshooting
├── LICENSE                        ← MIT
├── .gitignore
├── assets/
│   ├── CLAUDE.md.template         ← template completo (EN, ~65 linhas)
│   ├── CLAUDE.md.lite.template    ← versão lite (~20 linhas)
│   ├── tasks-todo.md.template
│   └── tasks-lessons.md.template
├── references/
│   ├── language-detection.md      ← regra de qual idioma usar (chat e arquivo)
│   ├── triage-rules.md            ← critérios full / lite / update
│   ├── interview-questions.md     ← catálogo de perguntas (base PT-BR, traduzido em uso)
│   ├── stack-detection.md         ← mapa marcador → stack → comandos
│   ├── lessons-loop.md            ← formato exato das lições
│   └── sources.md                 ← fontes públicas da metodologia
└── scripts/
    └── detect_stack.sh            ← inspeção automática (JSON)
```

O `SKILL.md` fica dentro do limite ideal (<500 linhas) e usa progressive disclosure — os `references/` só carregam quando o Claude precisa deles.

---

## Filosofia

A metodologia vem de alguns princípios duros:

- **Enxuto** — CLAUDE.md deve ficar entre 80 e 150 linhas. Acima disso, mover regras específicas pra `.claude/rules/<tema>.md`.
- **Vivo** — regras saem de correções reais, não de achismo. O loop de lições é o ponto central.
- **Commitado** — `.claude/CLAUDE.md` e `tasks/*` no git pra o time inteiro usar o mesmo. `.claude/local.md` no `.gitignore` pra notas pessoais.
- **Plan Mode por padrão** — tarefas não-triviais começam com um plano em `tasks/todo.md`, revisado antes de codar.
- **Subagentes pra contexto limpo** — tarefas paralelas vão pra subagentes; o contexto principal fica enxuto.

---

## Roadmap

- [ ] Adicionar mais stacks ao `detect_stack.sh` (Elixir, Scala, Haskell)
- [ ] Templates específicos por framework (Next, Django, Rails, etc.)
- [ ] Comando pra consolidar lições (agrupar por tema quando cresce)
- [ ] Hook pra lembrar de revisar `tasks/lessons.md` 1×/semana

Contribuições são bem-vindas — abra uma issue ou PR.

---

## Créditos e fontes

Esta skill sintetiza conteúdo público:

- [Claude Code — Best Practices (Anthropic)](https://code.claude.com/docs/en/best-practices) — doc oficial
- [Boris Cherny no GitHub](https://github.com/bcherny) — criador do Claude Code
- [Thread "My Claude Code setup"](https://x.com/bcherny/status/2007179832300581177) — setup vanilla do Boris
- [0xquinto/bcherny-claude](https://github.com/0xquinto/bcherny-claude) — config baseada no thread
- [llcoolblaze/claude-boris](https://github.com/llcoolblaze/claude-boris) — "The Ultimate Claude Code Workflow"
- [abhishekray07/claude-md-templates](https://github.com/abhishekray07/claude-md-templates) — coletânea por stack
- [HumanLayer: Writing a good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md) — argumento do "menos é mais"

Ver `references/sources.md` pra lista completa.

---

## Licença

MIT — ver [LICENSE](LICENSE).
