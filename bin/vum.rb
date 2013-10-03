#!/usr/bin/env ruby

# VUM - Vim plUgin Manager
# This downloads/updates/deletes vim plugins that are managed via git

require 'rubygems'
require 'colorize'

class Vum
  VUM_REPOS_FILE = ENV["HOME"] + "/.vum_repos"

  attr_reader :repolist

  def initialize
    @repolist = get_repolist_from_file
    @ok_repolist = []
    @failed_repolist = []
  end

  def get_repolist_from_file
    if File.exists?(VUM_REPOS_FILE)
      File.open(VUM_REPOS_FILE, 'r') do |file|
        file.readlines.collect { |line| line.chomp }
      end
    end
  end

  def install_plugins_with_check
    puts "vum is now checking for repository existence"
    check_for_repo_existence

    puts
    puts "#{@ok_repolist.length}/#{@repolist.length}".bold.green +
          " repositories seem to be good enough for downloading"
    puts "#{@failed_repolist.length}/#{@repolist.length}".bold.red +
          " repositories were found to have some troubles" +
          " and vum will not use those repositories for downloading" if @failed_repolist.length > 0

    print "Proceed [y/n] ? "
    answer = gets.chomp
    return unless answer.downcase == "y" || answer.downcase == "yes"

    download_plugins
  end

  def check_for_repo_existence
    @ok_repolist.clear
    @failed_repolist.clear
    repo_max_length = 0

    @repolist.each { |repo| repo_max_length = repo.length if repo.length > repo_max_length }

    @repolist.each do |repo|
      `git ls-remote #{repo} > /dev/null`

      padding_length = repo_max_length + 5 - repo.length
      if $?.exitstatus == 0
        @ok_repolist << repo
        puts "#{repo} " + ("." * padding_length) + " [   "+ "OK".bold.green + "   ]"
      else
        @failed_repolist << repo
        puts "#{repo} " + ("." * padding_length) + " [ "+ "FAILED".bold.red + " ]"
      end
    end
  end

  def download_plugins
    puts "Plugins download starts"
    @ok_repolist.each do |repo|
      `git clone #{repo} 1>/dev/null 2>&1`
      if $?.exitstatus == 0
        puts "#{repo} download success"
      else
        puts "#{repo} download failed"
      end
    end
  end
end

# main
vum = Vum.new
vum.install_plugins_with_check
