require 'lib/action_presenter'
class WelcomeController < ApplicationPresenter

def index
  respond_with :text => "hello"
end

end
