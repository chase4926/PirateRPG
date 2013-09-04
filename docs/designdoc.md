Vortex Voyager
(Final Fantasy style rpg with pirates. YAAARRR!!!)

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
  ## Requirements to use ##
    Player level requirement
    Attribute requirement
    Slot size requirement (in the case of ships)
  ## Special effects ##
    Movement speed increase
    Health Regeneration
    Increase Attribute
  ## Player Items ##
    ### Weapons ###
      Attributes (Damage)
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
      Ship gear gives attributes(Armor, max health, Precision, Speed)
      Ship has 'slots' for gear
      Amount of gear slots depends on ship
      #### Special effects ####
        Health regeneration
        Increase Attribute
        Fire Resistance Bonus

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
      Chests have a level, this level +- 25% is the level of the dropped item
    Loot being weapons, gear, commodities
    ### Item Classes ###
      Specific items in categories listed in itemsets.md
      Common Commodities
      Uncommon Commodities
      Rare Commodities
      Ultra Rare Commodities 
      Common Loot
      Uncommon Loot
      Rare Loot
      Ultra-Rare Loot
      Elite Loot
# Character #
  No max level
  1 attribute point is gained per level along with points being automatically allocated to attributes
  The player does not start with skills
  The player gains 1 skill point per 5 levels and no attribute points(5,10,15...)
  It is expected that after 'completing' the game the player will be level 50
  ## Healing ##
    The character can buy and find bandages which are used for healing
    Different tiers of bandages, level requirement to use higher tiers
  ## Skill Tree ##
    2 Branches(Combat, Naval)
    Combat branch relates to all things in exploration mode, naval for ship mode
    If all skills have been 'maxed out' skill points can be put into any of the attributes (Power, Precision, Armor, max health)
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
    EXP required for level up where 'x' is level = 1/(((x^2)/(.00002x^3)) + 300) * 30000000
    Armor is temporarily (while the attack happens) reduced by the armor pierce amount
    Damage formula is ((power * (weapondamage - armor))) * ((100 - fatigue) * .01)        (probably going to change)
      If there is a critical hit, the formula becomes ((power * (weapondamage - armor) * 2)) * ((100 - fatigue) * .01)
    Critical chance is 1/(((0.5x^2)/(.000075x^3)) + 90) * 9000
    ### Fire Damage ###
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
    The player with the higher ship speed attacks first
    One move can be used per turn
    If a skill would put the player over 100 fatigue, the skill cannot be used
    10 fatigue lost per turn
    Fatigue gained from using skills, the higher the fatigue the less the damage dealt
      Fatigue goes from 1 - 100
    Damage done will be shown above the victim's head after attack animation is complete
    Gold is given as a reward for victory
    For battle effects/attributes, seperate ones specific to battle should be set before the battle, 
      equal to the character's attributes
      This is to make it easier to modify them while in battle
      ### Combat AI ###
        Option A -
          Uses random attacks
        Option B -
          Tries to inflict fire damage, then uses status impairing attacks, then uses damaging attack at random
    ### Naval effects/attributes to be tracked ###
    Fire damage per turn
    Armor pierce
    Power
    Precision
    Armor
    Speed
    Max health
    Fire Resistance
    Current Health
    ### Regular effects/attributes to be tracked ###
    Fire damage per turn
    Armor pierce
    Power
    Precision
    Armor
    Max health
    Haste
    Fire Resistance
    Current Health
    ### GUI Layout ###
      4 attacks on bottom right of screen
        Top 2 attacks are left and right equipped weapon
        Bottom 2 attacks are skills
      Health/Fatigue bars above sprites at top of screen
      "Current Value / Maximum Value" are displayed in the middle of the health / fatigue bars
      Enemy sprite is on the left side of the screen
      Player sprite is to the right of the screen
      Bottom left of the screen shows a description of the currently selected skill
  ## "Walking around" mode ##
    Pirate v. human battles
  ## Dialogue ##
    NPC's dialogue is dependant on amount of times the NPC has been talked to, player level
    ### GUI Layout ###
      A bar at the bottom of the screen shows health and buttons to enter menus
        Inventory  => Opens a window showing the inventory
        Options => Opens a menu showing the options
        Character => Opens a window showing character information (attributes, current equipement)
        Skills => Opens a window showing the skill tree
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
    Shopkeepers have a global price modifier, it modifies the price of all the items that are not specifically modified (Adds mod support)
	Shopkeepers have price modifiers on specific items, allowing different islands to have different priced items/commodities
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

# Level Editor Requirements #
  Fill tool
  Placeable Tiles
    There will be a solid attribute
  Placeable NPCs
  Placeable Shopkeepers
  Placeable Dock People
  Placeable Enemies
  Placeable Warps
  Placeable Chests



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

# Attributes #

Vitality (Determines max health) => 1 vitality gives 10 max health
Precision (Determines crit chance)
Power (Effects base damage value)
Armor (Effects base defense value)

# Stats #

Max health & Current
Crit Chance
Base damage value (ability gives more)
Base defense value (gear gives more)







