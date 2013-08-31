#!/usr/bin/env ruby
#battle.rb


class Battle < ControllerObject
  def initialize(window)
    super()
    @window = window
    @battle_xml = '../interface/battle.xml'
    @player_health_bar_image = Media::get_image(Res::XML.text(@battle_xml, '//player/health/background_image'))
    @enemy_health_bar_image = Media::get_image(Res::XML.text(@battle_xml, '//enemy/health/background_image'))
  end
  
  def draw()
    health = 100 # Temporary, placeholder for player and enemy health
    # Player health bar
    @player_health_bar_image.draw(*Res::XML.xy(@battle_xml, '//player/health'), 2)
    draw_square(@window, Res::XML.int(@battle_xml, '//player/health/x') + 16, Res::XML.int(@battle_xml, '//player/health/y') + 4, 1, (@player_health_bar_image.width - 32) * (health / 100.0), @player_health_bar_image.height - 8, Gosu::Color.new(Res::XML.text(@battle_xml, '//player/health/color').to_i(16)))
    # Enemy health bar
    @enemy_health_bar_image.draw(*Res::XML.xy(@battle_xml, '//enemy/health'), 2)
    draw_square(@window, Res::XML.int(@battle_xml, '//enemy/health/x') + 16, Res::XML.int(@battle_xml, '//enemy/health/y') + 4, 1, (@enemy_health_bar_image.width - 32) * (health / 100.0), @enemy_health_bar_image.height - 8, Gosu::Color.new(Res::XML.text(@battle_xml, '//enemy/health/color').to_i(16)))
  end
end

