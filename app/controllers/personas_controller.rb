require 'lib/presenter'
class PersonasController < Presenter
  def index
    layout_pieces.merge(
      {"main" => {"personas" => PersonasSerializer.full_list}}
    )
  end

  def layout_pieces
    {"nav" => "Nav bar here", "footer" => "My page is so cool."}
  end
end

class PersonasSerializer
  @@all = nil
  def self.full_list
    @@all || [Persona.sample]
  end
  def self.add(hash)
    @@all ||= []
    @@all << Persona.create(hash)
  end
end

class Persona < Hash
  def self.sample
    {:name => "louis", :catchphrase => "Don't look at me", :photo_url => "/dev/null"}
  end
  def self.create(hash)
    Hash.new.merge(hash)
  end
end
