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
unmodeled keywords re-emit on serialization (`map_unmapped`), and
round-trips are asserted against the OGC and AsyncAPI corpus in
`spec/fixtures`. Two vendored corpus documents (gitter-streaming,
slack-rtm) are excluded pending
[lutaml-model#1013](https://github.com/lutaml/lutaml-model/issues/1013) —
fixed on lutaml-model main; they rejoin the goldens at the next
lutaml-model release.

See [PLAN.md](PLAN.md) for the program plan.
