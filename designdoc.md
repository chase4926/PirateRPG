Pirate JRPG
(JRPG = Final Fantasy style rpg)

Core statement:
This game is about developing your character as a pirate.


# Sound #
  TBD

# Art #
  Paper Mario style but completely 2d
  Mostly top-down
  No lighting

# Title Screen #
  New Game => Starts a new game
  Load Game => Opens a menu with all saves, with autosave at the top
  Options => Resolution, fullscreen, sound slider
  Quit => Quits game
# Ships #
  Speed attribute affects ship movement on overworld, and affects the chance to get away
  Smaller ships have a higher speed attribute, ship gear can also affect this
# Items #
  ## Special effects ##
    Movement speed increase
    Health Regeneration
    Increase Attribute
  ## Attributes ##
    All items can have Seperate Attributes
    Power (Affects damage)
    Precision (Affects Crit. Chance)
    Armor (Damage resistance)
    Vitality (Affects max health)
    Willpower (Fire resistance)
    Fire damage bonus
  ## Player Items ##
    ### Weapons ###
      Attributes (Damage, Haste)
      Can have armor pierce effect
    ### Gear ###
      Uses above attributes and special effects
  ## Ship Items ##
    ### Weapons ###
      Weapon Types (Cannons, Boarding Hooks, Machine Gun)
      Cannons designed for high armor targets, machine guns for low armor
      Boarding hooks have a chance to grapple to the enemy ship and start a 'walking around' sequence
        Chance is related to the level of the enemy, the damage it has taken, and the damage of the boarding hook
      Weapons give an amount of precision(related to crit. chance)
      2 Weapon slots per ship, some weapon slots are bigger than others depending on ship
        ex. Large SkullCrusher requires a large slot
      #### Special Effects ####
        Health Regeneration
        Fire damage bonus
        Attributes(Damage, Armor Pierce)
          Armor Pierce reduces armor
          Damage on boarding hooks does damage and also affects chance of successful 'hook'
    ### "Gear" ###
      Ship gear gives attributes(Armor, Vitality, Precision, Speed)
      Ship has 'slots' for gear
      Amount of gear slots depends on ship
      #### Special effects ####
        Health regeneration
        Increase Attribute
        Willpower Bonus

# Level design #
  No children
  Can kill any npc
  Game is based on islands & a massive overworld ocean
  ## Overworld ##
    There are multiple overworld maps
    Each overworld map has a vortex in it, which allows the player to
      travel to the next map.
  ## Island-world (Basically, whatever isn't the overworld) ##
    There are sub-maps (Taverns, houses, caves)
  ## Exploration ##
    Find gold and loot in chests
    Loot being weapons, gear, commodities

# Character #
  No max level
  The player does not start with skills
  The player gains 1 skill point per 5 levels and no attribute points(5,10,15...)
  It is expected that after 'completing' the game the player will be level 80-100
  ## Healing ##
    The character can buy and find bandages which are used for healing
  ## Skill Tree ##
    2 Branches(Combat, Naval)
    Combat branch relates to all things in exploration mode, naval for ship mode
    If all skills have been 'maxed out' skill points can be put into any of the attributes (Power, Precision, Armor, Vitality)
  ## Inventory ##
    3 Tiers of bags
    Each tier has a certain amount of slots (8, 16, 24)
    Main storage in ship
  ## Creation ##
    Negative traits give trait points
    Positive traits use trait points


# Gameplay #
  Battles are a seperate screen.
  2 seperate game modes
  Both modes have battle screen
  ## Formulas ##
    Armor is temporarily (while the attack happens) reduced by the armor pierce amount
    Damage formula is ((power * (weapondamage - armor))) * ((100 - fatigue) * .01)        (probably going to change)
      If there is a critical hit, the formula becomes ((power * (weapondamage - armor) * 2)) * ((100 - fatigue) * .01)
    ### Fire Damage ###
      Replace element with fire
      firedamage - fireresist = firestrength
      Fire Strength affects the effect of fire damage
       For the purposes of this, fire damage is represented by 'x'
        If fire damage is lower than 1, no fire effect occurs
        Fire damage does (x - enemylevel) damage per turn
  ## Dock ##
    ### Dock Menu ###
      To open the menu you talking to a sailor NPC
      Board Ship => Shows you the ships currently docked, and you can choose which one to board
      Trade Ship => Pay an NPC trader to 'move' a ship to another island for money, depending on the size of the ship
      Modify Ship => Shows your ships, and upon choosing one, you enter a menu for refitting your ship
      Cancel => Returns to the previous menu / Exits out of the docking options
  ## Combat ##
    One move can be used per turn
    If a skill would put the player over 100 fatigue, the skill cannot be used
    10 fatigue lost per turn
    Fatigue gained from using skills, the higher the fatigue the less the damage dealt
      Fatigue goes from 1 - 100
  ## "Walking around" mode ##
    Pirate v. human battles
    ### Battles ###
      Sword and gun combat mechanics different
  ## "Driving the ship" mode ##
    Ship v. ship battles
    Random battles while moving
    ### Battles ###
      Ship upgrades effect combat style(abilities)
      #### Classical (cannon) combat ####
        Honor reward for victory
      #### Boarding Ships ####
        Enters a walking around level
        Win condition is killing captain
        If successful greater reward than shooting it down
        Gold/loot reward for victory

# Metagame stuff #
  Ship Upgrades
  Torchlight 2 style skill tree - determines personal abilities
  ## Trade ##
    Different trade hubs with different commodities
    Possible dynamic market
    Trading as a profession
    All weapons are sold for half the original price
    Commodity values are put into the island data folder
  ## Equipment ##
    Ship & player have two equipment slots,
    Each item equipped gives an ability
    Ship & player have 4 ability slots, 2 being for equipment, 2 being for personal abilities

# Modding #
  Possible user generated terrain
  Terrain, enemies, weapons not hardcoded

# Story #
  No overarching story
  Each island has an independent story, not important for game completion
  Some island's stories are minorly linked to each other





Directory structure of an island:
Folders are marked with {foldername}

--UNFINISHED--
{island name}
  level.whatever - Contains the island level data
  shop_prices.yml - YAML file containing shop prices for shops
  npc.dialogue
  events.yml
  {sublevels}
    {sublevelname}
      level.whatever - Contains sublevel data
      shop_prices.yml - Same as above
      npc.dialogue
      events.yml






