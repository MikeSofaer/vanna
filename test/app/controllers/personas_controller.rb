class PersonasController < ApplicationController
  def index
    {:personas => Persona.all}
  end
  
  def show(opts = params)
    persona = Persona.named(opts[:persona]).first
    friend_catchphrases = friend_catchphrases(:personas => persona[:partners])
    {:persona =>persona, :friend_catchphrases => friend_catchphrases}
  end

  def friend_catchphrases(opts=params)
    names = opts[:personas]
    Persona.named(names).map{|p| p[:catchphrase]}
  end

  def create(opts=params)
    persona = Persona.build(opts[:persona])
    if persona.save
      CreationSuccess(:redirect_to => "/personas/#{persona[:name]}")
    else
      CreationFailure(:redirect_to => "/personas/new")
    end
  end
end
