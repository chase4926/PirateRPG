#!/usr/bin/env ruby
#main.rb
=begin
PirateRPG
=end


Dir.chdir(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__))
$:.unshift(File.expand_path('../lib'))

# System libraries ---
require 'gosu'
require 'nokogiri'
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
require 'battle.rb'
# ---

$VERBOSE = true

srand()


Res::Vars.load('../config.yml')
window = GameWindow.new(:window_width => Res::Vars['resolution'][0], :window_height => Res::Vars['resolution'][1], :width => 1280, :height => 720, :fullscreen => Res::Vars['fullscreen'], :caption => 'Vortex Voyager', :show_fps => true).show()


