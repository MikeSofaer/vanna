class PersonasController < ApplicationPresenter
  def index
    {:main => {"personas" => Persona.all, :sidebar => sidebar}}
  end
  def sidebar
    Persona.all.map{|p| p[:catchphrase]}
  end
end
