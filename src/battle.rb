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


class Ability
  private_class_method :new
  
  # weapon:
  # title, desc, damage minimum, damage maximum, fire_damage, armor_pierce
  def self.from_weapon(weapon_data)
    return new(weapon_data)
  end
  
  # abilites:
  # attach a script
  def self.from_script(script_name)
    return new(:script => Abilities.const_get(script_name))
  end
  
  def initialize(vars={})
    @vars = vars
  end
  
  def is_script?()
    return @vars[:script] != nil
  end
  
  def title(*args) # The title is short-form for the ability's name
    if is_script?() then
      # It's an ability, return ability name
      return @vars[:script].title(*args)
    else
      # It's a weapon, return weapon name
      return @vars[:title]
    end
  end
  
  def full_name(*args) # The name is the full name for a weapon, and normally the same for a script aswell
    if is_script?() then
      # Check if it responds to full_name(), and if so, return that
      if @vars[:script].respond_to?(:full_name) then
        return @vars[:script].full_name(*args)
      else
        return @vars[:script].title(*args)
      end
    else
      # It's a weapon, therefore it has a full name
      return @vars[:full_name]
    end
  end
  
  def desc(*args)
    if is_script?() then
      # It's an ability, return ability description
      return @vars[:script].desc(*args)
    else
      # It's a weapon, return weapon description
      result = String.new(@vars[:desc])
      result << "\nDamage: <c=cc2828>#{@vars[:dam_min]}-#{@vars[:dam_max]}</c>"
      if @vars[:fire_dam] > 0 then
        result << "\nFire Damage: <c=ff7800>#{@vars[:fire_dam]}</c>"
      end
      if @vars[:armor_pierce] > 0 then
        result << "\nArmor Pierce: <c=800000>#{@vars[:armor_pierce]}</c>"
      end
      return result
    end
  end
end


class Battle < ControllerObject
  def initialize(window)
    super()
    @window = window
    @battle_yml = Res::YML['../interface/battle.yml']
    @box_manager = BoundingBoxManager.new()
    register_buttons()
    @current_boxes_under_mouse = Array.new()
    # Health bars
    @nametag_font = Res::Font[@battle_yml['nametag']['font']['name'], @battle_yml['nametag']['font']['size']]
    @player_health_bar_image = Media::get_image(@battle_yml['player']['health']['background_image'])
    @enemy_health_bar_image = Media::get_image(@battle_yml['enemy']['health']['background_image'])
    # Abilities
    @ability_font = Res::Font[@battle_yml['abilities']['font']['name'], @battle_yml['abilities']['font']['size']]
    @ability_desc_font = Res::Font[@battle_yml['abilities']['desc']['font']['name'], @battle_yml['abilities']['desc']['font']['size']]
    @player = nil
    @enemy = nil
  end
  
  def register_buttons()
    # Ability button 1
    @box_manager.register_image(@battle_yml['abilities']['button1']['x'],
                                @battle_yml['abilities']['button1']['y'],
                                Media::get_image(@battle_yml['abilities']['button_image']),
                                'ability_button1')
    # Ability button 2
    @box_manager.register_image(@battle_yml['abilities']['button2']['x'],
                                @battle_yml['abilities']['button2']['y'],
                                Media::get_image(@battle_yml['abilities']['button_image']),
                                'ability_button2')
    # Ability button 3
    @box_manager.register_image(@battle_yml['abilities']['button3']['x'],
                                @battle_yml['abilities']['button3']['y'],
                                Media::get_image(@battle_yml['abilities']['button_image']),
                                'ability_button3')
    # Ability button 4
    @box_manager.register_image(@battle_yml['abilities']['button4']['x'],
                                @battle_yml['abilities']['button4']['y'],
                                Media::get_image(@battle_yml['abilities']['button_image']),
                                'ability_button4')
  end
  
  def set_player(player)
    @player = player
  end
  
  def set_enemy(enemy)
    @enemy = enemy
  end
  
  def update()
    @current_boxes_under_mouse = @box_manager.hit_test_boxes(@window.relative_mouse_x, @window.relative_mouse_y)
  end
  
  def draw_box(box, z=2)
    if box.extra and @current_boxes_under_mouse.include?(id) then
      box.extra.draw(box.x, box.y, z)
    else
      box.image.draw(box.x, box.y, z)
    end
  end
  
  def draw()
    if @player != nil and @enemy != nil then # Show black screen until player & enemy are received
      #TEST REMOVE BELOW
      #Media::get_image('battle/land_background.png').draw(0, 0, 0)
      
      # Player health bar
      @player_health_bar_image.draw(@battle_yml['player']['health']['x'], @battle_yml['player']['health']['y'], 2)
      draw_square(@window, @battle_yml['player']['health']['x'] + 16, @battle_yml['player']['health']['y'] + 4, 1, (@player_health_bar_image.width - 32) * (@player.stats['health'].to_f() / Stats.get_max_health(@player.stats['vitality'])), @player_health_bar_image.height - 8, @battle_yml['player']['health']['color'].to_i(16))
      # Player nametag
      @nametag_font.draw(@player.stats['name'], @battle_yml['player']['nametag']['x'], @battle_yml['player']['nametag']['y'], 1)
      # Player battle image
      @player.battle_image.draw(@battle_yml['player']['image']['x'], @battle_yml['player']['image']['y'], 2)
      # Enemy health bar
      @enemy_health_bar_image.draw(@battle_yml['enemy']['health']['x'], @battle_yml['enemy']['health']['y'], 2)
      draw_square(@window, @battle_yml['enemy']['health']['x'] + 16, @battle_yml['enemy']['health']['y'] + 4, 1, (@enemy_health_bar_image.width - 32) * (@enemy.stats['health'].to_f() / Stats.get_max_health(@enemy.stats['vitality'])), @enemy_health_bar_image.height - 8, @battle_yml['enemy']['health']['color'].to_i(16))
      # Enemy nametag
      @nametag_font.draw(@enemy.stats['name'], @battle_yml['enemy']['nametag']['x'], @battle_yml['enemy']['nametag']['y'], 1)
      # Enemy battle image
      @enemy.battle_image.draw(@battle_yml['enemy']['image']['x'], @battle_yml['enemy']['image']['y'], 2)
      
      #Ability buttons
      # Ability 1
      box = @box_manager['ability_button1']
      draw_box(box)
      @ability_font.draw(@player.abilities[0].title(), box.x+((box.image.width()-@ability_font.text_width(@player.abilities[0].title()))/2.0), box.y+38, 2, 1, 1, @battle_yml['abilities']['font']['color'].to_i(16))
      # Ability 2
      box = @box_manager['ability_button2']
      draw_box(box)
      @ability_font.draw(@player.abilities[1].title(), box.x+((box.image.width()-@ability_font.text_width(@player.abilities[1].title()))/2.0), box.y+38, 2, 1, 1, @battle_yml['abilities']['font']['color'].to_i(16))
      # Ability 3
      box = @box_manager['ability_button3']
      draw_box(box)
      @ability_font.draw(@player.abilities[2].title(), box.x+((box.image.width()-@ability_font.text_width(@player.abilities[2].title()))/2.0), box.y+38, 2, 1, 1, @battle_yml['abilities']['font']['color'].to_i(16))
      # Ability 4
      box = @box_manager['ability_button4']
      draw_box(box)
      @ability_font.draw(@player.abilities[3].title(), box.x+((box.image.width()-@ability_font.text_width(@player.abilities[3].title()))/2.0), box.y+38, 2, 1, 1, @battle_yml['abilities']['font']['color'].to_i(16))
      
      # Ability description
      if id = @current_boxes_under_mouse.select(){|b| b.start_with?('ability')}[0] then
        box = @box_manager[id]
        ability = @player.abilities[id.split('button')[1].to_i()-1]
        # Description background
        
        Media::get_image(@battle_yml['abilities']['desc']['image']).draw(@battle_yml['abilities']['desc']['x'], @battle_yml['abilities']['desc']['y'], 2)
        # Ability full name
        @ability_desc_font.draw(ability.full_name(), @battle_yml['abilities']['desc']['x']+8, @battle_yml['abilities']['desc']['y']+8, 3)
        # Description (if weapon, this will include auto-generated stat information)
        @ability_desc_font.draw_with_linebreaks(ability.desc(@player, @enemy), @battle_yml['abilities']['desc']['x']+8, @battle_yml['abilities']['desc']['y']+32, 3, 1, 1, @battle_yml['abilities']['desc']['font']['color'].to_i(16))
      end
    end
  end
end

