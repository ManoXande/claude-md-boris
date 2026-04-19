# Language Detection Rules

Regra detalhada pra decidir em qual idioma falar com o usuário e em qual idioma gerar o CLAUDE.md.

## Princípios

1. **Chat segue o usuário.** Em qual idioma ele escreveu → nesse idioma você responde. Sem exceção.
2. **Arquivo segue a comunidade.** O CLAUDE.md é lido por ferramentas e colaboradores; inglês é o default seguro.
3. **Quando conflitam, o usuário manda.** Se ele pedir o arquivo em outro idioma, gere no idioma pedido.

---

## Como detectar o idioma do chat

### Sinais primários

Olhe a última mensagem do usuário. Procure:

- **Palavras-chave exclusivas do idioma** — "você", "pra", "tá", "meu" → PT-BR; "mate", "bloke", "cheers" → EN-GB; "vale", "tío" → ES; "mec", "ouais" → FR.
- **Acentos e caracteres específicos** — `ã`, `õ`, `ç` → PT; `ñ` → ES; `ü`, `ß` → DE; `ç`, `à`, `é` sem `ã` → FR.
- **Estrutura gramatical** — artigos ("the/a/an" EN vs. "o/a/um/uma" PT vs. "el/la" ES).
- **Colocação pronominal** — "se chamar" (PT-BR) vs. "chamar-se" (PT-PT).

### Variantes a distinguir

Quando relevante, note a variante:

| Variante | Sinais |
|---|---|
| **PT-BR** | "você", "a gente", "pra", "vamo", "tá", "chave ali" |
| **PT-PT** | "tu", "está-se", "apanhar", "miúdo", "cá" |
| **EN-US** | "color", "gotten", "awesome" |
| **EN-GB** | "colour", "whilst", "mate", "cheers" |
| **ES-LA** | "vos/ustedes", "che" |
| **ES-ES** | "vosotros", "tío", "vale" |

Pra maioria dos casos, basta "PT", "EN", "ES" etc. Diferencie só quando fizer diferença real (ex.: formalidade do você/tu).

### Mistura de idiomas (code-switching)

Comum em tech: "preciso criar um CLAUDE.md for this project using the Boris methodology". Nesse caso:

1. Conte palavras NÃO-técnicas de cada idioma.
2. Termos técnicos estáveis (CLAUDE.md, TypeScript, snake_case, API, commit) são **neutros** — ignore.
3. Siga a maioria.

Exemplo:
> "cria um CLAUDE.md pra esse projeto seguindo o Boris methodology"

Palavras não-técnicas em PT: *cria, pra, esse, projeto, seguindo, o*. Em EN: *methodology*. → **PT-BR**.

### Ambiguidade real

Se tiver 1-2 palavras e não der pra decidir ("ok, go", "sim", "yes"), olhe as **mensagens anteriores** da conversa. Se ainda estiver empatado, pergunte em 2 idiomas:

> "Prefere que eu continue em português ou inglês? / Do you want me to continue in Portuguese or English?"

Nunca chute silenciosamente.

---

## Aplicação: o que fica no idioma do usuário

Quando você detecta o idioma (digamos, PT-BR), o **chat inteiro** fica nele:

- Confirmações ("Vou criar os arquivos em `.claude/`, tudo bem?")
- Perguntas do `AskUserQuestion` — traduza labels e options de `interview-questions.md`
- Explicação final do loop de lições
- Mensagens de erro / dúvidas

O que **não** muda com o idioma:

- Nomes de arquivos e paths (`CLAUDE.md`, `tasks/todo.md`, `.claude/`)
- Comandos shell (`npm test`, `cargo build`)
- Termos técnicos estáveis (TypeScript strict, Plan Mode, subagentes)
- Nomes de seções dentro do template quando a geração for em inglês

---

## Aplicação: em qual idioma gerar o CLAUDE.md

Matriz de decisão:

| Situação | Idioma do arquivo |
|---|---|
| Usuário escreveu em inglês | Inglês |
| Usuário escreveu em PT/ES/outro, sem pedir explícito | **Inglês (default)** |
| Usuário escreveu em PT/ES e pediu explícito ("em português mesmo") | Idioma pedido |
| Projeto já tem `CLAUDE.md` ou `README.md` em PT/ES/outro | Pergunte antes de decidir |
| Projeto é open source / vai ser público | Inglês (mesmo que o usuário fale outro idioma), a menos que o usuário peça ao contrário |

Quando pedir? Uma única pergunta simples:

> "Gero o CLAUDE.md em inglês (padrão da comunidade) ou em português mesmo?"

Com opções:
- **Inglês (Recommended)** — "Compatível com repos públicos e documentação oficial"
- **Português** — "Pra equipes que só falam português"
- **Ambos** — "Duas versões: `.claude/CLAUDE.md` (EN) + `.claude/CLAUDE.pt.md`"

## Templates dos prompts recomendados — PT-BR

Pra referência rápida, alguns prompts padrão no idioma do usuário mais comum:

- **Confirmação de triagem**: "Antes de prosseguir: isso é um projeto que vai crescer (setup completo) ou algo mais simples (CLAUDE.md enxuto)?"
- **Confirmação de idioma do arquivo**: "Gero o arquivo em inglês (padrão da comunidade) ou em português?"
- **Registro de lição**: "Resumi a lição assim: *[título]*. Confirmo e gravo em `tasks/lessons.md` + `CLAUDE.md`?"
- **Entrega final**: "Pronto. Me avise 'registra essa lição' quando eu errar pra eu atualizar o arquivo."

## Templates — EN

- **Triage confirmation**: "Before we proceed: is this a project that'll grow (full setup) or something simpler (lite CLAUDE.md)?"
- **File language confirmation**: "Generate the file in English (community default) or in your language?"
- **Lesson registration**: "I've summarized the lesson as: *[title]*. Confirm and save to `tasks/lessons.md` + `CLAUDE.md`?"
- **Final handoff**: "Done. Tell me 'register this lesson' when I mess up and I'll update the file."

## Templates — ES

- **Confirmación de triaje**: "Antes de continuar: ¿es un proyecto que va a crecer (setup completo) o algo más simple (CLAUDE.md corto)?"
- **Confirmación de idioma del archivo**: "¿Genero el archivo en inglés (estándar de la comunidad) o en español?"
- **Registro de lección**: "Resumí la lección así: *[título]*. ¿Confirmo y guardo en `tasks/lessons.md` + `CLAUDE.md`?"
- **Entrega final**: "Listo. Avísame con 'registra esta lección' cuando me equivoque para actualizar el archivo."

Pra outros idiomas (FR, IT, DE, etc.), traduza mantendo o tom direto e curto.

---

## Anti-padrões (não faça isso)

- **Não** responda em inglês pra quem te escreveu em português só porque os arquivos do projeto estão em inglês.
- **Não** pergunte "em qual idioma você quer?" no início — você deve detectar. Só pergunte se genuinamente não der.
- **Não** misture idiomas numa mesma frase pra o usuário ("Vou criar o CLAUDE.md with the default template").
- **Não** mude de idioma no meio da conversa sem motivo — se o usuário trocou de PT pra EN, siga. Se foi ruído, continue no original.
- **Não** assuma que "usuário falou tech em inglês" = "quer tudo em inglês". Tech em inglês é neutro.
