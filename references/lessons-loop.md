# Loop de Lições — formato e mecânica

O diferencial da metodologia Boris não é o template, é o **loop**. Ele só funciona se a captura de lições for barata o bastante pra acontecer toda vez.

## Quando uma lição deve ser registrada

- O usuário te corrigiu ("não é assim, faz desse jeito").
- Você percebeu que errou antes do usuário (melhor ainda — registre sozinho).
- Uma decisão arquitetural importante foi tomada e convém futuras sessões respeitarem.
- Um bug voltou ("já falei pra você não fazer isso").

Nem toda conversa vira lição. Critério: **"se eu virar essa frase numa regra, ela serve pro projeto inteiro ou só pra essa task?"** Se é só pra task, não registre.

## Formato da entrada

Cada lição tem três linhas. Mais que isso vira ruído.

```markdown
### 2026-04-19 — Não confiar em timezone do servidor
- **Pattern**: Usei `new Date()` pra gerar timestamps de evento; em produção (UTC) deu off por fuso.
- **Rule**: Sempre passar timezone explícito; usar `Temporal.Instant` ou `date-fns-tz` com zona do usuário.
- **Why**: Servidores rodam em UTC, usuários não. Diferença de 3h quebra relatórios diários.
```

Nota: título curto (≤ 60 chars), imperativo na Rule, uma única linha no Why.

## Onde escrever

Escreva nos **dois** lugares:

1. **`tasks/lessons.md`** — append-only, histórico cronológico. Mais recente no topo.
2. **`.claude/CLAUDE.md` → seção "Forbidden Patterns"** — resumo compactado, uma linha:
   ```
   - Nunca usar `new Date()` sem timezone — usar Temporal.Instant ou date-fns-tz (2026-04-19)
   ```

O `tasks/lessons.md` é pro humano revisar 1× por semana. O `CLAUDE.md` é pra Claude ler toda sessão. Por isso o formato é diferente.

## Consolidação periódica

Depois de algumas semanas, a seção "Forbidden Patterns" no `CLAUDE.md` tende a crescer. Quando passar de ~15 itens:

- Agrupe por tema (ex: "Datas e timezone", "Erros de API", "Segurança").
- Se houver 5+ regras sobre o mesmo tema, mova pra `.claude/rules/<tema>.md` e deixe no `CLAUDE.md` só um `@rules/<tema>.md`.
- Remova lições que viraram hábito e não reaparecem há 1+ mês.

O `tasks/lessons.md` continua intocado (é histórico).

## Fluxo do comando "registra essa lição"

Quando o usuário disser algo como:
> "registra essa lição / atualiza o CLAUDE.md / não deixa isso repetir"

1. Identifique o erro (do contexto recente se óbvio, ou pergunte "qual foi a lição em uma frase?").
2. Formule título + Pattern + Rule + Why (3-4 linhas).
3. Mostre o diff ao usuário (antes de gravar):
   ```
   Vou adicionar essa entrada em tasks/lessons.md e esta linha em .claude/CLAUDE.md:
   - Nunca usar `new Date()` sem timezone — ...
   Confirma?
   ```
4. Depois de confirmar, grave nos dois arquivos.
5. Feche com uma linha curta: "Registrado. Próxima sessão eu já venho com isso em contexto."

## Anti-padrões (o que não fazer)

- **Não** inflar o `CLAUDE.md` com toda a explicação — ela vive no `lessons.md`.
- **Não** gravar sem confirmar o diff.
- **Não** transformar toda dor em regra. Escolha lições generalizáveis.
- **Não** deixar regras contraditórias. Se uma nova contradiz uma antiga, remova a antiga e explique a mudança no `lessons.md`.
