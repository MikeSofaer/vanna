require './test/test_helper'
require 'personas_controller'
require 'app/models/persona'
PersonasController.append_view_path "test/app/views"

class BasicTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ActionPresenter::Application
  end
  
  def setup
    Persona.clear
    @luis = {"name" => "The Fire Eater", "catchphrase" => "Hungry like the volcano!", "photo_url" => "example.com/img/fire_eater_photo", "partners" => ["Mystical Gondola"]}
    @giorgi = {"name" => "Mystical Gondola", "catchphrase" => "You're gonna get punted!", "photo_url" => "example.com/img/mystical_gondola_photo", "partners" => ["The Fire Eater"]}
    @miranda = {"name" => "Venus Raygun", "catchphrase" => "Hey, can you dodge lasers?", "photo_url" => "example.com/img/venus_raygun_photo", "partners" => []}
    Persona.create @luis
    Persona.create @giorgi
    Persona.create @miranda
  end

  def test_index_has_layout
    header "Accept", 'application/json'
    get "/personas"
	assert{ JSON(last_response.body).keys.sort == ["nav", "personas", "footer"].sort }
  end
  
  def test_index_lists_personas
    header "Accept", 'application/json'
    get "/personas"
    assert{ JSON(last_response.body)["personas"] == [@luis, @giorgi, @miranda]}
  end
  def test_show_lists_partner_catchphrases
    header "Accept", 'application/json'
    get "/personas/show?persona=The%20Fire%20Eater"
    assert{ JSON(last_response.body)["friend_catchphrases"] == ["You're gonna get punted!"] }
  end
  def test_friend_catchphrases_json_works
    header "Accept", 'application/json'
    get "/personas/friend_catchphrases?personas=Mystical%20Gondola"
    assert{ JSON(last_response.body) == ["You're gonna get punted!"] }
  end
  def test_html_has_sidebar
    get "/personas/show?persona=The%20Fire%20Eater"
    assert{last_response.body.match(/div id=sidebar/) != nil } 
  end
  def test_html_has_nav_content
    get "/personas"
    assert{ last_response.body.match(/Nav bar here/) }
  end
end
