# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`lutaml-asyncapi` parses AsyncAPI 2.6/3.0/3.1 documents into lutaml-model objects and generates a single-file SPA documentation site from them — the event-driven counterpart of `lutaml-openapi`, and the model layer for model-based AsyncAPI standards (metanorma-ogc#153); `metanorma-plugin-asyncapi` renders these models into Metanorma documents.

## Commands

```sh
bundle exec rspec                          # full suite (17-doc corpus golden included)
bundle exec rspec spec/asyncapi_spec.rb    # one file
bundle exec rubocop                        # lint (-a to autofix; .rubocop_todo.yml holds baselined offenses)
bundle exec rake                           # spec + rubocop + frontend:audit (axe; needs Chrome, skips cleanly without)

cd frontend && npm test                    # vitest (frontend i18n suite)
cd frontend && npm run build               # vite build → frontend/dist
```

`frontend/dist/` and `Gemfile.lock` are gitignored. `frontend/dist/` must exist for the SPA generator. The rake CI does NOT build the frontend — run `npm ci && npm run build` locally to verify frontend changes.

## Architecture

- **`Lutaml::Asyncapi.parse`** — the document is stored verbatim; wire round trips (`to_json`) are asserted losslessly for the whole corpus (spec/asyncapi_spec.rb iterates every fixture). Round-trip checks go through `to_json` — `Serializable#to_hash` emits Ruby attribute names, not wire names.
- **2.x vs 3.x dialects** — 3.x carries top-level `operations`; 2.x embeds publish/subscribe in channels. `Typed` (lib/lutaml/asyncapi/typed.rb) normalizes both into the same operation shape for the typed view; the document hash itself stays in dialect shape.
- `lutaml-model` is floored at `~> 0.8.132` (the nested-hash text-key corruption fix, model#1013) — the gitter + slack corpus goldens require it.
- **`Spa`** inlines `frontend/dist` with `window.ASYNCAPI_DATA` into a standalone `index.html`; dist enters the gem only at release time.
- Corpus fixtures live in `spec/fixtures/` (17 documents, official 3.1 examples + connected-systems 2.6 + EDR pubsub 3.0); new fixtures are picked up automatically.

## CI/release

- `.github/workflows/rake.yml` builds the frontend (`after-setup-ruby`) so green lanes validate the SPA.
- `release.yml` is self-contained (RubyGems Trusted Publishing is registered against THIS repo's workflow): dispatch with `next_version=patch|minor|major|x.y.z`. It bumps the version, builds the dist, publishes, and tags.

## Frontend

- All UI strings flow through the typed catalog `frontend/src/i18n/messages.ts` (`en` + `ar`); a missing key in a locale is a type error. The header locale switch mirrors `lang`/`dir` onto `<html>` (RTL without a second stylesheet); `?locale=ar` boots into a locale.
- Layout uses CSS logical properties; the axe audit gates both the LTR and Arabic RTL renders.
