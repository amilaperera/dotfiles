#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'

class ForkSync
  def initialize(&block)
    @forks = block.call
  end
end

fork_sync = ForkSync.new do
  begin
    YAML.load_file("_fork_sync3_.yaml")
  rescue Exception => e
    abort "can't open yaml file [ #{e.message} ]"
  end
end

puts fork_sync.inspect
