# frozen_string_literal: true

require "lutaml/asyncapi/typed"

module Lutaml
  module Asyncapi
    # The root AsyncAPI document object, in the 3.x shape.
    #
    # Losslessness lives on the raw mapping: every section is kept verbatim
    # and unmodeled keywords re-emit on serialization (map_unmapped).
    # Round-trip assertions go through to_json — Serializable#to_hash emits
    # attribute names, not mapped wire names.
    class Document < Lutaml::Model::Serializable
      include Typed

      attribute :asyncapi, :string
      attribute :id, :string
      attribute :info, :hash
      attribute :servers, :hash
      attribute :default_content_type, :string
      attribute :channels, :hash
      attribute :operations, :hash
      attribute :components, :hash
      attribute :tags, :hash, collection: true
      attribute :external_docs, :hash
      attribute :extensions, :hash, default: -> { {} }

      json do
        map "asyncapi", to: :asyncapi
        map "id", to: :id
        map "info", to: :info
        map "servers", to: :servers
        map "defaultContentType", to: :default_content_type
        map "channels", to: :channels
        map "operations", to: :operations
        map "components", to: :components
        map "tags", to: :tags
        map "externalDocs", to: :external_docs
        map_unmapped to: :extensions
      end

      # The 2.x dialects embed publish/subscribe in channels and carry
      # root tags/externalDocs; the 3.x model holds them verbatim until
      # the 2.x frontend (PLAN.md M1) normalizes the operation view.
      def dialect
        version = asyncapi.to_s
        case version
        when /\A2\./ then "2.x"
        when /\A3\./ then "3.x"
        end
      end
    end
  end
end
