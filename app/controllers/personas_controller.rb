class PersonasController < ApplicationController
  def index
    {:main => {"personas" => Persona.all}}
  end
  def show(opts = params)
    persona = Persona.named(opts["persona"]).first
    sidebar = friend_catchphrases("personas" => persona["partners"])
    {:main => {:persona =>persona, :sidebar => sidebar}}
  end
  def friend_catchphrases(opts=params)
    names = opts["personas"]
    Persona.named(names).map{|p| p["catchphrase"]}
  end
end
