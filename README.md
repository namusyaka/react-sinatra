# react-sinatra

[![Build Status](https://travis-ci.org/namusyaka/react-sinatra.svg?branch=master)](https://travis-ci.org/namusyaka/react-sinatra)
[![Dependency Status](https://gemnasium.com/badges/github.com/namusyaka/react-sinatra.svg)](https://gemnasium.com/github.com/namusyaka/react-sinatra)
[![Gem Version](https://badge.fury.io/rb/react-sinatra.svg)](https://badge.fury.io/rb/react-sinatra)
[![GitHub issues](https://img.shields.io/github/issues/namusyaka/react-sinatra.svg)](https://github.com/namusyaka/react-sinatra/issues)
[![GitHub license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://raw.githubusercontent.com/namusyaka/react-sinatra/master/LICENSE.txt)

`react-sinatra` makes it easy to use React in your Sinatra and Padrino application.

Please see [a sample](https://github.com/namusyaka/react-sinatra-sample).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'react-sinatra'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install react-sinatra

## Anti-Features

`react-sinatra` does not:

- transform `.jsx` files or JSX syntax.
- transpile asset using babel.
- support asset-pipeline.
- have generator for registering this extension.

I think those features should be solved by using [webpack](https://webpack.github.io/), or other build tools.

## Usage

### Sinatra Plug-in

It's easy to register `react-sinatra` in your application, next section will describe three steps for introduction.

#### 1. Add react-sinatra and runtime into your Gemfile

```ruby
source 'https://rubygems.org'

gem 'react-sinatra'
gem 'execjs'
gem 'mini_racer' # also `therubyracer` may be available, but mini_racer is simpler and faster.
```

#### 2. Register react-sinatra and configure.

```ruby
class App < Sinatra::Base
  register React::Sinatra

  configure do
    React::Sinatra.configure do |config|
      # configures for bundled React.js
      config.use_bundled_react = true
      config.env = ENV['RACK_ENV'] || :development
      config.addon = true

      # The asset should be able to be compiled by your server side runtime.
      # react-sinatra does not transform jsx into js, also ES2015 may not be worked through.
      config.asset_path = File.join('client', 'dist', 'server.js')
      config.runtime = :execjs
    end
  end
end
```

#### 3. Use `react_component` on your view or sinatra application.

```erb
<%= react_component('Hello', { name: 'namusyaka' }, prerender: true) %>
```

```ruby
get '/:name' do |name|
  component = react_component('Hello', { name: name }, prerender: true)
  # ...
end
```

The react component **must** be able to be referred from global scope, so you should be careful for your asset javascript.
In the above example, you need to provide an asset that puts the component called `Hello` in a state that it can be referred to from the global.

```javascript
class Hello extends React.Component {
  render() {
    return (
      <div className="hello">
        Hello, {this.props.name}!
      </div>
    );
  }
}

global.Hello = Hello;
```

### React.js

#### Bundled React.js

You can use bundled React.js by specifying configurations.

```ruby
React::Sinatra.configure do |config|
  config.use_bundled_react = true # Defaults to false
end
```

You can also specify `addon` and `env` for each environments.

```ruby
React::Sinatra.configure do |config|
  config.addon = false # Defaults to false
  config.env = ENV['RACK_ENV'] || :development
end
```

#### Note

**If you want to use your own react, you must include React.js and react-server source code in the asset.**

```ruby
React::Sinatra.configure do |config|
  config.asset_path = 'client/dist/*.js'
end
```

### TODO

- Support nodejs as a runtime

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/namusyaka/react-sinatra.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

