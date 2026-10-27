# frozen_string_literal: true

require "json"
require "yeptris/yaml"
require "lutaml/model"

module Lutaml
  # AsyncAPI 2.6/3.0/3.1 as a lossless lutaml-model.
  module Asyncapi
    autoload :Document, "lutaml/asyncapi/document"
    autoload :Typed, "lutaml/asyncapi/typed"

    # Parses an AsyncAPI document (YAML or JSON) into a Document.
    def self.parse(string)
      data = parse_raw(string)
      Document.from_json(JSON.generate(data))
    end

    def self.parse_raw(string)
      case string
      when /\A\s*{/
        JSON.parse(string)
      else
        Yeptris::YAML.load(string)
      end
    end
  end
end
