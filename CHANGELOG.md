# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

## [0.1.2] - 2026-10-31

- Frontend parity with lutaml-jsonschema's SPA: typed en+ar string
  catalog with locale switch, RTL layout, axe AA audit in the default
  rake gate, vitest suite, CI frontend build
- Floor yeptris at the fixed `~> 0.6.51` line (marshal strict-dup
  false-positive fixed, yeptris-ruby#333)

## [0.1.1] - 2026-10-28

- Rejoin the gitter + slack goldens (lutaml-model 0.8.132 fixed the
  nested-hash text-key corruption); floor lutaml-model there
- Ship the SPA dist through the release train; self-contained in-repo
  release workflow (RubyGems Trusted Publishing)
- M4 single-file AsyncAPI documentation site; README usage and
  dialect-detection expansion
- Frontend dev toolchain bumped past the vulnerable ranges

## [0.1.0] - 2026-10-25

- Initial release: lossless AsyncAPI 2.6/3.0/3.1 model on lutaml-model,
  full 17-document corpus parse + round-trip verification
