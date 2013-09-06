#!/usr/bin/env ruby
#enemy.rb


class Enemy < Battler
  attr_reader :battle_image
  def initialize()
    super()
    @stats = {'name'=> 'Captain Lechuck', 'vitality' => 5, 'precision' => 5, 'power' => 5, 'armor' => 0, 'health' => 50}
    @battle_image = Media::get_image('placeholder.png')
    
    # TESTING ONLY BELOW
    @abilities << Ability.from_script('Default_Enemy')
  end
end

