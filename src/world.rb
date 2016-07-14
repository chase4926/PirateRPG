#!/usr/bin/env ruby
#world.rb


class World < ControllerObject
  def initialize(window)
    super()
    @window = window
    
    # Test code below, this would never be here
    @size = [128, 128]
    @world_image0 = generate_world(0)
    @world_image1 = generate_world(1)
    @translate_x = 0
    @translate_y = 0
    #@player = Player.new()
    #@enemy = Enemy.new()
    #push_event(:set_battle, @player)
    #push_event(:set_battle, @enemy)
    #push_event(:change_phase, 2)
  end
  
  def generate_world(layer)
    case layer
      when 0
        return @window.record(@size[0]*32, @size[1]*32) do
          @size[1].times() do |y|
            @size[0].times() do |x|
              Media::get_image("world/#{rand(3)+1}.png").draw(x*32, y*32, 0)
            end
          end
        end
      when 1
        return @window.record(@size[0]*32, @size[1]*32) do
          @size[1].times() do |y|
            @size[0].times() do |x|
              if rand(5) == 0 then
                #Media::get_image("world/#{rand(2)+4}.png").draw(x*32, y*32, 0)
                Media::get_image("world/trunk.png").draw(x*32, y*32, 0)
                Media::get_image("world/leaves.png").draw(x*32, y*32, 0, 1, 1, Gosu::Color.new(255, rand(155)+100, rand(155)+100, 0))
              end
            end
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
      @world_image0.draw(0, 0, 0)
      @world_image1.draw(0, 0, 1)
    end
  end
end

