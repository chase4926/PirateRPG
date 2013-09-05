#!/usr/bin/env ruby
#player.rb


class Player
  attr_accessor :stats, :battle_image
  attr_reader :abilities
  def initialize()
    @stats = {'name'=> 'You', 'vitality' => 5, 'precision' => 1, 'power' => 1, 'armor' => 1, 'health' => 50}
    @battle_image = Media::get_image('placeholder.png')
    
    @abilities = Array.new(4) #Array to hold player's abilities
    
    @abilities[0] = Ability.from_weapon(:title => 'Dagger', :full_name => 'Old Rusty Dagger', :desc => 'An old, rusty dagger.', :dam_min => 8, :dam_max => 10, :fire_dam => 0, :armor_pierce => 1)
    @abilities[1] = Ability.from_weapon(:title => 'Flamelance', :full_name => 'Cheap Flamelance', :desc => 'Kind of like a firesword.', :dam_min => 2, :dam_max => 3, :fire_dam => 2, :armor_pierce => 0)
    @abilities[2] = Ability.from_script('Heal')
    @abilities[3] = Ability.from_script('Strike')
  end
end

