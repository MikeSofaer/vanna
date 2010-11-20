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
      CreationSuccess(:body => {:url => "/personas/#{persona[:name]}"})
    else
      CreationFailure(:body => {:message => "Could not create Persona."})
    end
  end

  html(
    "create" => lambda {|json_response|
      if json_response.status == 201
        Redirection :to => json_response.body[:url]
      else
        Redirection :to => "/personas/new"
      end
  })
end
