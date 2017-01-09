# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'react/sinatra/version'

Gem::Specification.new do |spec|
  spec.name          = "react-sinatra"
  spec.version       = React::Sinatra::VERSION
  spec.authors       = ["namusyaka"]
  spec.email         = ["namusyaka@gmail.com"]

  spec.summary       = %q{React on Sinatra Integration}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/namusyaka/react-sinatra'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'connection_pool'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'padrino-helpers'
end
