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

# changing some of the default colors in order to suit a dark background
# blue -> purple
Wirble::Colorize::DEFAULT_COLORS[:object_addr_prefix] = :purple
Wirble::Colorize::DEFAULT_COLORS[:object_line_prefix] = :purple
Wirble::Colorize::DEFAULT_COLORS[:comma] = :purple
Wirble::Colorize::DEFAULT_COLORS[:refers] = :purple

IRB.conf[:AUTO_INDENT] = true

def clear
    system('clear')
end
