# frozen_string_literal: true

require "spec_helper"
require "yeptris/yaml"
require "json"

# gitter-streaming + slack-rtm are vendored but excluded: nested
# ":hash" nodes with a "text" key are corrupted by
# lutaml/lutaml-model#1013 until that ships
BLOCKED_BY_MODEL_1013 = %w[gitter-streaming-asyncapi.yml
                           slack-rtm-asyncapi.yml].freeze
GOLDENS = (Dir.children(FIXTURES).sort - BLOCKED_BY_MODEL_1013).freeze

RSpec.describe Lutaml::Asyncapi do
  it "parses every corpus document" do
    GOLDENS.each do |file|
      doc = described_class.parse(File.read(File.join(FIXTURES, file)))
      expect(doc.asyncapi).to match(/\A\d+\.\d+\.\d+/), file
    end
  end

  it "round-trips every corpus document losslessly" do
    GOLDENS.each do |file|
      source = File.read(File.join(FIXTURES, file))
      raw = described_class.parse_raw(source)
      doc = described_class.parse(source)
      expect(JSON.parse(doc.to_json)).to eq(JSON.parse(JSON.generate(raw))),
                                         file
    end
  end

  it "detects the dialect family" do
    a2s26 = described_class.parse(
      File.read(File.join(FIXTURES, "asyncapi-connectedsystems-2.yaml")),
    )
    a2s31 = described_class.parse(
      File.read(File.join(FIXTURES, "simple-asyncapi.yml")),
    )
    expect(a2s26.dialect).to eq("2.x")
    expect(a2s31.dialect).to eq("3.x")
  end

  it "reports its version" do
    expect(Lutaml::Asyncapi::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
