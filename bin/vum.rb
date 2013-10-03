#!/usr/bin/env ruby

# VUM - Vim plUgin Manager
# This downloads/updates/deletes vim plugins that are managed via git

require 'rubygems'
require 'colorize'

class Vum
  VUM_REPOS_FILE = ENV["HOME"] + "/.vum_repos"

  attr_reader :repolist

  def initialize
    @repolist = get_repolist_from_file # if success repolist hash is sorted by plugin name
    @ok_repolist = []
    @failed_repolist = []
  end

  def get_repolist_from_file
    @repolist = []
    if File.exists?(VUM_REPOS_FILE)
      File.open(VUM_REPOS_FILE, 'r').each_line do |line|
        repo_line = line.chomp
        @repolist << { :plugin_name => get_plugin_name(repo_line), :repo_site => repo_line }
      end

      unless @repolist.empty?
        sort_repolist_by_plugin_name(@repolist)
      end
    end
  end

  def install_plugins_with_check
    puts "vum is now checking for repository existence"
    check_for_repo_existence

    puts
    puts "#{@ok_repolist.length}/#{@repolist.length}".bold.green +
          " repositories seem to be good enough for downloading" if @ok_repolist.length > 0

    puts "#{@failed_repolist.length}/#{@repolist.length}".bold.red +
          " repositories were found to have some troubles" +
          " and vum will not use those repositories for downloading" if @failed_repolist.length > 0

    print "Proceed [y/n] ? "
    answer = gets.chomp
    return unless answer.downcase == "y" || answer.downcase == "yes"

    download_plugins
  end

  def install_plugins_without_check
    @ok_repolist = @repolist
    download_plugins
  end

  def check_for_repo_existence
    @ok_repolist.clear
    @failed_repolist.clear

    # get maximum reposite name
    max_repo_plugin_site_name_length = 0
    @repolist.each do |repo|
      if (repo[:repo_site].length + repo[:plugin_name].length) > max_repo_plugin_site_name_length
        max_repo_plugin_site_name_length = repo[:repo_site].length + repo[:plugin_name].length
      end
    end

    @repolist.each do |repo|
      padding_length = max_repo_plugin_site_name_length + 8 - repo[:repo_site].length - repo[:plugin_name].length
      `git ls-remote #{repo[:repo_site]} 2>/dev/null 1>&2`
      if $?.exitstatus == 0
        @ok_repolist << repo
        puts "#{repo[:plugin_name]} (#{repo[:repo_site]}) " + ("." * padding_length) + " [   "+ "OK".bold.green + "   ]"
      else
        @failed_repolist << repo
        puts "#{repo[:plugin_name]} (#{repo[:repo_site]}) " + ("." * padding_length) + " [ "+ "FAILED".bold.red + " ]"
      end
    end
  end

  def download_plugins
    puts "Plugins download starts"
    @ok_repolist.each do |repo|
      `git clone #{repo}`
      if $?.exitstatus == 0
        puts "#{repo} download success"
      else
        puts "#{repo} download failed"
      end
    end
  end

  def get_plugin_name(line)
    line.gsub(/.*\//, "").gsub(/\..*$/, "").capitalize
  end

  def sort_repolist_by_plugin_name(repolist)
    repolist.sort_by { |repo| repo[:plugin_name] }
  end

end

# main
vum = Vum.new
vum.check_for_repo_existence
