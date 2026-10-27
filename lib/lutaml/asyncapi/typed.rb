# frozen_string_literal: true

module Lutaml
  module Asyncapi
    # Typed views over the raw document: the ergonomic accessor layer
    # for channels, operations and messages, dialect-aware. 3.x carries
    # top-level operations; 2.x embeds publish/subscribe in channels —
    # both normalize into the same operation shape.
    module Typed
      def server_entries
        (raw_hash["servers"] || {}).filter_map do |name, server|
          next unless server.is_a?(Hash)

          { name: name, url: server["url"], protocol: server["protocol"],
            protocol_version: server["protocolVersion"],
            description: server["description"] }.compact
        end
      end

      def channel_entries
        (raw_hash["channels"] || {}).filter_map do |id, channel|
          next unless channel.is_a?(Hash)

          { id: id, address: channel["address"], title: channel["title"],
            summary: channel["summary"], description: channel["description"],
            messages: channel["messages"], parameters: channel["parameters"],
            bindings: channel["bindings"] }.compact
        end
      end

      # { id => { action:, channel:, summary:, description:, messages: } }
      # 3.x operations reference their channel by $ref; the channel id
      # is resolved from the reference pointer.
      def operation_entries
        root_operations.merge(embedded_operations)
      end

      def root_operations
        ops = {}
        (raw_hash["operations"] || {}).each do |id, operation|
          next unless operation.is_a?(Hash)

          ops[id] = typed_operation(
            operation, channel_id_from_ref(operation["channel"])
          )
        end
        ops
      end

      def embedded_operations
        ops = {}
        (raw_hash["channels"] || {}).each do |id, channel|
          next unless channel.is_a?(Hash)

          append_embedded(ops, id, channel)
        end
        ops
      end

      def append_embedded(ops, id, channel)
        %w[publish subscribe].each do |action|
          if (operation = channel[action]).is_a?(Hash)
            ops["#{id}.#{action}"] = typed_operation(
              operation.merge("action" => action), id
            )
          end
        end
      end

      def message_entries
        found = {}
        walk(raw_hash) do |node|
          next unless message_node?(node)

          id = node["name"] || node["title"]
          next if id.nil?

          found[id] = message_entry(node)
        end
        found
      end

      def message_node?(node)
        node.is_a?(Hash) && (node["payload"] || node["headers"])
      end

      def message_entry(node)
        { name: node["name"], title: node["title"],
          summary: node["summary"], description: node["description"],
          payload: node["payload"], headers: node["headers"],
          content_type: node["contentType"] }.compact
      end

      private

      def raw_hash
        to_hash
      end

      def typed_operation(operation, channel_id)
        { action: operation["action"], channel: channel_id,
          title: operation["title"], summary: operation["summary"],
          description: operation["description"],
          messages: operation["messages"],
          reply: operation["reply"] }.compact
      end

      def channel_id_from_ref(reference)
        return nil unless reference.is_a?(Hash)

        (reference["$ref"] || "").split("/").last
      end

      def walk(node, &block)
        case node
        when Hash
          yield node
          node.each_value { |value| walk(value, &block) }
        when Array
          node.each { |value| walk(value, &block) }
        end
      end
    end
  end
end
