#!/usr/bin/env python
# -*- coding: utf-8 -*-

#
#  TODO:
#  1. Currently almost all the exceptions are of OSError type.
#     Consider changing them
#     appropriately to other types, if necessary.
#

import argparse
import os, errno
import shutil
import subprocess
import sys
import time
import threading
import re
from colorama import Fore, Style, init
import requests

class Env(object):
    """Environment setup base class"""

    # class variable
    # git command
    git_cmd = None

    def __init__(self, args, title, cf):
        self.install_dir = args.dir
        self.setup_env_name = title.title()
        self.config_files = cf

    @staticmethod
    def set_git_executable(args):
        git_executable = None

        if args.path is not None:
            if not os.path.isfile(args.path):
                raise OSError('Can not find the specified path - {}'
                              .format(args.path))
            else:
                git_executable = args.path
        else:
            # search the PATH and check if 'git' command is available
            split_regex = Env.path_split_regex()
            git_exe = Env.git_cmd_name()
            for directory in re.split(split_regex, os.environ['PATH']):
                git_executable = os.path.join(directory, git_exe)
                if os.path.exists(git_executable):
                    break
                else:
                    git_executable = None

        # if we can't find 'git' in the PATH
        # just raise an exception and terminate the program
        if git_executable is None:
            raise OSError('Can not find the git executable in PATH\n'
                          'Try using \'-p\' option to '
                          'set the path of the git executable')
        else:
            Env.git_cmd = git_executable

    @staticmethod
    def get_platform_name():
        return sys.platform.lower()

    @staticmethod
    def is_windows():
        return sys.platform.startswith('win')

    @staticmethod
    def is_linux():
        return (Env.get_platform_name().startswith('linux')
                or Env.get_platform_name().startswith('cygwin'))

    @staticmethod
    def path_split_regex():
        return '[;]' if Env.is_windows() else '[:]'

    @staticmethod
    def git_cmd_name():
        name = 'git'
        if Env.is_windows():
            name += '.exe'
        return name

    @staticmethod
    def get_env_name():
        if Env.is_linux():
            return 'Linux'
        elif Env.is_windows():
            return 'Windows'
        else:
            return 'Unkown OS'

    @staticmethod
    def get_welcome_msg(setup_str):
        return ('Setting up {} environment on {}...'
                .format(setup_str, Env.get_env_name()))

    @staticmethod
    def get_home_env_var():
        if Env.is_windows():
            return 'USERPROFILE'
        else:
            return 'HOME'

    @staticmethod
    def print_with_sleep(msg):
        sys.stdout.write(msg)
        sys.stdout.flush()
        time.sleep(0.20)

    @staticmethod
    def back_and_print_with_sleep(msg):
        Env.print_with_sleep('\b' + msg)

    @staticmethod
    def animate_progress_rotation():
        Env.print_with_sleep('-')
        Env.back_and_print_with_sleep('\\')
        Env.back_and_print_with_sleep('|')
        Env.back_and_print_with_sleep('/')
        Env.back_and_print_with_sleep('-')
        Env.back_and_print_with_sleep('\\')
        Env.back_and_print_with_sleep('|')
        Env.back_and_print_with_sleep('/')
        Env.back_and_print_with_sleep('.')

    @staticmethod
    def clone_thread(repo, dest):
        git_command_list = [Env.git_cmd, 'clone', repo]
        if dest is not None:
            git_command_list.append(dest)

        with open(os.devnull, 'w') as devnull:
            subprocess.check_call(git_command_list, stdout=devnull,
                                  stderr=subprocess.STDOUT)

    @staticmethod
    def is_cloneable(**kwargs):
        # prevent git from asking password for bad urls
        new_env = os.environ.copy()
        new_env['GIT_ASKPASS'] = 'true'

        repo, dest = kwargs.get('repo'), kwargs.get('dest')
        if repo is None:
            print('Repository[{}] is invalid'.format(repo), file=sys.stderr)
            return False

        if dest is None:
            # if destination is None,
            # we use the default directory suggested by git
            dest = os.path.join(os.getcwd(), repo.rstrip('/').split('/')[-1])

        if os.path.isdir(dest):
            print('Destination directory[{}] not empty'.format(dest),
                  file=sys.stderr)
            return False

        try:
            # we check if the remote repository is valid.
            # if it is invalid git ls-remote <url> would return error status,
            # causing subprocess.Popen() to throw an exception
            with open(os.devnull, 'w') as devnull:
                subprocess.Popen([Env.git_cmd, 'ls-remote', repo],
                                 stdout=devnull, stderr=subprocess.STDOUT,
                                 env=new_env)
        except:
            print('Repository[{}] is invalid'.format(repo), file=sys.stderr)
            return False

        return True

    @staticmethod
    def clone_repo(**kwargs):
        if Env.is_cloneable(**kwargs):
            repo, dest = kwargs.get('repo'), kwargs.get('dest')
            print('Cloning from repository ', end='')
            print(Style.BRIGHT + '{} '.format(repo), end='')
            repo_clone_thread = threading.Thread(target=Env.clone_thread,
                                                 args=(repo, dest))
            repo_clone_thread.start()

            while repo_clone_thread.is_alive():
                Env.animate_progress_rotation()
            print(Fore.GREEN + '[done]')
        else:
            print('Aborting repository cloning')

    @staticmethod
    def get_home():
        home = os.environ[Env.get_home_env_var()]
        if home in ('', None):
            raise OSError('HOME environment variable is not set')
        return home

    @staticmethod
    def dot_dir():
       local_dot_dir = os.path.join(Env.get_home(), '.dotfiles')
       if os.path.isdir(local_dot_dir):
           return local_dot_dir
       else:
           raise OSError('dot directory does not exist in {}'.format(local_dot_dir))

    @staticmethod
    def scripts_dir():
       local_scripts_dir = os.path.join(Env.get_home(), '.dotfiles', 'scripts')
       if os.path.isdir(local_scripts_dir):
           return local_scripts_dir
       else:
           raise OSError('dot directory does not exist in {}'.format(local_scripts_dir))

    @staticmethod
    def src_to_dest_message(msg, src, dest):
        print(msg, end='')
        print(' (', end='')
        print(Style.BRIGHT + '{}'.format(src), end='')
        print(' --> ', end='')
        print(Fore.YELLOW + '{}'.format(dest), end='')
        print(')...', end='')
        print(Fore.GREEN + '[done]')

    @staticmethod
    def create_directory_if_not_exists(dir_name):
        if not os.path.exists(dir_name):
            os.makedirs(dir_name)
            print('Creating directory: ', end='')
            print(Fore.YELLOW + '{}'.format(dir_name), end='')
            print('...', end='')
            print(Fore.GREEN + '[done]')

    @staticmethod
    def create_symlink(src, dest):
        try:
            os.symlink(src, dest)
        except OSError as e:
            if e.errno == errno.EEXIST:
                os.remove(dest)
                os.symlink(src, dest)
        Env.src_to_dest_message('Creating sym link', src, dest)

    @staticmethod
    def copy_file(src, dest):
        shutil.copy(src, dest)
        Env.src_to_dest_message('Copying file', src, dest)

    @property
    def install_dir(self):
        return self._install_dir

    @install_dir.setter
    def install_dir(self, value):
        if value is None:
            self._install_dir = Env.get_home()
        else:
            abs_path = os.path.abspath(value)
            if os.path.isdir(abs_path):
                self._install_dir = abs_path
            else:
                raise OSError('Install directory[{}] does not exist'
                              .format(abs_path))
        print('Install Dir: {}'.format(self._install_dir))

    @property
    def setup_env_name(self):
        return self._setup_env_name

    @setup_env_name.setter
    def setup_env_name(self, value):
        self._setup_env_name = value

    @property
    def config_files(self):
        return self._config_files

    @config_files.setter
    def config_files(self, value):
        self._config_files = value

    def raise_if_not_linux_or_win(self):
        if not Env.is_linux() and not Env.is_windows():
            raise OSError('{} environment can not be setup on {}'
                          .format(self.setup_env_name,
                                  Env.get_env_name()))

    def raise_if_not_linux(self):
        if not Env.is_linux():
            raise OSError('{} environment can not be setup on {}'
                          .format(self.setup_env_name,
                                  Env.get_env_name()))

    # check if setup can be carried out for the current OS
    # In general derived class should reimplement this method
    def check_for_os_validity(self):
        pass

    # carry out common settings for all the environments
    def setup_common_env(self):
        print(Fore.CYAN + Env.get_welcome_msg(self.setup_env_name))

    # base class specific setup.
    # In general derived class should reimplement this method
    def setup_env(self):
        pass

    # template method
    def setup(self):
        # check if setup can be carried out for the current OS
        self.check_for_os_validity()
        # carry out setup required for all the environments
        self.setup_common_env()
        # carry out environment specific setup
        # derived classes should reimplement this method
        self.setup_env()
        # just leave a blank line after the setup method
        print()


class ZshEnv(Env):
    """Zsh environment setup class"""

    local_oh_my_zsh_ref_dir_name = '.oh-my-zsh'
    local_zshrc_ref_path = os.path.join(local_oh_my_zsh_ref_dir_name,
                                        'custom',
                                        'templates',
                                        '.zshrc')

    def __init__(self, args):
        cf = ('.zshrc',)
        super(ZshEnv, self).__init__(args, 'zsh', cf)

    def check_for_os_validity(self):
        self.raise_if_not_linux()

    def _download_oh_my_zsh(self):
        repo_value = 'https://github.com/amilaperera/ohmyzsh'
        dest_value = os.path.join(self.install_dir,
                                  ZshEnv.local_oh_my_zsh_ref_dir_name)
        Env.clone_repo(**dict(repo=repo_value, dest=dest_value))

    def _create_zshrc_symlinks(self):
        for config_file in self.config_files:
            Env.create_symlink(os.path.join(self.install_dir,
                                            ZshEnv.local_zshrc_ref_path),
                               os.path.join(self.install_dir, config_file))

    def setup_env(self):
        self._download_oh_my_zsh()
        self._create_zshrc_symlinks()


class BashEnv(Env):
    """Bash environment setup class"""

    def __init__(self, args):
        cf = ('.bash',
              '.bashrc',
              '.bash_profile',
              '.bash_logout',
              '.inputrc')
        super(BashEnv, self).__init__(args, 'bash', cf)

    def check_for_os_validity(self):
        self.raise_if_not_linux()

    def _create_bash_symlinks(self):
        for config_file in self.config_files:
            Env.create_symlink(os.path.abspath(os.path.join('../',
                                                            config_file)),
                               os.path.join(self.install_dir, config_file))

    def setup_env(self):
        self._create_bash_symlinks()


class VimEnv(Env):
    """Vim environment setup class"""

    def __init__(self, args):
        cf = ('.vimrc', '.gvimrc')
        super(VimEnv, self).__init__(args, 'vim', cf)

    def check_for_os_validity(self):
        self.raise_if_not_linux_or_win()

    def _set_config_files(self):
        home_path = self.install_dir
        print('Copying vimrc files to {}'.format(home_path))
        for config_file in self.config_files:
            if Env.is_windows():
                # copy .vimrc & .gvimrc files as
                # _vimrc and _gvimrc files respectively to the $HOME folder
                Env.copy_file(os.path.join('../', config_file),
                              os.path.join(home_path,
                                           '_' + config_file.split('.')[1]))
            else:
                # create a link to .vimrc & .gvimrc files in the home directory
                Env.create_symlink(os.path.abspath(os.path.join('../', config_file)),
                                   os.path.join(home_path, config_file))

    def _install_plugin_manager(self):
        target_file = os.path.expanduser('~/.vim/autoload/plug.vim')
        url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

        if Env.is_windows():
            target_file = os.path.expanduser('~/vimfiles/autoload/plug.vim')

        # create parent directory if not exists
        if not os.path.exists(os.path.dirname(target_file)):
            os.makedirs(os.path.dirname(target_file))

        resp = requests.get(url)
        with open(target_file, 'wb') as f:
            f.write(resp.content)

    def _install_plugins(self):
        if Env.is_windows():
            # TODO: ??
            pass
        else:
            with open(os.devnull, 'w') as devnull:
                subprocess.check_call(['vim', '+PlugInstall', '+qall'])

    def setup_env(self):
        self._set_config_files()
        self._install_plugin_manager()
        self._install_plugins()


class NeoVimEnv(Env):
    """NeoVim environment setup class"""

    def __init__(self, args):
        # alias .vimrc to ~/.config/nvim/init.vim
        cf = ('init.vim', 'ginit.vim')
        super(NeoVimEnv, self).__init__(args, 'vim', cf)

    def check_for_os_validity(self):
        self.raise_if_not_linux_or_win()

    def _set_config_files(self):
        home_path = self.install_dir
        print('Setting up config file')
        for config_file in self.config_files:
            if Env.is_windows():
                dest_dir = os.path.join(home_path, 'AppData', 'Local', 'nvim/')
                if not os.path.exists(dest_dir):
                    os.makedirs(dest_dir)
                Env.copy_file(os.path.join('../', config_file), os.path.join(dest_dir, config_file))
            else:
                # create a link to .vimrc & .gvimrc files in the home directory
                dest_dir = os.path.join(home_path, '.config', 'nvim/')
                if not os.path.exists(dest_dir):
                    os.makedirs(dest_dir)
                Env.create_symlink(os.path.abspath(os.path.join('../', config_file)),
                                   os.path.join(dest_dir, config_file))

    def _install_plugin_manager(self):
        target_file = os.path.expanduser('~/.local/share/nvim/site/autoload/plug.vim')
        url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

        if Env.is_windows():
            target_file = os.path.join(self.install_dir, 'AppData', 'Local', 'nvim-data', 'site', 'autoload', 'plug.vim')

        # create parent directory if not exists
        if not os.path.exists(os.path.dirname(target_file)):
            os.makedirs(os.path.dirname(target_file))

        resp = requests.get(url)
        with open(target_file, 'wb') as f:
            f.write(resp.content)

    def _install_plugins(self):
        nvim_found = False
        try:
            subprocess.call(["nvim", "--version"])
            with open(os.devnull, 'w') as devnull:
                subprocess.check_call(['nvim', '+PlugInstall', '+qall'])
        except OSError as e:
            if e.errno == errno.ENOENT:
                raise OSError("NeoVim not found. Please install neovim before running this")

    def setup_env(self):
        self._set_config_files()
        self._install_plugin_manager()
        self._install_plugins()


class MiscEnv(Env):
    """Misc environment setup class"""

    def __init__(self, args):
        cf = ('.tmux.conf',
              '.agignore',
              '.colordiffrc',
              '.gitconfig',
              '.cgdb')
        super(MiscEnv, self).__init__(args, 'misc', cf)

    def check_for_os_validity(self):
        self.raise_if_not_linux()

    def _create_misc_symlinks(self):
        for config_file in self.config_files:
            Env.create_symlink(os.path.abspath(os.path.join(Env.dot_dir(), config_file)),
                               os.path.join(self.install_dir, config_file))

    def setup_env(self):
        self._create_misc_symlinks()


class ToolsEnv(Env):
    """Tools environment setup class"""

    def __init__(self, args):
        cf = ('setup_env.py',
              'fork_sync.py',
              '.fork_sync.json',
              'svn-color.py',
              'post_installer.sh')
        super(ToolsEnv, self).__init__(args, 'tools', cf)

    def check_for_os_validity(self):
        self.raise_if_not_linux()

    def _create_tools_symlinks(self):
        Env.create_directory_if_not_exists(os.path.join(self.install_dir, 'tools'))

        for config_file in self.config_files:
            Env.create_symlink(os.path.abspath(os.path.join(Env.scripts_dir(), config_file)),
                               os.path.join(self.install_dir, 'tools', config_file))

    def setup_env(self):
        self._create_tools_symlinks()


def main():
    supported_env_targets = ['bash', 'zsh', 'vim', 'nvim', 'misc', 'tools']

    parser = argparse.ArgumentParser(description='Set up the environment')
    parser.add_argument('-e', '--env',
                        nargs='+',
                        required=True,
                        help='specifies target environments - ' + str(supported_env_targets))
    parser.add_argument('-p', '--path',
                        help='path for the git executable')
    parser.add_argument('-d', '--dir',
                        help='install directory')
    args = parser.parse_args()

    for env in args.env:
        if not env in supported_env_targets:
            print('Unsupported target environment found: ' + env)
            print('Supported target environments are ' + str(supported_env_targets))
            raise ValueError('invalid arguments')

    Env.set_git_executable(args)

    for env in args.env:
        if env == 'zsh':
            ZshEnv(args).setup()
        elif env == 'bash':
            BashEnv(args).setup()
        elif env == 'vim':
            VimEnv(args).setup()
        elif env == 'nvim':
            NeoVimEnv(args).setup()
        elif env == 'misc':
            MiscEnv(args).setup()
        elif env == 'tools':
            ToolsEnv(args).setup()
        else:
            pass

if __name__ == '__main__':
    try:
        # Initialize colorama
        # Automate sending reset sequences after each colored output
        init(autoreset=True)
        main()

    except Exception as e:
        print('Error: ', end='')
        print(Fore.RED + '{}'.format(e))

