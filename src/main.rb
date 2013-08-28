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
require 'xmlsimple'

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
# ---

$VERBOSE = true

srand()


window = GameWindow.new(:window_width => 1280, :window_height => 720, :width => 1280, :height => 720, :fullscreen => false, :caption => 'PirateRPG').show()


