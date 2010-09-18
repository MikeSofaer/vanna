require './lib/presenter'
class PersonasController < ApplicationPresenter
  def index
    {"main" => {"personas" => Persona.all}}
  end
end