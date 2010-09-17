require 'lib/presenter'
class WelcomeController < Presenter
  def index
    {:text => "hello"}    
  end
end
