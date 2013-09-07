#!/usr/bin/env ruby
#enemy.rb


class Enemy < Battler
  attr_reader :battle_image
  def initialize()
    super()
    @stats = {'name'=> 'Captain Lechuck', 'vitality' => 6, 'precision' => 5, 'power' => 8, 'armor' => 0, 'health' => 60}
    @battle_image = Media::get_image('placeholder.png')
    
    # TESTING ONLY BELOW
    @abilities << Ability.from_script('Default_Enemy')
  end
end

