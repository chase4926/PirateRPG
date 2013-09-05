#!/usr/bin/env ruby
#abilities.rb


module Abilities
  module Heal
    def self.title()
      return 'Heal'
    end
    
    def self.full_name()
      return 'Example of a full name for Heal'
    end
    
    def self.desc(player, enemy)
      return 'Restores x health.'
    end
    
    def self.script(player, enemy)
      puts 'Add script Heal'
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
end

