#############################################################
# Author: Amila Perera
# File Name: .irbrc
#
# Description:
# irb(interactive ruby shell) configuration file
#############################################################
require 'rubygems'
require 'irb/completion'

# loads wirble for colored output
begin
  require 'wirble'

  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load wirble: #{err}"
end

# loads awesome_print for printing output in a user friendly manner
begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError => err
  warn "Couldn't load awesome_print: #{err}"
end

# loads hirb for displaying records in a table
begin
  require 'hirb'
  HIRB_LOADED = true
rescue LoadError => err
  HIRB_LOADED = false
  warn "Couldn't load hirb: #{err}"
end

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true

IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:SAVE_HISTORY] = 1000

# enable hirb withing irb
def enable_hirb
  if HIRB_LOADED
    Hirb::Formatter.dynamic_config['ActiveRecord::Base']
    Hirb.enable
  else
    puts "Hirb is not loaded"
  end
end

# disable hirb withing irb
def disable_hirb
  if HIRB_LOADED
    Hirb.disable
  else
    puts "Hirb is not loaded"
  end
end

# clears screen
def clear
    system 'clear'
end

# shows the contents of the current dir
def ls(path='.')
  Dir[ File.join(path, '*') ].map { |filename| File.basename filename }
end

# shows the current dir
def pwd
  Dir.pwd
end

# reads file contents
def cat(path)
  File.readlines path.to_s
end

# concise syntaxt for require
def rq(lib)
  require lib.to_s
end
