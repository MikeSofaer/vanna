class Persona < Hash
@@all = nil
  def self.sample
    {"name" => "Mark", "catchphrase" => "Don't look at me", "photo_url" => "/dev/null", "team_members" => []}
  end
  def self.all
    @@all || [sample]
  end
  def self.new(hash)
    Hash.new.merge(hash)
  end
  def self.create(hash)
    @@all ||= []
	@@all << new(hash)
  end
  def self.clear
    @@all = nil
  end
  def self.named(names)
    names = [names] unless names.is_a?(Array)
    all.select{|p| names.member? p["name"]}
  end
end
