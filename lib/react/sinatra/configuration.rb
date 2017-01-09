require 'react/sinatra/runtime'
require 'singleton'

module React
  module Sinatra
    class Configuration
      include Singleton

      attr_accessor :pool_size, :pool_timeout, :asset_path, :use_bundled_react, :env, :addon

      def runtime=(name)
        @runtime = Runtime[name.to_sym]
      end

      def runtime
        @runtime
      end
    end
  end
end
