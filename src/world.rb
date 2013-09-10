#!/usr/bin/env ruby
#world.rb


class World < ControllerObject
  def initialize(window)
    super()
    @window = window
    
    # Test code below, this would never be here
    @size = [100, 100]
    @world_image = generate_world()
    @translate_x = 0
    @translate_y = 0
    #@player = Player.new()
    #@enemy = Enemy.new()
    #push_event(:set_battle, @player)
    #push_event(:set_battle, @enemy)
    #push_event(:change_phase, 2)
  end
  
  def generate_world()
    return @window.record(@size[0]*32, @size[1]*32) do
      @size[1].times() do |y|
        @size[0].times() do |x|
          Media::get_image("world/#{rand(5)+1}.png").draw(x*32, y*32, 0)
        end
      end
    end
  end
  
  def update()
    if @window.button_down?(Gosu::Button::KbLeft) then
      @translate_x -= 4
    end
    if @window.button_down?(Gosu::Button::KbRight) then
      @translate_x += 4
    end
    if @window.button_down?(Gosu::Button::KbUp) then
      @translate_y -= 4
    end
    if @window.button_down?(Gosu::Button::KbDown) then
      @translate_y += 4
    end
  end
  
  def draw()
    @window.translate(-@translate_x, -@translate_y) do
      @world_image.draw(0, 0, 0)
    end
  end
end

