require 'test-unit'
require 'mocha/setup'
require File.expand_path('../lib/react-sinatra', __dir__)
require File.expand_path('../lib/react/sinatra/runtime/runtime_based', __dir__)

def load_fixture(filename)
  ruby_code = File.read(File.expand_path("fixtures/#{filename}.txt", __dir__))
  eval(ruby_code)
end
