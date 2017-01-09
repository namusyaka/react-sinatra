require 'react/sinatra/runtime/runtime_based'
require 'react/sinatra/error'
require 'execjs'

module React
  module Sinatra
    module Runtime
      # Class for rendering react component by using execjs
      #
      # @!visibility private
      class ExecJS < RuntimeBased
        register :execjs

        # Compiles shared context javascript code.
        #
        # @param [String] context The code of shared context
        # @return {#eval}
        # @!visibility private
        def compile(context)
          ::ExecJS.compile(context.force_encoding('utf-8'))
        end

        # Renders react component.
        # @param [String] code The code for rendering react component
        # @return [String] rendered react component as a string
        # @!visibility private
        def render!(code)
          @context.eval(code)
        end

        # Handles error class.
        # @raise Raised if given error is an instance of ExecJS::ProgramError.
        # @!visibility private
        def error_handle!(component, props, error)
          return unless error === ::ExecJS::ProgramError
          raise RuntimeError.new(component, props, message: error)
        end
      end
    end
  end
end
