require 'react/sinatra/component'

module React
  module Sinatra
    # Module for registering Sinatra application.
    #
    # This is main entrypoint for integration on Sinatra.
    module Helpers
      # Renders react component from given arguments.
      #
      # @see {React::Sinatra::Component.render}
      # @return [ActiveSupport::SafeBuffer] safe string for rendering in application views
      def react_component(*args)
        React::Sinatra::Component.render(*args)
      end
    end
  end
end
