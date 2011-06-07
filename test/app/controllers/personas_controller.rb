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
      Response.new(:status => 201, :body => {:url => "/personas/#{persona[:name]}"})
    else
      Response.new(:status => 422, :body => {:message => "Could not create Persona."})
    end
  end
  
  def edit(opts=params)
    persona = Persona.all[ opts[:id].to_i ]
    {:persona => persona}
  end
    
  post_process :html do
    def post_create(json_response)
      if json_response.status == 201
        Response.new(:status => 302, :location => json_response[:url])
      else
        Response.new(:status => 302, :location => root_path)
      end
    end
  end
end

=begin

You can also do this:

class PersonasHTMLController < ApplicationController::Base
  def create
    response = PersonasController.new.create(params)
    if response.status == 201
      redirect_to response.body[:url]
    else
      redirect_to "/personas/new"
    end
  end
end

=end
