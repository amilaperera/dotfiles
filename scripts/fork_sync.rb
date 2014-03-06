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

  def execute
    @forks.each do |repo_name, repo_fork|
      puts "Synchronizing #{repo_name}"
      sync_fork(repo_fork)
    end
  end

  private

  def sync_fork(repo_fork)
    # change to the directory
    Dir.chdir(File.expand_path(repo_fork["dir"])) do
      `git ls-remote upstream 2>/dev/null`
      unless $?.success?
        # when there are no upstreams added,
        # add the upstream as defined by the yaml file.
        puts "  Cannot find upstream repository..."
        puts "  Adding upstream repository..."
      end
    end
  end

end

fork_sync = ForkSync.new('_fork_sync_.yaml')
fork_sync.execute

puts fork_sync.inspect
