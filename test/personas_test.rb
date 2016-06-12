require './test/test_helper'
require 'personas_controller'
require 'app/models/persona'
PersonasController.append_view_path "test/app/views"

class PersonasTest < Test::Unit::TestCase
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

    @linda_params = {:persona =>
      {:name => "Empress Beluga",:catchphrase => "Let's have a WHALE of a time!"}}
    @bad_params = {:persona => {:catchphrase => "Say my name!"}}
  end

  def test_html_index_has_layout_template
    get "/personas"
    assert ( last_response.body =~ /<title>Vanna Test/)
  end

  def test_html_index_renders_layout_data_content
    get "/personas"
    assert ( last_response.body =~/Nav bar here/)
  end

  def test_json_index_has_no_layout
    header "Accept", 'application/json'
    get "/personas"
    assert ( JSON(last_response.body).keys.sort == ["personas"])
  end

  def test_data_only_json_method
    header "Accept", 'application/json'
    get "/personas/friend_catchphrases?personas=Mystical%20Gondola"
    assert ( JSON(last_response.body) == ["You're gonna get punted!"] )
  end

  def test_data_only_method_does_not_render_html
    get "/personas/friend_catchphrases?personas=Mystical%20Gondola"
    assert (last_response.body =~ /Vanna::InvalidDictionary/)
  end

  def test_controller_can_call_other_controller_methods
    header "Accept", 'application/json'
    get "/personas/show?persona=The%20Fire%20Eater"
    assert ( JSON(last_response.body)["friend_catchphrases"] == ["You're gonna get punted!"] )
  end

  def test_show_template_is_rendered
    get "/personas/show?persona=The%20Fire%20Eater"
    assert (last_response.body =~/div id=sidebar/)
  end

  def test_html_redirects_on_post_success
    post "/personas/create", @linda_params
    assert ( last_response.status == 302 )
    assert ( last_response.location == "/personas/#{@linda_params[:persona][:name]}")
  end
  def test_json_renders_on_post_success
    header "Accept", 'application/json'
    post "/personas/create", @linda_params
    assert ( last_response.status == 201 )
    assert ( JSON(last_response.body) == {"url" => "/personas/#{@linda_params[:persona][:name]}"})
  end

  def test_html_redirects_on_post_failure
    post "/personas/create", @bad_params
    assert ( last_response.status == 302 )
    assert ( last_response.location == "/")
  end
  def test_json_rejects_on_post_failure
    header "Accept", 'application/json'
    post "/personas/create", @bad_params
    assert ( last_response.status == 422 )
    assert ( JSON(last_response.body) == {"message" => "Could not create Persona."})
  end

  def test_js_tag_renders
    get "/personas"
    assert (last_response.body =~ /javascript/)
  end
  def test_css_tag_renders
    get "/personas"

    assert last_response.status != 500 , "should not fail"
    assert last_response.body =~ /stylesheets/, "does not contain stylesheets:\n" + last_response.body
  end
end
