class WeaponsController < Vanna::Base
  def create(opts=params)
    weapon = Weapon.new(opts[:weapon])
    weapon[:id] = 1
    {:id => 1}
  end
  def update(opts=params)
    weapon = Weapon.new(opts[:weapon])  #Yeah, it's not really updating...
  end
  redirect_on :update, :to => :index
end
