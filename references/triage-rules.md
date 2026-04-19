# Triage Rules — full vs lite vs update

A skill não deve ser "tudo ou nada". Antes de gerar qualquer coisa, decida em qual modo você está.

## Sinais para modo FULL

Ative se **pelo menos dois** forem verdade:

- Há um `.git/` ou o usuário mencionou "repositório" / "branch" / "time".
- Existem pelo menos 5 arquivos de código sem contar lockfiles.
- Existe um dos: `package.json`, `pyproject.toml`, `requirements.txt`, `Cargo.toml`, `go.mod`, `pom.xml`, `Gemfile`, `composer.json`, `*.csproj`.
- Existem comandos de build / test / lint detectáveis.
- O usuário mencionou produção, cliente, deploy, CI, PR, code review, staff engineer, ou equivalente.

Saída: `CLAUDE.md` completo + `tasks/todo.md` + `tasks/lessons.md` + pasta `.claude/`.

## Sinais para modo LITE

Ative se **qualquer um** for verdade:

- O diretório tem menos de 5 arquivos de código.
- Caminho inclui `/tmp`, `~/Desktop`, `scratch`, `playground`, `sandbox`, `experiments`.
- Não há `.git/` e o usuário disse algo tipo "é só pra testar / brincar / um script rápido".
- Não há build/test/lint detectável E não há framework reconhecido.
- É um notebook solto, uma gist, ou um arquivo único.

Saída: só `CLAUDE.md` curto (sem `tasks/`, sem `.claude/`).

## Sinais para modo UPDATE

Ative sempre que:

- Já existe `.claude/CLAUDE.md` ou `CLAUDE.md` no diretório.
- O usuário disse "registra essa lição", "atualiza o CLAUDE.md", "adiciona essa regra", "não deixa eu repetir esse erro".

Saída: só edita os arquivos existentes. Não regenera.

## Quando estiver em dúvida

Pergunte. Uma pergunta vale menos que um CLAUDE.md errado. Exemplo:

> "Antes de prosseguir: isso é um projeto que vai crescer (aí faço o setup completo com `.claude/`, `tasks/todo.md` e `tasks/lessons.md`) ou é algo mais simples (aí faço só um CLAUDE.md enxuto)?"

## Observações

- Modo LITE pode virar FULL depois. Mencione isso no rodapé do template lite.
- Se o projeto claramente vai pra produção mas está começando do zero, use FULL mesmo com poucos arquivos.
- Se o usuário pediu explicitamente "versão completa" ou "versão simples", respeite.
