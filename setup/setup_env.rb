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

  def get_distro
    if command_exists?('lsb_release')
      `lsb_release -si`
    else
      "no_distro"
    end
  end

  # clone a repo from github and returns true on success, false otherwise
  def github_clone?(*repo_info)
    unless command_exists?("git")
      puts "Can't find git, install git first.."
      false
    else
      github_repo_src = "https://github.com/#{repo_info.shift}"
      github_repo_dest = repo_info.shift

      print "Cloning from #{github_repo_src} "

      # creates thread to clone from github repository
      clone_thread = Thread.new do
        if github_repo_dest.nil?
          `git clone #{github_repo_src} >/dev/null 2>&1`
        else
          `git clone #{github_repo_src} #{github_repo_dest} >/dev/null 2>&1`
        end
      end

      while clone_thread.alive?
        sleep 1
        print "."
      end
      clone_thread.join

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

  # create symbolic links from dotfiles to homedir
  def create_sym_links
    forceall, noforceall = false, false
    @syms.each do |sym|
      sym_src, sym_dest = "#{DOTFILES_DIR}/#{sym}", "#{HOME_DIR}/#{sym}"
      unless sym_exists?(sym_src)
        abort "#{sym_src} doesn't exist. Consider downloading dotfiles again.."
      else

        if forceall
          puts "Forcefully creating symbolic link #{sym_dest}"
        elsif noforceall
          puts "Skip creating symbolic link #{sym_dest}"
        else
          puts "Creating symbolic link #{sym_dest}"
        end

        if sym_exists?(sym_dest)
          # if the symlink exists
          unless noforceall
            begin
              unless forceall
                print "  Replace #{sym_dest} with #{sym_src} (y|n|ya|na) ? "
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
    puts
    puts "Setting up bash environment"
    puts "==========================="
    puts
    puts "Checking for dotfiles .."
    download_dotfiles

    puts
    puts "Creating symbolic links .."
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
        FileUtils.ln_s("#{OH_MY_ZSH_DIR}/custom/template/.zshrc",
                       "#{ENV['HOME']}/.zshrc", :force => true)
      rescue Exception => e
        abort "oops! failed to create symlink. #{e.message}"
      end
    else
      abort "#{OH_MY_ZSH_DIR}/custom/template/.zshrc doesn't exist."
    end
  end

  # setup the zsh environment
  def setup_env
    puts
    puts "Setting up zsh environment"
    puts "=========================="

    puts
    puts "Checking for oh-my-zsh .."
    download_ohmyzsh_fork

    puts
    puts "Creating .zshrc .."
    create_zshrc
  end
end

class VimSetup < Env
  def initialize
    super
    %w(.vimrc .gvimrc).each { |e| syms.push e }
  end

  def check_for_vim
    abort "vim doesn't exist.\nInstall vim first.." unless command_exists?("vim")
  end

  # download bundles that are in the .vimrc file
  def download_bunldes
    forceall, noforceall, bundle_found = false, false, false
    bundle_root = "#{ENV['HOME']}/.vim/bundle"

    # create bundle dir if it doesn't exist
    unless File.directory?(bundle_root)
      begin
        FileUtils.mkdir_p(bundle_root)
      rescue
        puts "Can't create #{bundle_root}"
      end
    end

    # read .vimrc and install the bundles
    File.readlines("#{ENV['HOME']}/.vimrc").each do |line|
      # NOTE: the following regex needs Ruby version >= 1.9.2
      if /^Bundle ('|")(?<repo>.*)\/(?<bundle>.*)('|")/ =~ line
        bundle_found = true
        bundle_dir_name = "#{bundle_root}/#{bundle}"
        if File.directory?(bundle_dir_name)
          unless noforceall
            unless forceall
              print "#{bundle_dir_name} exists.\nReinstall #{bundle} (y|n|ya|na) ? "
              reply = gets.chomp.downcase
              forceall = true if reply == 'ya'
              noforceall = true if reply == 'na'
            end
            if reply == 'y' || forceall
              begin
                FileUtils.rm_r(bundle_dir_name)
                unless github_clone?("#{repo}/#{bundle}", "#{bundle_dir_name}")
                  abort "Failed to download #{repo}/#{bundle}"
                end
                puts
              rescue
                abort "error redownloading #{repo}/#{bundle}"
              end
            end
          end
        else
          puts "Downloading #{bundle_dir_name}"
          unless github_clone?("#{repo}/#{bundle}", "#{bundle_dir_name}")
            abort "Failed to download #{repo}/#{bundle}"
          end
          puts
        end
      end
    end
    puts "No bundles found in #{ENV['HOME']}/.vimrc" unless bundle_found
  end

  # creates a symlink in bundle/autoload directory to pathogen
  def setup_pathogen
    autoload_dir, pathogen_dir = "#{ENV['HOME']}/.vim/autoload", "#{ENV['HOME']}/.vim/bundle/vim-pathogen"
    begin
      unless File.directory?(pathogen_dir)
        puts "pathogen doesn't exist in bundle directory\nTry to install pathogen first.."
      else
        unless File.directory?(autoload_dir)
          FileUtils.mkdir_p(autoload_dir)
        end
        FileUtils.ln_s("#{pathogen_dir}/autoload/pathogen.vim", "#{autoload_dir}/pathogen.vim", :force => true)
      end
    rescue
      abort "Failed to setup pathogen properly."
    end
  end

  # setup vim environment
  def setup_env
    puts
    puts "Setting up vim environment"
    puts "=========================="
    puts
    puts "Checking for dotfiles .."
    download_dotfiles

    puts
    puts "Checkinfg for vim .."
    check_for_vim

    puts
    puts "Creating symlinks .."
    create_sym_links

    puts
    puts "Downloading bundles .."
    download_bunldes

    puts
    puts "Setting up pathogen .."
    setup_pathogen
  end
end

class IrbEnv < Env
  def initialize
    super
    %w(.irbrc).each { |e| syms.push e }
  end

  def install_gems_for_irb
    `sudo gem install wirble hirb awesome_print --no-rdoc --no-ri`
  end

  def setup_env
    puts
    puts "Setting irb"
    puts "==========="

    puts
    puts "Installing necessary gems for irb .."
    install_gems_for_irb

    puts
    puts "Creating symbolic links .."
    create_sym_links
  end
end

class TmuxEnv < Env
  def initialize
    super
    %w(.tmux.conf).each { |e| syms.push e }
  end

  def install_tmux
    case get_distro
    when /Ubuntu|Debian/
      `sudo apt-get install tmux -y`
    when /Fedora|RedHat/
      `sudo yum install tmux -y`
    else
      abort "Can't install tmux, because the OS can't be identified."
    end
  end

  def install_tmuxinator
    `sudo gem install tmuxinator --no-rdoc --no-ri`
  end

  def setup_env
    puts
    puts "Setting tmux"
    puts "============"

    puts
    puts "Creating symbolic links .."
    create_sym_links

    puts
    puts "Install tmuxinator"
    install_tmuxinator
  end
end

class AckEnv < Env
  def initialize
    super
    %w(.ackrc).each { |e| syms.push e }
  end

  def install_ack
    case get_distro
    when /Ubuntu|Debian/
      `sudo apt-get install ack-grep -y`
    when /Fedora|RedHat/
      `sudo yum install ack -y`
    else
      abort "Can't install ack, because the OS can't be identified."
    end
  end

  def setup_env
    puts
    puts "Setting ackrc"
    puts "============="

    puts
    puts "Install ack .."
    install_ack

    puts
    puts "Creating symbolic links .."
    create_sym_links
  end
end

class ColorDiffEnv < Env
  def initialize
    super
    %w(.colordiffrc).each { |e| syms.push e }
  end

  def install_colordiff
    case get_distro
    when /Ubuntu|Debian/
      `sudo apt-get install colordiff -y`
    when /Fedora|RedHat/
      `sudo yum install colordiff -y`
    else
      abort "Can't install colordiff, because the OS can't be identified."
    end
  end

  def setup_env
    puts
    puts "Setting colordiff"
    puts "================="

    puts
    puts "Install colordiff .."
    install_colordiff

    puts
    puts "Creating symbolic links .."
    create_sym_links
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
reply = ""
begin
  puts
  puts " 1. Setup Zsh Environment"
  puts " 2. Setup Bash Environment"
  puts " 3. Setup Vim Environment"
  puts " 4. Setup Irb Environment"
  puts " 5. Setup Tmux Environment"
  puts " 6. Setup Ack Environment"
  puts " 7. Setup Colordiff Environment"
  puts
  puts " Q. Quit"
  puts
  print " Choice ? "
  reply = gets.chomp.downcase

  unless %w(quit q).include?(reply)
    case reply
    when "1"
      SetupEnv.new(ZshSetup.new).setup
    when "2"
      SetupEnv.new(BashSetup.new).setup
    when "3"
      SetupEnv.new(VimSetup.new).setup
    when "4"
      SetupEnv.new(IrbEnv.new).setup
    when "5"
      SetupEnv.new(TmuxEnv.new).setup
    when "6"
      SetupEnv.new(AckEnv.new).setup
    when "7"
      SetupEnv.new(ColorDiffEnv.new).setup
    else
      puts " Bad Choice.."
    end
  end
end while not %w(quit q).include?(reply)
