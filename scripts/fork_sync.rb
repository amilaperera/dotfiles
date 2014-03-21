#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'

# We just extend the String class to display some colors on the terminal
class String
  # colorization
  # from http://stackoverflow.com/questions/1489183/colorized-ruby-output
  def colorize(color_code); "\e[#{color_code}m#{self}\e[0m"; end
  def red; colorize(31); end
  def green; colorize(32); end
  def yellow; colorize(33); end
  def pink; colorize(35); end
end

# this class contains information regarding all the forked
# repositories
class ForkSync
  attr_reader :forks

  def initialize(config_file)
    begin
      @forks = YAML.load_file(config_file)
    rescue
      abort "Can't open yaml file [ #{e.message} ]"
    end
  end

  def execute
    forks.each do |repo_name, repo_fork|
      puts "--- " + "Synchronizing #{repo_name}".green + " ---"
      dir, upstream_repo = get_values(repo_fork)

      ForkRepo.new(dir, upstream_repo).sync_fork
    end
  end

  def get_values(repo_fork)
    abort "No value given for 'dir'" if [ nil, '' ].include?(repo_fork["dir"])
    abort "No value given for 'upstream'" if [ nil, '' ].include?(repo_fork["upstream"])
    [ repo_fork["dir"], "https://github.com/" + repo_fork["upstream"] ]
  end
end

# this class contains details of a single forked repository
class ForkRepo
  attr_reader :dir, :upstream_repo

  def initialize(dir, upstream_repo)
    @dir = dir
    @upstream_repo = upstream_repo
  end

  def sync_fork
    # change to the directory
    cd_to_dir
    puts "Changing to directory: " + "#{dir}".yellow

    # check for upstream remote
    unless upstream_exists?
      puts "Can't find the upstream remote..."
      puts "Adding #{upstream_repo} as an upstream repository..."
      add_upstream_repo
    end

    puts "Fetching from upstream #{upstream_repo}..."
    fetch_from_upstream

    puts "Merging with the upstream #{upstream_repo}..."
    merge_with_upstream
    puts format_output(current_git_status)
    puts
  end

  private

  def cd_to_dir
    begin
      Dir.chdir(File.expand_path(dir))
    rescue
      abort "Can't find the directory: #{dir}...[ #{e.message} ]"
    end
  end

  def upstream_exists?
    `git ls-remote upstream 2>/dev/null`
    $?.success?
  end

  def add_upstream_repo
    `git remote add upstream #{upstream_repo}`
    unless $?.success?
      abort "error adding the remote upstream: #{upstream_repo}..."
    end
  end

  def fetch_from_upstream
    `git fetch upstream`
    unless $?.success?
      abort "error fetching from upstream: #{upstream_repo}..."
    end
  end

  def merge_with_upstream
    `git checkout master 2>/dev/null` # switch to local master
    `git merge upstream/master` # merge with the upstream master
    unless $?.success?
      abort "  error merging with upstream: #{upstream_repo}..."
    end
  end

  def current_git_status
    `git status`
  end

  def format_output(output)
    s = output.split("\n").at(1)
    if s =~ /[0-9]+/
      "  " + s.pink
    else
      "  " + s.yellow
    end
  end
end

###########################################################
# main program
###########################################################
fork_sync = ForkSync.new('.fork_sync.yaml')
fork_sync.execute
