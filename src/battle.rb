#!/usr/bin/env ruby
#battle.rb


class Battler
  attr_accessor :stats
  attr_reader :abilities
  def initialize()
    @stats = {'name'=> '', 'vitality' => 1, 'precision' => 0, 'power' => 0, 'armor' => 0, 'health' => 10}
    @abilities = Array.new() #Array to hold abilities
  end
  
  def [](key)
    return @stats[key]
  end
  
  def []=(key, value)
    @stats[key] = value
  end
  
  def hurt(amount)
    if self['health'] - amount <= 0 then
      self['health'] = 0
    else
      self['health'] -= amount
    end
  end
end


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
      result << "\nDamage: <c=ff4d4d>#{@vars[:dam_min]}-#{@vars[:dam_max]}</c>"
      if @vars[:fire_dam] > 0 then
        result << "\nFire Damage: <c=ff7800>#{@vars[:fire_dam]}</c>"
      end
      if @vars[:armor_pierce] > 0 then
        result << "\nArmor Pierce: <c=800000>#{@vars[:armor_pierce]}</c>"
      end
      return result
    end
  end
  
  def use(player, enemy)
    if is_script?() then
      # It's an ability, just use the script provided
      @vars[:script].script(player, enemy)
    else
      # It's a weapon
      damage = @vars[:dam_min] + rand(@vars[:dam_max] - @vars[:dam_min] + 1)
      armor = enemy['armor'] - @vars[:armor_pierce] <= 0 ? 0 : enemy['armor'] - @vars[:armor_pierce]
      
      if Stats.get_crit_chance(player['precision']) >= ((rand(1001) + 1) / 10.0) then
        damage *= 2
      end
      # FIXME: Add fire damage system
      enemy.hurt(damage - armor <= 0 ? 0 : damage - armor)
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
  
  def take_turn(ability)
    # FOR TESTING ONLY
    # Player turn
    ability.use(@player, @enemy)
    # Enemy turn
    @enemy.abilities[rand(@enemy.abilities.count())].use(@player, @enemy)
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
      draw_square(@window, @battle_yml['player']['health']['x'] + 16, @battle_yml['player']['health']['y'] + 4, 1, (@player_health_bar_image.width - 32) * (@player['health'].to_f() / Stats.get_max_health(@player['vitality'])), @player_health_bar_image.height - 8, @battle_yml['player']['health']['color'].to_i(16))
      # Player nametag
      @nametag_font.draw(@player['name'], @battle_yml['player']['nametag']['x'], @battle_yml['player']['nametag']['y'], 1)
      # Player battle image
      @player.battle_image.draw(@battle_yml['player']['image']['x'], @battle_yml['player']['image']['y'], 2)
      # Enemy health bar
      @enemy_health_bar_image.draw(@battle_yml['enemy']['health']['x'], @battle_yml['enemy']['health']['y'], 2)
      draw_square(@window, @battle_yml['enemy']['health']['x'] + 16, @battle_yml['enemy']['health']['y'] + 4, 1, (@enemy_health_bar_image.width - 32) * (@enemy['health'].to_f() / Stats.get_max_health(@enemy['vitality'])), @enemy_health_bar_image.height - 8, @battle_yml['enemy']['health']['color'].to_i(16))
      # Enemy nametag
      @nametag_font.draw(@enemy['name'], @battle_yml['enemy']['nametag']['x'], @battle_yml['enemy']['nametag']['y'], 1)
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
  
  def button_press_over_id(id, button_id)
    case button_id
      when Gosu::Button::MsLeft
        if @player != nil and @enemy != nil then
          case id
            when 'ability_button1'
              take_turn(@player.abilities[0])
            when 'ability_button2'
              take_turn(@player.abilities[1])
            when 'ability_button3'
              take_turn(@player.abilities[2])
            when 'ability_button4'
              take_turn(@player.abilities[3])
          end
        end
    end
  end
  
  def button_down(id)
    @current_boxes_under_mouse.each do |box_id|
      button_press_over_id(box_id, id)
    end
  end
end

