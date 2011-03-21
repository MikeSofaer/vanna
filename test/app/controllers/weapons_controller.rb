class WeaponsController < Vanna::Base
  def create(opts=params)
    weapon = Weapon.new(opts[:weapon])
    weapon[:id] = 1
    {:id => 1}
  end
end
