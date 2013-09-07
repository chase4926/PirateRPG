#!/usr/bin/env ruby
#battle.rb


# Where all of the formulas regarding stats go,
# these should each also have a conveinance method in Battler
module Stats
  def self.get_max_health(vitality)
    return vitality * 10
  end
  
  def self.get_crit_chance(precision)
    return 1.0/(((0.5 * (precision ** 2))/(0.000075 * (precision ** 3))) + 90) * 9000.0
  end
end


class Battler
  attr_accessor :stats
  attr_reader :abilities
  def initialize()
    @stats = {'name'=> '', 'vitality' => 1, 'precision' => 0, 'power' => 0, 'armor' => 0, 'health' => 10}
    @abilities = Array.new() #Array to hold abilities
    @dots = {:fire => []} # Damage Over Time
  end
  
  def pass_turn()
    # Apply fire damage
    if !@dots[:fire].empty?() then
      hurt(get_dot(:fire)[0])
    end
    # Lower the length for all
    @dots.each_value() do |value|
      value.each() do |item|
        item[1] -= 1
      end
    end
    # Clear out all expired
    @dots.each_value() do |item|
      item.delete_if() {|i| i[1] <= 0}
    end
  end
  
  def get_dot(key)
    # Returns highest length and highest damage
    if @dots[key].empty?() then
      return 0, 0
    else
      return (Array.new(@dots[key]).sort_by!(){|i| i[0]})[0][0], (Array.new(@dots[key]).sort_by!(){|i| i[1]})[0][1]
    end
  end
  
  def add_dot(key, damage, length)
    if @dots[key] then
      @dots[key] << [damage, length]
    else
      @dots[key] = [[damage, length]]
    end
  end
  
  def hurt(amount)
    if self['health'] - amount <= 0 then
      self['health'] = 0
    else
      self['health'] -= amount
    end
  end
  
  def heal(amount)
    if self['health'] + amount >= get_max_health() then
      self['health'] = get_max_health()
    else
      self['health'] += amount
    end
  end
  
  # Conveinance methods
  def [](key)
    return @stats[key]
  end
  
  def []=(key, value)
    @stats[key] = value
  end
  
  def get_max_health()
    return Stats.get_max_health(self['vitality'])
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
  
  def desc(player, enemy)
    if is_script?() then
      # It's an ability, return ability description
      return @vars[:script].desc(player, enemy)
    else
      # It's a weapon, return weapon description
      result = String.new(@vars[:desc])
      result << "\nDamage: <c=ff4d4d>#{@vars[:dam_min]}-#{@vars[:dam_max]} (#{@vars[:dam_min] + player['power']}-#{@vars[:dam_max] + player['power']})</c>"
      if @vars[:fire_dam] > 0 then
        result << "\nFire Damage: <c=ff7800>#{@vars[:fire_dam]}</c>"
      end
      if @vars[:armor_pierce] > 0 then
        result << "\nArmor Pierce: <c=b0b0b0>#{@vars[:armor_pierce]}</c>"
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
      # Power implementation
      damage += player['power']
      # Precision implementation
      if Stats.get_crit_chance(player['precision']) >= ((rand(1001) + 1) / 10.0) then
        damage *= 2
      end
      # Fire implementation
      if @vars[:fire_len] >= 1 then
        enemy.add_dot(:fire, @vars[:fire_dam], @vars[:fire_len])
      end
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
    # Turns
    @current_turn = 'player'
    @turn_timer = 0
    # Health bars
    @nametag_font = Res::Font[@battle_yml['nametag']['font']['name'], @battle_yml['nametag']['font']['size']]
    @health_font = Res::Font[@battle_yml['healthbar']['font']['name'], @battle_yml['healthbar']['font']['size']]
    @health_bar_image = Media::get_image(@battle_yml['healthbar']['background_image'])
    # Status indicators
    @status_font = Res::Font[@battle_yml['status_indicator']['font']['name'], @battle_yml['status_indicator']['font']['size']]
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
    
    if @current_turn == 'player' then
      @turn_timer += 1 if @turn_timer > 0
      if @turn_timer > 60 then
        @current_turn = 'enemy'
        @turn_timer = 0
        take_enemy_turn()
      end
    else
      @turn_timer += 1
      if @turn_timer > 60 then
        @current_turn = 'player'
        @turn_timer = 0
      end
    end
  end
  
  def player_can_take_turn?()
    return @current_turn == 'player' && @turn_timer == 0
  end
  
  def take_enemy_turn()
    @enemy.abilities[rand(@enemy.abilities.count())].use(@player, @enemy)
    @enemy.pass_turn()
  end
  
  def take_player_turn(ability)
    ability.use(@player, @enemy)
    @player.pass_turn()
    @turn_timer = 1
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
      
      # Player
      #   health bar
      @health_bar_image.draw(@battle_yml['player']['health']['x'], @battle_yml['player']['health']['y'], 2)
      draw_square(@window, @battle_yml['player']['health']['x'] + 16, @battle_yml['player']['health']['y'] + 4, 1, (@health_bar_image.width - 32) * (@player['health'].to_f() / @player.get_max_health()), @health_bar_image.height - 8, @battle_yml['healthbar']['color'].to_i(16))
      @health_font.draw("#{@player['health']}/#{@player.get_max_health()}", @battle_yml['player']['health']['x'] + ((@health_bar_image.width() - @health_font.text_width("#{@player['health']}/#{@player.get_max_health()}")) / 2), @battle_yml['player']['health']['y'] + 12, 3, 1, 1, @battle_yml['healthbar']['font']['color'].to_i(16))
      #   nametag
      @nametag_font.draw(@player['name'], @battle_yml['player']['nametag']['x'], @battle_yml['player']['nametag']['y'], 1)
      #   battle image
      @player.battle_image.draw(@battle_yml['player']['image']['x'], @battle_yml['player']['image']['y'], 2)
      #   fire indicator
      if @player.get_dot(:fire)[1] > 0 then
        Media::get_image(@battle_yml['player']['fire_indicator']['image']).draw(@battle_yml['player']['fire_indicator']['x'], @battle_yml['player']['fire_indicator']['y'], 1)
        @status_font.draw(@player.get_dot(:fire)[1], @battle_yml['player']['fire_indicator']['x'] + Media::get_image(@battle_yml['player']['fire_indicator']['image']).width() + 4, @battle_yml['player']['fire_indicator']['y'], 1)
      end
      # Enemy
      #   health bar
      @health_bar_image.draw(@battle_yml['enemy']['health']['x'], @battle_yml['enemy']['health']['y'], 2)
      draw_square(@window, @battle_yml['enemy']['health']['x'] + 16, @battle_yml['enemy']['health']['y'] + 4, 1, (@health_bar_image.width - 32) * (@enemy['health'].to_f() / @enemy.get_max_health()), @health_bar_image.height - 8, @battle_yml['healthbar']['color'].to_i(16))
      @health_font.draw("#{@enemy['health']}/#{@enemy.get_max_health()}", @battle_yml['enemy']['health']['x'] + ((@health_bar_image.width() - @health_font.text_width("#{@enemy['health']}/#{@enemy.get_max_health()}")) / 2), @battle_yml['enemy']['health']['y'] + 12, 3, 1, 1, @battle_yml['healthbar']['font']['color'].to_i(16))
      #   nametag
      @nametag_font.draw(@enemy['name'], @battle_yml['enemy']['nametag']['x'], @battle_yml['enemy']['nametag']['y'], 1)
      #   battle image
      @enemy.battle_image.draw(@battle_yml['enemy']['image']['x'], @battle_yml['enemy']['image']['y'], 2)
      #   fire indicator
      if @enemy.get_dot(:fire)[1] > 0 then
        Media::get_image(@battle_yml['enemy']['fire_indicator']['image']).draw(@battle_yml['enemy']['fire_indicator']['x'], @battle_yml['enemy']['fire_indicator']['y'], 1)
        @status_font.draw(@enemy.get_dot(:fire)[1], @battle_yml['enemy']['fire_indicator']['x'] + Media::get_image(@battle_yml['enemy']['fire_indicator']['image']).width() + 4, @battle_yml['enemy']['fire_indicator']['y'], 1)
      end
      
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
      
      # Ability description -- Only show when the player can make a move
      if id = @current_boxes_under_mouse.select(){|b| b.start_with?('ability')}[0] and player_can_take_turn?() then
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
        if @player != nil and @enemy != nil and player_can_take_turn?() then
          case id
            when 'ability_button1'
              take_player_turn(@player.abilities[0])
            when 'ability_button2'
              take_player_turn(@player.abilities[1])
            when 'ability_button3'
              take_player_turn(@player.abilities[2])
            when 'ability_button4'
              take_player_turn(@player.abilities[3])
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

