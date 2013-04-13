#############################################################
# Author: Amila Perera
# File Name: .irbrc
#
# Description:
# irb(interactive ruby shell) configuration file
#############################################################
require 'rubygems'
require 'wirble'
Wirble.init
Wirble.colorize

IRB.conf[:AUTO_INDENT] = true

def clear
    system('clear')
end
