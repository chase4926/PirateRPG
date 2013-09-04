#!/usr/bin/env ruby
#player.rb


class Player
  attr_accessor :stats, :battle_image
  def initialize()
    @stats = {'name'=> 'You', 'vitality' => 5, 'precision' => 1, 'power' => 1, 'armor' => 1, 'health' => 50}
    @battle_image = Media::get_image('placeholder.png')
    
    @ability_1 = Ability.from_weapon(:title => 'Rusty Dagger', :desc => 'A description would go here', :dam_min => 8, :dam_max => 10, :fire_dam => 0, :armor_pierce => 0)
    @ability_2 = Ability.from_weapon(:title => 'Cheap Flamelance', :desc => 'A description would go here', :dam_min => 2, :dam_max => 3, :fire_dam => 2, :armor_pierce => 0)
    @ability_3 = Ability.from_script('Heal')
    @ability_4 = Ability.from_script('Strike')
  end
end

