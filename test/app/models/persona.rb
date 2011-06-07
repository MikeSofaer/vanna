class Persona < Hash
  @all = nil
  def self.sample
    {"name" => "Mark", "catchphrase" => "Don't look at me", "photo_url" => "/dev/null", "team_members" => []}
  end
  def self.all
    @all || [sample]
  end
  def self.build(hash)
    new.merge(hash.symbolize_keys)
  end
  def self.create(hash)
    @all ||= []
	  @all << build(hash)
    hash
  end
  def self.clear
    @all = nil
  end
  
  def id
    self.class.all.index(self)
  end
  
  def self.named(names)
    names = [names] unless names.is_a?(Array)
    all.select{|p| names.member? p[:name]}
  end

  def save
    return false unless key? :name
    self.class.all << self
  end
end
