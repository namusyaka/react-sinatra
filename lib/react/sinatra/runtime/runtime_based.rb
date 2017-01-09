require 'forwardable'
require 'active_support/core_ext/string/output_safety'
require 'react/sinatra/template'
require 'react/sinatra/error'
require 'react/sinatra'

module React
  module Sinatra
    module Runtime
      # Super class for runtimes that evaluate react rendering inside server-side.
      #
      # @!visibility private
      class RuntimeBased
        DEFAULT_RENDER_FUNCTION = 'renderToString'.freeze

        extend Forwardable
        def_delegator React::Sinatra::Template, :[], :t
        instance_delegate evaluate: React::Sinatra::Template
        instance_delegate %i[asset_path use_bundled_react env addon] => 'React::Sinatra.config'

        # Registers current class as a runtime.
        #
        # @param [String, Symbol] runtime The name of the runtime
        # @see React::Sinatra::Runtime.register
        # @!visibility private
        def self.register(runtime)
          Runtime.register runtime, self
        end

        # Constructs an instance of RuntimeBased.
        # 
        # @option options [String] :code The code for shared context
        # @return [React::Sinatra::Runtime::RuntimeBased]
        # @!visibility private
        def initialize(code: nil, **options)
          @context = compile(code || to_context)
        end

        # Renders react component from arguments inside server-side.
        #
        # @param [String, Symbol] component The name of react component
        # @param [Hash] props The props for rendering react-dom
        # @option options [String] :render_function The name of render_function, default to {DEFAULT_RENDER_FUNCTION}.
        # @return [ActiveSupport::SafeBuffer] rendered react component
        # @see #render!
        # @!visibility private
        def render(component, props, **options)
          code = to_runtime_code(component: component, props: props, **options)
          render!(code).html_safe
        rescue => error
          error_handle!(component, props, error)
          raise(error)
        end

        # @!visibility private
        def render!(code)
          raise NotImplementedError
        end

        # @!visibility private
        def compile(context)
          raise NotImplementedError
        end

        # @!visibility private
        def error_handle!(component, props, error)
          raise NotImplementedError
        end

        # @!visibility private
        def assets
          Dir.glob(asset_path).map(&File.method(:read)).join(?\n)
        end

        # @!visibility private
        def to_context
          ctx = []
          ctx << t(:polyfill) << t(:variables)
          if use_bundled_react
            prefix = "react-source/#{actual_env}#{'-with-addons' if addon}"
            ctx << t(:"#{prefix}/react") << t(:"#{prefix}/react-server")
          end
          ctx << assets
          ctx.join(?\n)
        end

        # @!visibility private
        def actual_env
          env.to_sym == :production ? env : :development
        end

        # @!visibility private
        def to_runtime_code(render_function: DEFAULT_RENDER_FUNCTION, **attrs)
          evaluate :runtime, render_function: render_function, **attrs
        end
      end
    end
  end
end
