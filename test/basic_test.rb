require "rack/test"
require './test/test_helper'
require 'json'
require 'wrong'
require 'wrong/adapters/test_unit'
require "wrong/message/string_diff"
Wrong.config[:color] = true


class BasicTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ActionPresenter::Application
  end

  def test_gets_json
    header "Accept", 'application/json'
    get "/"
    assert{ JSON(last_response.body) == {"text" => "hello"} }
  end
  def test_html_compiles_template
    get "/"
    assert{ last_response.body =~  /Handlebars.compile\("Here is some text: \{\{text\}\} "\);/ }
  end
  def test_html_provides_dictionary
    get "/"  
    assert{ last_response.body =~ /var dictionary = \{"text":"hello"\}/ }
  end
end

