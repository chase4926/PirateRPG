#!/usr/bin/env ruby
#battle.rb


module Stats
  def self.get_max_health(vitality)
    return vitality * 10
  end
  
  def self.get_crit_chance(precision)
    return 1.0/(((0.5 * (precision ** 2))/(0.000075 * (precision ** 3))) + 90) * 9000.0
  end
end


class Battle < ControllerObject
  def initialize(window)
    super()
    @window = window
    @battle_xml = '../interface/battle.xml'
    @nametag_font = Res::Font[Res::XML.text(@battle_xml, '//nametag/font/name'), Res::XML.int(@battle_xml, '//nametag/font/size')]
    @player_health_bar_image = Media::get_image(Res::XML.text(@battle_xml, '//player/health/background_image'))
    @enemy_health_bar_image = Media::get_image(Res::XML.text(@battle_xml, '//enemy/health/background_image'))
    @player = nil
    @enemy = nil
  end
  
  def set_player(player)
    @player = player
  end
  
  def set_enemy(enemy)
    @enemy = enemy
  end
  
  def draw()
    if @player != nil and @enemy != nil then # Show black screen until player & enemy are received
      # Player health bar
      @player_health_bar_image.draw(*Res::XML.xy(@battle_xml, '//player/health'), 2)
      draw_square(@window, Res::XML.int(@battle_xml, '//player/health/x') + 16, Res::XML.int(@battle_xml, '//player/health/y') + 4, 1, (@player_health_bar_image.width - 32) * (@player.stats['health'].to_f() / Stats.get_max_health(@player.stats['vitality'])), @player_health_bar_image.height - 8, Gosu::Color.new(Res::XML.text(@battle_xml, '//player/health/color').to_i(16)))
      # Player nametag
      @nametag_font.draw(@player.stats['name'], *Res::XML.xy(@battle_xml, '//player/nametag'), 1)
      # Player battle image
      @player.battle_image.draw(*Res::XML.xy(@battle_xml, '//player/image'), 2)
      # Enemy health bar
      @enemy_health_bar_image.draw(*Res::XML.xy(@battle_xml, '//enemy/health'), 2)
      draw_square(@window, Res::XML.int(@battle_xml, '//enemy/health/x') + 16, Res::XML.int(@battle_xml, '//enemy/health/y') + 4, 1, (@enemy_health_bar_image.width - 32) * (@enemy.stats['health'].to_f() / Stats.get_max_health(@enemy.stats['vitality'])), @enemy_health_bar_image.height - 8, Gosu::Color.new(Res::XML.text(@battle_xml, '//enemy/health/color').to_i(16)))
      # Enemy nametag
      @nametag_font.draw(@enemy.stats['name'], *Res::XML.xy(@battle_xml, '//enemy/nametag'), 1)
      # Player battle image
      @enemy.battle_image.draw(*Res::XML.xy(@battle_xml, '//enemy/image'), 2)
    end
  end
end

