require 'json'
require 'padrino-helpers'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/string/inflections'
require 'react/sinatra/pool'

module React
  module Sinatra
    # Class for expressing react component.
    #
    # This is main entrypoint for rendering react component
    #   and is referred from {React::Sinatra::Helpers#react_component}.
    class Component
      include Padrino::Helpers::OutputHelpers
      include Padrino::Helpers::TagHelpers

      attr_reader :component, :props, :prerender

      # Renders react component from given arguments.
      #
      # @example
      #   React::Sinatra::Component.render('Hello', { name: 'namusyaka' }, prerender: true)
      #
      # @param [String] component The name for component must be able to be referred from asset javascript.
      # @param [Hash] props The props for rendering react-dom
      # @param [TrueClass, FalseClass] prerender Whether server side rendering is enabled or not.
      # @param [TrueClass, FalseClass] camelize_props Whether camelization is enabled or not.
      # @param [String, Symbol] tag The tag name for rendering react root element. Defaults to :div
      #
      # @raise [React::Sinatra::RuntimeError] Raised if server side rendering is enabled and failed
      # @return [ActiveSupport::SafeBuffer] safe string for rendering in application views
      def self.render(component, props, prerender: false, **options)
        new(component, prerender: prerender).render(props, **options)
      end

      # Camelizes props for enabling {camelize_props} option.
      #
      # @param [Hash] props The props for rendering react-dom
      # @return [Hash] camelized props
      def self.camelize_props(props)
        case props
        when Hash
          props.each_with_object({}) do |(key, value), new_props|
            new_key = key.to_s.camelize(:lower)
            new_value = camelize_props(value)
            new_props[new_key] = new_value
          end
        when Array
          props.map(&method(:camelize_props))
        else
          props
        end
      end

      # Constructs an instance of React::Sinatra::Component.
      #
      # @param [String] component The name for component must be able to be referred from asset javascript
      # @param [TrueClass, FalseClass] prerender Whether server side rendering is enabled or not.
      # @return [React::Sinatra::Component]
      def initialize(component, prerender: false, **options)
        @component = component
        @prerender = prerender
      end

      # Renders react component from given arguments and component.
      #
      # @param [Hash] props The props for rendering react-dom
      # @param [TrueClass, FalseClass] camelize_props Whether camelization is enabled or not
      # @param [String, Symbol] tag The tag name for rendering react root element. Defaults to :div
      # @see https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers/tag_helpers.rb#L119
      # @return [ActiveSupport::SafeBuffer] safe string for rendering in application views
      def render(props, camelize_props: false, tag: :div, **options, &block)
        props = self.class.camelize_props(props) if camelize_props
        block = -> {
          concat React::Sinatra::Pool.render(component, props.to_json)
        } if prerender?

        options.reverse_merge!(data: {})
        options[:data].tap do |data|
          data[:react_class] = component
          data[:react_props] = props.is_a?(String) ? props : props.to_json
        end unless prerender == :static

        content_tag(tag, '', options, &block)
      end

      # Returns true if the :prerender option is enabled.
      #
      # @return [TrueClass, FalseClass]
      def prerender?
        !! prerender
      end

      private :prerender?
    end
  end
end
