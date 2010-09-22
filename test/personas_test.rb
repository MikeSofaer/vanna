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
  
  def setup
    Persona.clear
    @luis = {:name => "The Fire Eater", :catchphrase => "Hungry like the volcano!", :photo_url => "example.com/img/fire_eater_photo"}
    @giorgi = {:name => "Mystical Gondola", :catchphrase => "You're gonna get punted!", :photo_url => "example.com/img/mystical_gondola_photo"}
    Persona.create @luis
    Persona.create @giorgi
  end

  def test_index_has_layout
    header "Accept", 'application/json'
    get "/personas"
	assert{ JSON(last_response.body).keys.sort == ["nav", "main", "footer"].sort }
  end
  
  def test_index_lists_personas
    header "Accept", 'application/json'
    get "/personas"
    assert{ JSON(last_response.body)["main"]["personas"].first == {"name"=> "The Fire Eater", "catchphrase"=> "Hungry like the volcano!", "photo_url"=> "example.com/img/fire_eater_photo"}
}
  end
  def test_index_lists_catchphrases
    header "Accept", 'application/json'
    get "/personas"
    assert{ JSON(last_response.body)["main"]["sidebar"] == ["Hungry like the volcano!", "You're gonna get punted!"] }
  end
  def test_sidebar_method_works
    header "Accept", 'application/json'
    get "/personas/sidebar"
    assert{ JSON(last_response.body) == ["Hungry like the volcano!", "You're gonna get punted!"] }
  end
  def test_html_has_sidebar
    get "/personas"
    assert{last_response.body.match(/div id=sidebar/) != nil } 
  end
  def test_html_has_nav_content
    get "/personas"
    assert{ last_response.body.match(/Nav bar here/) }
  end
end
