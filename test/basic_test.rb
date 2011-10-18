require './test/test_helper'
require 'welcome_controller'
require 'pp' #


WelcomeController.append_view_path "test/app/views"

class BasicTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ActionPresenter::Application
  end

  def test_gets_json
    header "Accept", 'application/json'
    get "/"
    x = JSON(last_response.body)
    y = {"text" => "hello"}
    print "from response got:" +PP.pp(x, "")  + " expected :" + PP.pp(y, "") + "\n"
    assert  (x == y)
  end
  def test_html_renders_template
    get "/"
    assert (last_response.body =~  /Here is some text: hello/ )
  end
end

