class PersonasController < ApplicationRevealer
  def index
    {"main" => {"personas" => Persona.all}}
  end
end
