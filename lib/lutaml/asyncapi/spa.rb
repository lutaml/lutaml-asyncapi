# frozen_string_literal: true

require "json"

module Lutaml
  module Asyncapi
    # Generates a single-file SPA documentation site for an AsyncAPI
    # document. The frontend bundle (frontend/dist) is built by the
    # frontend toolchain and enters the gem only immediately before a
    # release.
    module Spa
      DIST = File.expand_path("../../../frontend/dist", __dir__)

      def self.generate(document, title: nil)
        app_js = File.read(File.join(DIST, "app.iife.js"))
        style = File.join(DIST, "style.css")
        data = safe_json(document.to_hash)

        title ||= document.to_hash.dig("info", "title") || "AsyncAPI document"

        build_html(escape(title), data, app_js, style_content(style))
      end

      def self.build_html(title, data, app_script, css)
        <<~HTML
          <!DOCTYPE html>
          <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>#{title}</title>
            <style>#{css}</style>
          </head>
          <body>
            <div id="app"></div>
            <script>window.ASYNCAPI_DATA = #{data};</script>
            <script>#{app_script}</script>
          </body>
          </html>
        HTML
      end

      def self.style_content(path)
        File.exist?(path) ? File.read(path) : ""
      end

      # JSON embedded in a <script> element: escape "<" so payload
      # strings containing "</script>" cannot break out
      def self.safe_json(obj)
        JSON.generate(obj).gsub("<") { |c| "\\u00#{c.ord.to_s(16)}" }
      end

      def self.escape(text)
        text.to_s.gsub("&", "&amp;").gsub("<", "&lt;")
      end
    end
  end
end
