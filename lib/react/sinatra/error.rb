module React
  module Sinatra
    class RuntimeError < ::RuntimeError
      def initialize(component, props, message:, **options)
        message = ["Encountered error \"#{message}\" when prerendering #{component} with #{props}",
          message.backtrace.join(?\n)].join(?\n)
        super(message)
      end
    end
  end
end
