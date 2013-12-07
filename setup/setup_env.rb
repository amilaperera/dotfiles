#!/usr/bin/env ruby
# encoding: utf-8

# Env class is a strategy base class
class Env
  attr_accessor :info

  HOME_DIR = ENV['HOME']
  DOTFILES_DIR = "#{HOME_DIR}/.dotfiles"

  def initialize
    @info = { setup_name: "", error_msg: "" }
  end

  # check if the particular command is supported
  def check_if_command_exists?(command)
    `which #{command}`
    $?.success?
  end

  # template method
  def setup
    unless command_exists? { @info[:error_msg] = "command not found"; return }

    puts "Preparing #{@info[:setup_name]} environment..."

    unless File.directory?(DOTFILES_DIR)
      @info[:error_msg] = "can not find #{DOTFILES_DIR}"
      return
    end

    make_symlinks
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

  def make_symlinks
    File.symlink("#{Env::DOTFILES_DIR}/.bashrc", "#{HOME_DIR}/.bashrc")
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

  def make_symlinks
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
end

class SetupEnv
  attr_accessor :setup_target

  def initialize(setup_target)
    @setup_target = setup_target
  end

  def setup_env
    @setup_target.setup
  end

  def make_symlinks
  end
end

setup = SetupEnv.new(BashSetup.new)
setup.setup_env
