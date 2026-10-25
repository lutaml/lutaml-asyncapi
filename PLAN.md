# PLAN.md — lutaml-asyncapi: AsyncAPI as a model-based standard

The event-driven counterpart of the OpenAPI program
([metanorma/metanorma-ogc#153](https://github.com/metanorma/metanorma-ogc/issues/153),
`lutaml/lutaml-openapi`): make the AsyncAPI definition the **primary
publication** of event-driven / pub-sub API standards, with normative
documentation driven by the AsyncAPI model.

## Mission

Parse **AsyncAPI 2.6, 3.0 and 3.1** documents into a lossless lutaml-model
object graph (raw-hash fidelity first, typed views on demand), and feed them
to documentation renderers the way `lutaml-openapi` feeds
`metanorma-plugin-openapi`.

## Audit basis (2026-10-25)

Full spec read: `asyncapi/spec` `spec/asyncapi.md` (v3.1.0, 39 objects),
meta-schemas `asyncapi/spec-json-schemas` (definitions 1.0.0–3.1.0).
Corpus: 17 documents in `spec/fixtures` — 15 official 3.1.0 examples,
`asyncapi-connectedsystems-2.yaml` (2.6.0, 9 embedded publish/subscribe
operations), `edr-pubsub-asyncapi.yaml` (3.0.0). **All parse; 15/17 round-trip
losslessly** — `gitter-streaming` and `slack-rtm` are blocked upstream by
[lutaml/lutaml-model#1013](https://github.com/lutaml/lutaml-model/issues/1013)
(nested `:hash` attributes silently rename key `text` → `type` and drop
sibling `description`); they are vendored but excluded from goldens until
that ships.

Corpus facts shaping the model: no `schemaFormat` (Multi Format Schema)
usage in the wild corpus; bindings sparse (kafka/mqtt/websocket); components
sections seen in the wild: schemas, messages, parameters, securitySchemes,
correlationIds, messageTraits, operationTraits (the model must still cover
the full Components Object inventory: servers, channels, operations, replies,
replyAddresses, externalDocs, tags, serverBindings, channelBindings,
operationBindings, messageBindings, serverVariables).

## Repos and org parity

| Repo | Org | Role | Setup cloned from |
|---|---|---|---|
| `lutaml/lutaml-asyncapi` | lutaml | the model gem (this repo) | lutaml-openapi (generic-rake CI, cimas release train, rubocop baseline, BSD-2-Clause) |
| `metanorma/metanorma-plugin-asyncapi` | metanorma | the Metanorma plugin (M3) | metanorma-plugin-openapi (preprocessor splice, real sections) |

Team access mirrors siblings: staff:admin, developers:push, ci:push,
express:push, editors:push.

## Architecture

```
AsyncAPI 2.6 / 3.0 / 3.1 (YAML/JSON)
        │ parse (2.x/3.0 normalized into the 3.x-shaped model; source version kept)
        ▼
Lutaml::Asyncapi::Document            (lossless: mapped roots + map_unmapped)
        │                              round-trip goes through to_json —
        │                              Serializable#to_hash emits attribute names
        ├─► typed views (channels, operations, messages) on demand
        └─► metanorma-plugin-asyncapi (M3): preprocessor splice — block
            processors can never yield sections (Parser.parse_blocks limit)
```

## Milestones

- **M0 — model seed (this repo)**: `Lutaml::Asyncapi.parse` (Yeptris
  YAML/JSON by sniffing, version detect), `Document` (3.x shape,
  `map_unmapped` extensions), lossless round-trip goldens from the corpus.
  Done-when: 15/17 goldens green, rubocop clean, CI green.
- **M1 — full typed model**: typed views for channels/operations/messages/
  components incl. Multi Format Schema, bindings, security schemes; 2.6
  frontend (embedded publish/subscribe → operation view, like Oas30).
  Done-when: every spec object has a typed accessor and a spec.
- **M2 — validation**: offline meta-schema checks against the vendored
  asyncapi/spec-json-schemas (lutaml-jsonschema precedent, JSON Pointer
  error paths).
- **M3 — metanorma-plugin-asyncapi**: renderer + preprocessor; OGC
  connected-systems part 2 and EDR pubsub as the acceptance corpus.
- **M4 — SPA frontend**: single-file human documentation (lutaml-xsd /
  lutaml-jsonschema precedent).

## Standing laws

- Losslessness lives on the raw hash; typed views are on-demand.
- No hand-rolled serialization — lutaml-model mappings only
  (`map`/`map_unmapped`/attribute serializers).
- No doubles in specs — real documents from the corpus.
- Round-trip assertions go through `to_json` (see the `to_hash` gotcha).
- Versions are the owner's decision; releases only on explicit instruction.
