require 'fileutils'

class Env
  attr_accessor :syms

  HOME_DIR = ENV['HOME']
  DOTFILES_DIR = "#{ENV['HOME']}/.dotfiles"

  def initialize
    @syms = [ ]
  end

  # checks if a command exists
  def command_exists?(name)
    `which #{name}`
    $?.success?
  end

  # clone a repo from github and returns true on success, false otherwise
  def github_clone?(*repo_info)
    unless command_exists?("git")
      puts "Can't find git, install git first.."
      false
    else
      github_repo_src = "https://github.com/#{repo_info.shift}"
      github_repo_dest = repo_info.shift
      puts "Cloning from #{github_repo_src}"
      if github_repo_dest.nil?
        `git clone #{github_repo_src}`
      else
        `git clone #{github_repo_src} #{github_repo_dest}`
      end
      $?.success?
    end
  end

  # check if the name sym exists as a file, a directory or a symlink
  def sym_exists?(sym)
    File.exists?(sym) || File.directory?(sym) || File.symlink?(sym)
  end

  # forces a symlink of name 'sym_dest' to be created even if a file, directory or
  # a symlink with the same name already exists
  def force_symlink_create(sym_src, sym_dest)
    if File.directory?(sym_dest)
      sym_dest = "#{File.dirname(sym_dest)}/."
    end
    FileUtils.ln_s(sym_src, sym_dest, :force => true)
  end

  # downlaod dotfiles if the $HOME/.dotfiles directory doesn't exist
  def download_dotfiles
    unless File.directory? "#{HOME_DIR}/.dotfiles"
      puts "dotfiles do not exist in #{HOME_DIR}"
      puts "Trying to download dotfiles"
      unless github_clone?("amilaperera/dotfiles")
        abort "Failed to download dotfiles."
      else
        puts "Successfully downloaded dotfiles."
      end
    end
  end

  # create symbolic links
  def create_sym_links
    forceall, noforceall = false, false
    @syms.each do |sym|
      sym_src, sym_dest = "#{DOTFILES_DIR}/#{sym}", "#{HOME_DIR}/#{sym}"
      unless sym_exists?(sym_src)
        abort "#{sym_src} doesn't exist. Consider downloading dotfiles again.."
      else
        if sym_exists?(sym_dest)
          # if the symlink exists
          unless noforceall
            begin
              unless forceall
                print "Replace #{sym_dest} with #{sym_src} (y|n|ya|na) ? "
                reply = gets.chomp.downcase
                forceall = true if reply == 'ya'
                noforceall = true if reply == 'na'
              end
              # create a symlink forcefully
              force_symlink_create(sym_src, sym_dest) if reply == 'y' || forceall
            rescue Exception => e
              abort "oops! symlink exists..failed to create symlink. #{e.message}"
            end
          end
        else
          # if the symlink does not exist
          begin
            FileUtils.ln_s(sym_src, sym_dest)
          rescue Exception => e
            abort "oops! failed to create symlink. #{e.message}"
          end
        end
      end
    end
  end
end

# Bash setup
class BashSetup < Env
  def initialize
    super
    %w(.bashrc .bash_profile .bash_logout .bash .inputrc).each { |e| syms.push e }
  end

  # setup the bash environment
  def setup_env
    puts "Checking for dotfiles.."
    download_dotfiles

    puts
    puts "Creating symbolic links.."
    create_sym_links
  end
end

# ZShell setup
class ZshSetup < Env
  OH_MY_ZSH_DIR = "#{ENV['HOME']}/.oh-my-zsh"

  def initialize
    super
    %w(.zshrc).each { |e| syms.push e }
  end

  # download personal oh-my-zsh fork
  def download_ohmyzsh_fork
    if File.directory?(OH_MY_ZSH_DIR)
      puts "#{OH_MY_ZSH_DIR} already exists.."
      print "Remove directory and reinstall (y|n) ? "
      if %w(yes y).include?(gets.chomp.downcase)
        begin
          FileUtils.rm_r(OH_MY_ZSH_DIR, :force => true)
          unless github_clone?("amilaperera/oh-my-zsh", OH_MY_ZSH_DIR)
            abort "Failed to download .oh-my-zsh"
          end
        rescue
          abort "error in reinstalling #{OH_MY_ZSH_DIR}"
        end
      end
    else
      puts "Downloading oh-my-zsh"
      unless github_clone?("amilaperera/oh-my-zsh", OH_MY_ZSH_DIR)
        abort "Failed to download .oh-my-zsh"
      end
    end
  end

  # create .zshrc file
  def create_zshrc
    if File.exists?("#{OH_MY_ZSH_DIR}/custom/template/.zshrc")
      begin
        FileUtils.ln_s("#{OH_MY_ZSH_DIR}/custom/template/.zshrc", "#{ENV['HOME']}/.zshrc", :force => true)
      rescue Exception => e
        abort "oops! failed to create symlink. #{e.message}"
      end
    else
      abort "#{OH_MY_ZSH_DIR}/custom/template/.zshrc doesn't exist."
    end
  end

  # setup the zsh environment
  def setup_env
    puts "Checking for oh-my-zsh"
    download_ohmyzsh_fork

    puts
    puts "Creating .zshrc"
    create_zshrc
  end
end

class VimSetup < Env
  def initialize
    super
    %w(.vimrc .gvimrc).each { |e| syms.push e }
  end

  # setup vim environment
  def setup_env
    
  end
end

class SetupEnv
  attr_accessor :setup_env

  def initialize(setup)
    @setup_env = setup
  end

  def setup
    @setup_env.setup_env
  end
end

# main program
my_env = SetupEnv.new(ZshSetup.new)
my_env.setup
