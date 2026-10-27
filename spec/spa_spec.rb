# frozen_string_literal: true

require "spec_helper"
require "lutaml/asyncapi/spa"

RSpec.describe Lutaml::Asyncapi::Spa do
  before do
    unless File.exist?(File.join(described_class::DIST, "app.iife.js"))
      skip "frontend/dist not built — run rake frontend:build"
    end
  end

  it "generates a single-file site with the document data inlined" do
    doc = Lutaml::Asyncapi.parse(
      File.read(File.join(FIXTURES, "simple-asyncapi.yml")),
    )
    html = described_class.generate(doc)
    expect(html).to include("window.ASYNCAPI_DATA = ")
    expect(html).to include('<div id="app">')
  end

  it "escapes the title" do
    doc = Lutaml::Asyncapi.parse(<<~YAML)
      asyncapi: 3.1.0
      info:
        title: A <script>alert(1)</script> title
    YAML
    html = described_class.generate(doc)
    expect(html).not_to include("<script>alert(1)")
    expect(html).to include("&lt;script")
  end
end
