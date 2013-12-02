#!/usr/bin/env ruby
# encoding: utf-8

require "fileutils"

STDOUT.sync = true

# Env class is a strategy base class
class Env
  attr_accessor :info, :symlinks_targets

  HOME_DIR = ENV['HOME']
  DOTFILES_DIR = "#{HOME_DIR}/.dotfiles"

  def initialize
    @info, @symlinks_targets = { setup_name: "", error_msg: "" }, [ ]
  end

  # Checks if file/directory/symlink exists
  def obj_exists?(obj)
    File.exists?(obj) || File.directory?(obj) || File.symlink?(obj)
  end

  # Creates a symlink at 'symlink_dest' to 'symlink_src'.
  # Removes the symlink target if it exists.
  def force_create_symlink(symlink_src, symlink_dest)
    if File.directory?(symlink_dest)
      FileUtils.remove_dir(symlink_dest, force: true)
    end
    FileUtils.ln_s(symlink_src, symlink_dest, force: true)
  end

  # Creates symbolic links specified by 'symlinks_targets'
  # in the user's home drectory.
  def create_symlinks_in_home
    forceall, noforceall = false, false

    @symlinks_targets.each do |symlink|
      symlink_src = "#{Env::DOTFILES_DIR}/#{symlink}"
      symlink_dest = "#{Env::HOME_DIR}/#{symlink}"

      # check if the file or directory exists
      obj_exists = obj_exists?(symlink_dest)

      if obj_exists && !forceall && !noforceall
        # If the file exists and the user has not given 'ya' or 'yn' then
        # go on asking whether to replace the existing file or not
        print "  Replace #{symlink_src} with a symbolic link to #{symlink_dest} (y|n|ya|na)? "
        reply = gets.chomp.downcase
        forceall = true if reply.eql? "ya"
        noforceall = true if reply.eql? "na"
        reply = "y" if reply.empty?

        if reply.eql?("y") || forceall
          # This block will be executed only once if the user replies with 'ya'
          force_create_symlink(symlink_src, symlink_dest)
        end
      elsif obj_exists && forceall
        # Since the user has given 'ya', remove existing targets
        # and replace them with the new targets
          force_create_symlink(symlink_src, symlink_dest)
      elsif !obj_exists
        # Since the symlink target does not already exist,
        # just create the symlink
        FileUtils.ln_s(symlink_src, symlink_dest, force: true)
      end
    end
  end

  # check if the particular command is supported
  def check_if_command_exists?(command)
    `which #{command}`
    $?.success?
  end

  # template method
  def setup
    unless command_exists?
      @info[:error_msg] = "command not found"
      return
    end

    puts "Preparing #{@info[:setup_name]} environment..."
    puts "  (if you provide no answer for anything 'y' will be considered the default)"
    puts

    unless File.directory?(DOTFILES_DIR)
      @info[:error_msg] = "can not find #{DOTFILES_DIR}"
      return
    end

    set_symlinks_targets
    create_symlinks_in_home
  end
end

# Concrete strategy class
class BashSetup < Env
  def initialize
    super
    info[:setup_name] = "bash"
  end

  def command_exists?
    check_if_command_exists?("bash")
  end

  def set_symlinks_targets
    ['.bashrc', '.bash_profile', '.bash_logout', '.inputrc', '.bash'].each do |e|
      symlinks_targets.push(e)
    end
  end

end

# Concrete strategy class
class ZshSetup < Env
  def initialize
    super
    info[:setup_name] = "zsh"
  end

  def command_exists?
    check_if_command_exists?("zsh")
  end

  def set_symlinks_targets
  end
end

# Concrete strategy class
class VimSetup < Env
  def initialize
    super
    info[:setup_name] = "vim"
  end

  def command_exists?
    check_if_command_exists?("vim")
  end

  def set_symlinks_targets
  end
end

class SetupEnv
  attr_accessor :setup_target

  def initialize(setup_target)
    @setup_target = setup_target
  end

  def setup_env
    @setup_target.setup
  end

end

setup = SetupEnv.new(BashSetup.new)
setup.setup_env
