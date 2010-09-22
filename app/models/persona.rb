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
  def self.clear
    @@all = nil
  end
end
