require 'forwardable'

module React
  module Sinatra
    # Class for expressing connection pool.
    #
    # @example
    #   pool = React::Sinatra::Pool.new
    #   pool.render('Hello', { name: 'bob' }, prerender: true)
    #   pool.reset
    #
    # @!visibility private
    class Pool
      # Utility for runtime renderer
      #
      # @see {#render}
      # @!visibility private
      def self.render(*args, **options)
        pool.render(*args, **options)
      end

      # Returns an instance of React::Sinatra::Pool as a singleton.
      #
      # @return [React::Sinatra::Pool]
      # @!visibility private
      def self.pool
        @pool ||= Pool.new
      end

      extend Forwardable
      instance_delegate %i[pool_size pool_timeout runtime] => 'React::Sinatra.config'

      # Detects runtime from pool, and its runtime
      # renders react component by using server side runtime.
      #
      # @see React::Sinatra::Runtime::RuntimeBased#render
      # @!visibility private
      def render(*args, **options)
        pool.with { |runtime| runtime.render(*args, **options) }
      end

      # Resets current connection pool.
      #
      # @!visibility private
      def reset
        @pool = nil
      end

      # Returns an instance of ConnectionPool.
      #
      # @see https://github.com/mperham/connection_pool
      # @return [Connectionpool]
      # @!visibility private
      def pool
        @pool ||= ConnectionPool.new(size: size, timeout: timeout) { runtime.new }
      end

      # Returns the globally set pool size or default pool size.
      #
      # @see React::Sinatra::Configuration#pool_size
      # @return [Integer]
      # @!visibility private
      def size
        pool_size || 5
      end

      # Returns the globally set pool timeout or default pool timeout.
      #
      # @see React::Sinatra::Configuration#pool_timeout
      # @return [Integer]
      # @!visibility private
      def timeout
        pool_timeout || 10
      end

      private :pool, :size, :timeout
    end
  end
end
