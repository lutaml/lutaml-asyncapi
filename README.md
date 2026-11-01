# lutaml-asyncapi

AsyncAPI 2.6/3.0/3.1 as a lossless [lutaml-model](https://github.com/lutaml/lutaml-model)
object graph — the model layer for model-based AsyncAPI standards.

```ruby
require "lutaml/asyncapi"

doc = Lutaml::Asyncapi.parse(File.read("asyncapi.yaml"))
doc.asyncapi    # => "3.1.0"
doc.dialect     # => "3.x" (or "2.x" for embedded publish/subscribe documents)
doc.channels    # => { "userSignedUp" => { "address" => "user/signedup", ... } }
doc.to_json     # lossless re-serialization
```

## Losslessness

The raw mapping is preserved verbatim: every section is kept as parsed,
unmodeled keywords re-emit on serialization (`map_unmapped`), and the wire
round trip (`parse → to_json`) is asserted losslessly for the **entire
17-document corpus** vendored in `spec/fixtures` — the official 3.1 examples,
connected-systems 2.6, and the EDR pubsub 3.0 document. Wire round trips go
through `to_json`; `to_hash` emits Ruby attribute names, not wire names.

See [PLAN.md](PLAN.md) for the program plan.
