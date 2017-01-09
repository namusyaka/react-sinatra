module React
  # Namespace for the react-sinatra library.
  #
  # This module is a Sinatra extension and is used with the `register` keyword.
  module Sinatra
    # Method for the `register` keyword hook on your application.
    # @param [Sinatra::Base] app
    def self.registered(app)
      app.helpers Helpers
    end

    # Configures react-sinatra by using {React::Sinatra::Configuration}.
    # @see [React::Sinatra::Configuration]
    # @yieldparam [React::Sinatra::Configuration]
    def self.configure
      yield config
    end

    # Returns configuration instance using Singleton module.
    # @see [React::Sinatra::Configuration]
    # @return [React::Sinatra::Configuration]
    def self.config
      Configuration.instance
    end
  end
end

require 'react/sinatra/version'
require 'react/sinatra/configuration'
require 'react/sinatra/helpers'
require 'react/sinatra/template'
require 'react/sinatra/runtime'
