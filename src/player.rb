#!/usr/bin/env ruby
#player.rb


class Player < Battler
  attr_reader :battle_image
  def initialize()
    super()
    @stats = {'name'=> 'You', 'vitality' => 5, 'precision' => 5, 'power' => 5, 'armor' => 0, 'health' => 50}
    @battle_image = Media::get_image('placeholder.png')
    
    # TESTING ONLY BELOW
    @abilities[0] = Ability.from_weapon(:title => 'Dagger', :full_name => 'Old Rusty Dagger', :desc => 'An old, rusty dagger.', :dam_min => 8, :dam_max => 10, :fire_dam => 0, :fire_len => 0, :armor_pierce => 2)
    @abilities[1] = Ability.from_weapon(:title => 'Flamelance', :full_name => 'Cheap Flamelance', :desc => 'Kind of like a firesword.', :dam_min => 2, :dam_max => 3, :fire_dam => 2, :fire_len => 2, :armor_pierce => 0)
    @abilities[2] = Ability.from_script('Heal')
    @abilities[3] = Ability.from_script('Strike')
  end
end

