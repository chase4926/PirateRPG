#!/usr/bin/env ruby
#main.rb
=begin
PirateRPG
=end


Dir.chdir(File.dirname(__FILE__))
$:.unshift(File.expand_path('.'))
$:.unshift(File.expand_path('../lib'))

# System libraries ---
require 'rubygems'
require 'thread'
require 'gosu'
require 'yaml'

# Local libraries ---
require 'lib.rb'
require 'lib_misc.rb'
require 'lib_misc_gosu.rb'
require 'lib_encrypt.rb'
require 'lib_medialoader.rb'
require 'lib_alphabet.rb'
include EveryModule

# Source files ---
require 'engine.rb'
require 'menu.rb'
require 'world.rb'
require 'battle.rb'
require 'player.rb'
require 'enemy.rb'
require 'abilities.rb'
# ---

$VERBOSE = true

srand(Time.now().to_i())

# Handle arguments ---
ARGV.each() do |arg|
  case arg.gsub('-', '')
    when 'editor'
      p 'Editor!!!'
  end
end
ARGV.clear()
# ---

Res::Vars.load('../config.yml')
window = GameWindow.new(:window_width => Res::Vars['resolution'][0], :window_height => Res::Vars['resolution'][1], :width => 1280, :height => 720, :fullscreen => Res::Vars['fullscreen'], :caption => 'Vortex Voyager', :show_fps => true).show()


