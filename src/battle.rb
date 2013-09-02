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
    @battle_yml = Res::YML['../interface/battle.yml']
    @nametag_font = Res::Font[@battle_yml['nametag']['font']['name'], @battle_yml['nametag']['font']['size']]
    @player_health_bar_image = Media::get_image(@battle_yml['player']['health']['background_image'])
    @enemy_health_bar_image = Media::get_image(@battle_yml['enemy']['health']['background_image'])
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
      @player_health_bar_image.draw(@battle_yml['player']['health']['x'], @battle_yml['player']['health']['y'], 2)
      draw_square(@window, @battle_yml['player']['health']['x'] + 16, @battle_yml['player']['health']['y'] + 4, 1, (@player_health_bar_image.width - 32) * (@player.stats['health'].to_f() / Stats.get_max_health(@player.stats['vitality'])), @player_health_bar_image.height - 8, Gosu::Color.new(@battle_yml['player']['health']['color'].to_i(16)))
      # Player nametag
      @nametag_font.draw(@player.stats['name'], @battle_yml['player']['nametag']['x'], @battle_yml['player']['nametag']['y'], 1)
      # Player battle image
      @player.battle_image.draw(@battle_yml['player']['image']['x'], @battle_yml['player']['image']['y'], 2)
      # Enemy health bar
      @enemy_health_bar_image.draw(@battle_yml['enemy']['health']['x'], @battle_yml['enemy']['health']['y'], 2)
      draw_square(@window, @battle_yml['enemy']['health']['x'] + 16, @battle_yml['enemy']['health']['y'] + 4, 1, (@enemy_health_bar_image.width - 32) * (@enemy.stats['health'].to_f() / Stats.get_max_health(@enemy.stats['vitality'])), @enemy_health_bar_image.height - 8, Gosu::Color.new(@battle_yml['enemy']['health']['color'].to_i(16)))
      # Enemy nametag
      @nametag_font.draw(@enemy.stats['name'], @battle_yml['enemy']['nametag']['x'], @battle_yml['enemy']['nametag']['y'], 1)
      # Player battle image
      @enemy.battle_image.draw(@battle_yml['enemy']['image']['x'], @battle_yml['enemy']['image']['y'], 2)
    end
  end
end

