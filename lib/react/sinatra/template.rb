module React
  module Sinatra
    # Module for reading and evaluating templates.
    #
    # @example
    #   React::Sinatra::Template[:polyfill]
    #   React::Sinatra::Template.evaluate(:runtime, render_function: 'customRender')
    #
    # @!visibility private
    module Template
      # Reads static template from signature.
      #
      # @param [String, Symbol] signature The name of template
      # @raise [Errno::ENOENT] Raised if template cannot found by given signature.
      # @return [String]
      # @!visibility private
      def self.[](signature)
        signature = signature.to_s
        templates_cache.fetch(signature) do
          path = File.expand_path("templates/#{signature}.js", __dir__)
          templates_cache[signature] ||= File.read(path)
        end
      end

      # Evaluates template from signature.
      # 
      # @param [String, Symbol] signature The name of template
      # @param [Hash] attributes The attributes are passed to the template.
      # @raise [Errno::ENOENT] Raised if template cannot found by given signature.
      # @return [String]
      # @!visibility private
      def self.evaluate(signature, **attributes)
        self[signature] % attributes
      end

      # Map for caching templates
      #
      # @return [Hash<String: String>]
      # @!visibility private
      def self.templates_cache
        @templates_cache ||= {}
      end
    end
  end
end
