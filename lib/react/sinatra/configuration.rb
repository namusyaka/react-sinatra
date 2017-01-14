require 'react/sinatra/runtime'
require 'singleton'

module React
  module Sinatra
    # Class for expressing configuration delegated from classes.
    #
    # This #instance entrypoint is referred from application.
    class Configuration
      include Singleton

      attr_accessor :pool_size, :pool_timeout, :asset_path, :use_bundled_react, :env, :addon

      # Assigns runtime by given name.
      #
      # @param [String, Symbol] name The name of runtime
      # @see React::Sinatra::Runtime.[]
      # @return [React::Sinatra::Runtime::RuntimeBased]
      def runtime=(name)
        @runtime = Runtime[name.to_sym]
      end

      # Returns current runtime.
      # @return [React::Sinatra::Runtime::RuntimeBased]
      def runtime
        @runtime
      end

      # Assigns default values for use in server-side rendering.
      instance.pool_size    = 5
      instance.pool_timeout = 10
      instance.runtime      = :execjs

      instance.use_bundled_react = false
      instance.env = ENV['RACK_ENV'] || :development
      instance.addon = false
    end
  end
end
