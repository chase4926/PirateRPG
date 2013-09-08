#!/usr/bin/env ruby
#abilities.rb


module Abilities
  # Player abilities
  module Leap
    def self.title()
      return 'Leap'
    end
    
    def self.desc(player, enemy)
      return "Jumps on the enemy, \ndealing <c=ff4d4d>#{self.get_damage_amount()}</c> damage."
    end
    
    def self.script(player, enemy)
      enemy.hurt(self.get_damage_amount())
    end
    
    def self.get_damage_amount()
      return (player['power'] - enemy['armor']) * (player['armor'] + 1)
    end
    
    def self.fatigue_required()
      return 30
    end
  end
  
  module Rotato
    def self.title()
      return 'Rotato'
    end
    
    def self.desc(player, enemy)
      return "Spins around at the enemy,\ndealing <c=ff4d4d>#{self.get_damage_amount()}</c> damage."
    end
    
    def self.script(player, enemy)
      enemy.hurt(self.get_damage_amount())
    end
    
    def self.get_damage_amount()
      return (player['power'] * player['precision']) / (enemy['armor'] + 1)
    end
    
    def self.fatigue_required()
      return 50
    end
  end
  
  module Cooldown
    def self.title()
      return 'Cooldown'
    end
    
    def self.desc(player, enemy)
      return "Rests for a turn, \nrestoring <c=a210ff>30</c> fatigue."
    end
    
    def self.script(player, enemy)
      player.regain_fatigue(30)
    end
    
    def self.fatigue_required()
      return 0
    end
  end
  
  module Bash
    def self.title()
      return 'Bash'
    end
    
    def self.desc(player, enemy)
      return "Bashes the opponenent,\ndealing damage if your armor\nis higher than the opponent\nand has a chance to stun."
    end
    
    def self.script(player, enemy)
      damagenum = ((rand((player['armor'] - enemy['armor']) / 2.5) - rand((player['armor'] - enemy['armor']) / 5)) + (player['armor'] - enemy['armor'])).round
      if(damagenum >= 0) then
        enemy.hurt(damagenum)
      else
        enemy.hurt(0)
      end
      if(rand(2) == 0)  then
        enemy.stun()
      end
    end
    
    def self.fatigue_required()
      return 20
    end
  end
	
  module Heal 
    def self.title()
      return 'Heal'
    end
    
    #def self.full_name()
      #return 'Example of a full name for Heal'
    #end
    
    def self.desc(player, enemy)
      return "Restores <c=00ff00>#{self.get_heal_amount(player)}</c> health."
    end
    
    def self.script(player, enemy)
      player.heal(self.get_heal_amount(player))
    end
    
    def self.get_heal_amount(player)
      return (player.get_max_health() * 0.25).round()
    end
    
    def self.fatigue_required()
      return 30
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
      damage = Range.new(enemy['power'] - (enemy['power'] / 4.0).round(), enemy['power'] + (enemy['power'] / 4.0).round()).to_a().sample()
      player.hurt(damage - player['armor'] <= 0 ? 0 : damage - player['armor'])
      if rand(10) == 0 then
        player.stun()
      end
    end
    
    def self.fatigue_required()
      return 0
    end
  end
end

