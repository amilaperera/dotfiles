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

# the default symbol and symbol_prefix colors are yellow and
# since they don't go well with light terminal color theme adjust the colors
Wirble::Colorize::DEFAULT_COLORS[:symbol] = :purple
Wirble::Colorize::DEFAULT_COLORS[:symbol_prefix] = :purple

IRB.conf[:AUTO_INDENT] = true

def clear
    system('clear')
end
