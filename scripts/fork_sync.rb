#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'

class ForkSync
  def initialize(config_file)
    begin
      @forks = YAML.load_file(config_file)
    rescue
      abort "can't open yaml file [ #{e.message} ]"
    end
  end
end

fork_sync = ForkSync.new('_fork_sync_.yaml')

puts fork_sync.inspect
