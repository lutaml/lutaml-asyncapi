# frozen_string_literal: true

require "spec_helper"

FIXTURES = File.expand_path("fixtures", __dir__).freeze

RSpec.describe Lutaml::Asyncapi::Typed do
  def doc(name)
    Lutaml::Asyncapi.parse(File.read(File.join(FIXTURES, name)))
  end

  it "exposes typed server, channel and operation entries for 3.x" do
    d = doc("streetlights-kafka-asyncapi.yml")
    servers = d.server_entries
    expect(servers.first).to include(:name, :protocol)
    expect(servers.first[:protocol]).to eq("kafka-secure")
    channels = d.channel_entries
    expect(channels.map { |c| c[:id] }).to include("lightingMeasured")
    ops = d.operation_entries
    expect(ops.keys).to include("receiveLightMeasurement", "turnOn")
    subscribe_ops = ops.select { |_k, o| o[:action] == "receive" }
    expect(subscribe_ops).not_to be_empty
    messages = d.message_entries
    expect(messages.keys).to include("lightMeasured")
  end

  it "normalizes 2.x embedded publish/subscribe into operations" do
    d = doc("asyncapi-corpus-2x.yaml")
    ops = d.operation_entries
    expect(ops.keys.count).to be > 0
    expect(ops.values.map do |o|
      o[:action]
    end.uniq).to match_array(%w[publish subscribe])
    expect(ops.keys).to all(match(/\.publish|\.subscribe/))
  end

  it "exposes typed message entries for a corpus document with payloads" do
    d = doc("streetlights-mqtt-asyncapi.yml")
    messages = d.message_entries
    light = messages["dimLight"]
    expect(light).to include(:payload)
  end
end
