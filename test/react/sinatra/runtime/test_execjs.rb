require 'test_helper'

class TestExecJS < Test::Unit::TestCase
  setup do
    react_server_source = File.read(File.expand_path('../../../../../lib/react/sinatra/templates/react-source/production/react-server.js', __FILE__))
    todo_component_source = File.read(File.expand_path('../../../../fixtures/components/PlainJSTodo.js', __FILE__))
    code = react_server_source + todo_component_source
    @runtime = React::Sinatra::Runtime[:execjs].new(code: code)
  end

  sub_test_case '#render' do
    test 'assert to return HTML' do
      result = @runtime.render('Todo', {todo: 'write tests'}.to_json, {})
      assert_match(/<li.*write tests<\/li>/, result)
      assert_match(/data-react-checksum/, result)
    end

    test 'assert to accept the :render_function option' do
      result = @runtime.render('Todo', {todo: 'write more tests'}.to_json, render_function: 'renderToStaticMarkup')
      assert_match(/<li>write more tests<\/li>/, result)
      assert_no_match(/data-react-checksum/, result)
    end
  end
end
