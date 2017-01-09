require 'test_helper'

class TestTemplate < Test::Unit::TestCase
  sub_test_case '.[]' do
    test 'assert to fetch template as a text by given signature' do
      assert { React::Sinatra::Template[:runtime].kind_of?(String) }
      assert { React::Sinatra::Template[:polyfill].kind_of?(String) }
      assert { React::Sinatra::Template[:variables].kind_of?(String) }
    end
  end

  sub_test_case '.evaluate' do
    data(
      'default' => [
        'ReactDOMServer.renderToString(React.createElement(Hello, {}))',
        { render_function: 'renderToString', component: 'Hello', props: {}.to_json }
      ],
      'cutomized' => [
        'ReactDOMServer.customRender(React.createElement(Comment, {"a":123}))',
        { render_function: 'customRender', component: 'Comment', props: { "a": 123 }.to_json }
      ]
    )
    test 'assert to fetch template and evaluate it' do |data|
      expected, attrs = data
      assert { React::Sinatra::Template.evaluate(:runtime, **attrs).include?(expected) }
    end
  end
end
