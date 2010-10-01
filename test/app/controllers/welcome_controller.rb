require './lib/vanna'
class WelcomeController < ActionController::Metal
  include Vanna
  def index
    {:text => "hello"}
  end
  def create
    Redirection.new({}, "/redirection_target")
  end
end
