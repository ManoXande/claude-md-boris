# Fontes

Materiais públicos que fundamentam as decisões desta skill.

## Oficial Anthropic

- [Claude Code — Best Practices](https://code.claude.com/docs/en/best-practices) — doc oficial da Anthropic sobre CLAUDE.md, subagentes, Plan Mode.
- [Claude Code docs](https://code.claude.com/docs) — referência geral da CLI.

## Boris Cherny (criador do Claude Code)

- [@bcherny no GitHub](https://github.com/bcherny) — perfil do Boris.
- [Thread do Boris "My Claude Code setup"](https://x.com/bcherny/status/2007179832300581177) — setup vanilla do criador.
- [Gist "Claude Code setup from Boris Cherny"](https://gist.github.com/Artur-at-work/6d3ee182bc32052dfd283a831350f282) — resumo da comunidade.

## Templates de comunidade (consultados)

- [0xquinto/bcherny-claude](https://github.com/0xquinto/bcherny-claude) — Claude Code config baseada no thread do Boris.
- [llcoolblaze/claude-boris](https://github.com/llcoolblaze/claude-boris) — "The Ultimate Claude Code Workflow", versão estendida.
- [meleantonio/ChernyCode](https://github.com/meleantonio/ChernyCode) — template compilando tips do Boris.
- [abhishekray07/claude-md-templates](https://github.com/abhishekray07/claude-md-templates) — coletânea de CLAUDE.md por stack.
- [maximus0411/BorisChernyClaudeMarkdown](https://github.com/maximus0411/BorisChernyClaudeMarkdown) — template com Agentic Context Engineering.
- [centminmod/my-claude-code-setup](https://github.com/centminmod/my-claude-code-setup) — memory bank CLAUDE.md.

## Posts que influenciaram o formato

- [Writing a good CLAUDE.md — HumanLayer](https://www.humanlayer.dev/blog/writing-a-good-claude-md) — argumento do "menos é mais" (root file < 60 linhas).
- [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) — compilado de boas práticas + tips do Boris.

## Observações desta skill

- O **tamanho ideal** (80-120 linhas, teto 150) vem do consenso entre o template do Boris (~100 linhas no próprio repo do Claude Code) e o blog da HumanLayer (< 60 linhas). Escolhemos um meio-termo que cabe a maioria dos projetos.
- A **estrutura em 9 seções** espelha o template fornecido pelo usuário na conversa original (que por sua vez sintetiza os repos acima).
- O **loop de lições** aparece em praticamente todas as fontes — é o ponto mais consensual da metodologia.
- A **separação `.claude/CLAUDE.md` commitado + `.claude/local.md` gitignored + `~/.claude/CLAUDE.md` global** é padrão oficial da Anthropic.
