#!/usr/bin/env ruby
#player.rb


class Player
  attr_reader :stats, :battle_image
  def initialize()
    @stats = {'name'=> 'You', 'vitality' => 5, 'precision' => 1, 'power' => 1, 'armor' => 1, 'health' => 50}
    @battle_image = Media::get_image('placeholder.png')
  end
end

