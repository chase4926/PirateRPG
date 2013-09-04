#!/usr/bin/env ruby
#enemy.rb


class Enemy
  attr_accessor :stats, :battle_image
  def initialize()
    @stats = {'name'=> 'Captain Lechuck', 'vitality' => 5, 'precision' => 1, 'power' => 1, 'armor' => 1, 'health' => 50}
    @battle_image = Media::get_image('placeholder.png')
  end
end

