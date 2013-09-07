#!/usr/bin/env ruby
#abilities.rb


module Abilities
  # Player abilities
  module Heal
    def self.title()
      return 'Heal'
    end
    
    #def self.full_name()
      #return 'Example of a full name for Heal'
    #end
    
    def self.desc(player, enemy)
      return "Restores <c=00ff00>#{get_heal_amount(player)}</c> health."
    end
    
    def self.script(player, enemy)
      player.heal(get_heal_amount(player))
      #heal_amount = get_heal_amount(player)
      #if heal_amount + player['health'] >= player.get_max_health() then
        #heal_amount = player.get_max_health() - player['health']
      #end
      #player['health'] += heal_amount
    end
    
    def self.get_heal_amount(player)
      return (player.get_max_health() * 0.25).round()
    end
  end
  
  module Strike
    def self.title()
      return 'Strike'
    end
    
    def self.desc(player, enemy)
      return 'Inflicts x damage.'
    end
    
    def self.script(player, enemy)
      puts 'Add script Strike'
    end
  end
  
  # Enemy abilities
  module Default_Enemy
    def self.title()
      return 'Enemy ability'
    end
    
    def self.desc(player, enemy)
      return 'The ability the enemy uses. This is NEVER usable by the player!'
    end
    
    def self.script(player, enemy)
      damage = Range.new(enemy['power'] - (enemy['power'] / 4.0).round(), enemy['power'] + (enemy['power'] / 4.0).round()).to_a().shuffle().pop()
      player.hurt(damage - player['armor'] <= 0 ? 0 : damage - player['armor'])
    end
  end
end

