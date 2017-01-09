require 'test_helper'

class TestComponent < Test::Unit::TestCase
  test 'assert to respond to padrino helpers' do
    assert { React::Sinatra::Component.included_modules.include?(Padrino::Helpers::TagHelpers) }
    assert { React::Sinatra::Component.included_modules.include?(Padrino::Helpers::OutputHelpers) }
  end

  sub_test_case '.camelize_props' do
    data(
      'port from react-rails' => [
        load_fixture('camelize_props/expected'),
        load_fixture('camelize_props/raw')
      ]
    )
    test 'assert to camelize props correctly' do |data|
      expected, raw_props = data
      assert { expected == React::Sinatra::Component.camelize_props(raw_props) }
    end
  end

  sub_test_case '.render' do
    sub_test_case 'without :prerender option' do
      setup { React::Sinatra::Pool.any_instance.expects(:render).once }
      test 'assert to execute runtime for server side rendering' do
        React::Sinatra::Component.render('Hello', {}, prerender: true)
      end
    end

    sub_test_case 'without :prerender option' do
      test 'assert to execute runtime for server side rendering' do
        expected = "<div data-react-class=\"Hello\" data-react-props=\"{}\"></div>"
        actual = React::Sinatra::Component.render('Hello', {})
        assert { expected == actual }
      end
    end
  end
end
