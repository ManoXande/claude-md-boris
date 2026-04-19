# Stack Detection Reference

Mapa de arquivos-marcador → stack → comandos mais prováveis. Use o script `scripts/detect_stack.sh` pra cobrir o grosso; caia aqui quando precisar inferir algo mais fino.

## JavaScript / TypeScript

| Marcador | Significa | Comandos típicos |
|---|---|---|
| `package.json` com `"next"` | Next.js | `npm run dev` / `npm run build` / `npm test` |
| `package.json` com `"vite"` | Vite (React/Vue/Svelte) | `npm run dev` / `npm run build` |
| `package.json` com `"@remix-run/*"` | Remix | `npm run dev` |
| `package.json` com `"nuxt"` | Nuxt | `npm run dev` |
| `package.json` com `"express"` ou `"fastify"` | Node API | `npm start` |
| `tsconfig.json` | TypeScript em qualquer lugar | |
| `bun.lockb` | Bun em vez de Node | `bun dev` |
| `deno.json` | Deno | `deno task ...` |
| `yarn.lock` | Yarn | `yarn <script>` |
| `pnpm-lock.yaml` | pnpm | `pnpm <script>` |

**Dica:** leia `package.json` → `scripts` direto. Se tem `"test": "vitest"`, o comando de teste é `npm test`.

## Python

| Marcador | Significa | Comandos típicos |
|---|---|---|
| `pyproject.toml` + `[tool.poetry]` | Poetry | `poetry run pytest` |
| `pyproject.toml` + `[tool.hatch]` | Hatch | `hatch run test` |
| `pyproject.toml` + `[tool.uv]` ou `uv.lock` | uv | `uv run pytest` |
| `requirements.txt` só | pip direto | `pytest` / `python -m pytest` |
| `manage.py` | Django | `python manage.py runserver` / `python manage.py test` |
| `fastapi` em deps | FastAPI | `uvicorn main:app --reload` |
| `flask` em deps | Flask | `flask run` |
| `ruff.toml` / `.ruff.toml` | Ruff como linter | `ruff check .` |
| `.flake8` / `setup.cfg` | flake8 | `flake8 .` |
| `mypy.ini` | mypy | `mypy .` |

## Rust

- `Cargo.toml` → `cargo build` / `cargo test` / `cargo clippy` / `cargo fmt`

## Go

- `go.mod` → `go build ./...` / `go test ./...` / `go vet ./...`

## Java / Kotlin

- `pom.xml` → Maven: `mvn test`
- `build.gradle` / `build.gradle.kts` → Gradle: `./gradlew test`

## Ruby

- `Gemfile` → `bundle exec rspec` ou `bundle exec rake test`
- `Gemfile` + `config.ru` → Rails/Sinatra

## PHP

- `composer.json` → `composer test`
- `artisan` → Laravel: `php artisan test`

## .NET

- `*.csproj` / `*.sln` → `dotnet build` / `dotnet test`

## Infra marcadores

| Marcador | O que sinaliza |
|---|---|
| `Dockerfile` | Containerizado |
| `docker-compose.yml` | Multi-service local |
| `.github/workflows/*.yml` | GitHub Actions |
| `.gitlab-ci.yml` | GitLab CI |
| `vercel.json` / `netlify.toml` | Deploy de JS na nuvem |
| `fly.toml` | Fly.io |
| `railway.json` | Railway |
| `terraform/` / `*.tf` | IaC |
| `k8s/` / `helm/` | Kubernetes |

## Ordem de investigação recomendada

1. `ls` do diretório raiz → marcadores principais.
2. Leia `package.json` / `pyproject.toml` / `Cargo.toml` / `go.mod` pra nome do projeto e scripts.
3. `ls src/` (se existir) pra layout.
4. Cheque `.github/workflows/` pra comandos de CI — boa fonte de verdade do que "sempre roda".
5. Procure `README.md` raiz — costuma ter o comando oficial.
