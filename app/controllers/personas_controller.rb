require './lib/presenter'
class PersonasController < Presenter
  def index
    layout_pieces.merge(
      {"main" => {"personas" => Persona.all}}
    )
  end

  def layout_pieces
    {"nav" => "Nav bar here", "footer" => "My page is so cool."}
  end
end

class Persona < Hash
@@all = nil
  def self.sample
    {:name => "louis", :catchphrase => "Don't look at me", :photo_url => "/dev/null"}
  end
  def self.all
    @@all ||= [sample]
  end
  def self.new(hash)
    Hash.new.merge(hash)
  end
  def self.create(hash)
    @@all ||= []
	@@all << new(hash)
  end
end
