require 'connection_pool'

module React
  module Sinatra
    # Module for lazy-loading any runtime.
    #
    # @!visibility private
    module Runtime
      @mutex ||= Mutex.new
      @runtimes ||= {}

      # Returns a runtime by given name.
      #
      # @example
      #   React::Sinatra::Runtime[:execjs] # => React::Sinatra::Runtime::ExecJS
      #
      # @param [String, Symbol] name a runtime identifier
      # @raise [ArgumentError] if the name is not supported
      # @return [Class, #new]
      # @!visibility private
      def self.[](name)
        name = name.to_s
        @runtimes.fetch(name) do
          @mutex.synchronize do
            error = try_require "react/sinatra/runtime/#{name}"
            @runtimes.fetch(name) do
              fail ArgumentError,
                "unsupported runtime %p #{ " (#{error.message})" if error }" % name
            end
          end
        end
      end

      # @return [LoadError, nil]
      # @!visibility private
      def self.try_require(path)
        require(path)
        nil
      rescue LoadError => error
        raise(error) unless error.path == path
        error
      end

      # @!visibility private
      def self.register(name, type)
        @runtimes[name.to_s] = type
      end
    end
  end
end
