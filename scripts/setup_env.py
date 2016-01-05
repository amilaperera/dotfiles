#!/usr/bin/env python
# -*- coding: utf-8 -*-

#
#  TODO:
#  1. Currently almost all the exceptions are of OSError type. Consider changing them
#     appropriately to other types, if necessary.
#

from __future__ import print_function
import argparse
import os
import platform
import shutil
import subprocess
import sys
import time
import threading
import re
from colorama import Fore, Back, Style, init

class Env(object):
    """Environment setup base class"""

    # class variable
    # git command
    git_cmd = None

    def __init__(self, args):
        self.set_install_dir(args)
        self.set_setup_env_name(args)

    @staticmethod
    def check_for_git_cmd():
        # search the PATH and check if 'git' command is available
        git_executable = None
        split_regex = '[;]' if Env.is_windows() else '[:]'
        for dir in re.split(split_regex, os.environ['PATH']):
            git_executable = os.path.join(dir, 'git.exe' if Env.is_windows() else 'git')
            if os.path.exists(git_executable):
                break
            else:
                git_executable = None

        # if we can't find 'git' in the PATH just raise and exception and terminate the program
        if git_executable is None:
            raise OSError('Could not find the git executable in PATH')
        else:
            Env.git_cmd = git_executable
            print('git executable is found at {}'.format(Env.git_cmd))

    @staticmethod
    def get_platform_name():
        return sys.platform.lower()

    @staticmethod
    def is_windows():
        return sys.platform.startswith('win')

    @staticmethod
    def is_linux():
        return Env.get_platform_name().startswith('linux') or Env.get_platform_name().startswith('cygwin')

    @staticmethod
    def get_env_name():
        if Env.is_linux():
            return 'Linux'
        elif Env.is_windows():
            return 'Windows'
        else:
            # NOTE: add these as necessary for different environments
            raise OSError('unknown os detected')

    @staticmethod
    def get_welcome_msg(setup_str):
        return 'Setting up {} environment on {}...'.format(setup_str, Env.get_env_name())

    @staticmethod
    def get_home_env_var():
        if Env.is_linux():
            return 'HOME'
        elif Env.is_windows():
            return 'USERPROFILE'
        else:
            raise OSError('unknown user variable')

    @staticmethod
    def print_with_sleep(str):
        sys.stdout.write(str)
        sys.stdout.flush()
        time.sleep(0.20)

    @staticmethod
    def animate_progress_rotation():
        Env.print_with_sleep('-')
        Env.print_with_sleep('\b\\')
        Env.print_with_sleep('\b|')
        Env.print_with_sleep('\b/')
        Env.print_with_sleep('\b-')
        Env.print_with_sleep('\b\\')
        Env.print_with_sleep('\b|')
        Env.print_with_sleep('\b/')
        Env.print_with_sleep('\b.')

    @staticmethod
    def clone_thread(repo, dest):
        git_command_list = [Env.git_cmd, 'clone', repo]
        if dest is not None:
            git_command_list.append(dest)

        with open(os.devnull, 'w') as devnull:
            subprocess.check_call(git_command_list, stdout=devnull, stderr=subprocess.STDOUT)

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
            # if destination is None we get the default directory suggested by git
            dest = os.path.join(os.getcwd(), repo.rstrip('/').split('/')[-1])

        if os.path.isdir(dest):
            print('Destination directory [{}] not empty'.format(dest), file=sys.stderr)
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
            print('Repository [{}] is invalid'.format(repo), file=sys.stderr)
            return False

        return True

    @staticmethod
    def clone_repo(**kwargs):
        if Env.is_cloneable(**kwargs):
            repo, dest = kwargs.get('repo'), kwargs.get('dest')
            print('Cloning from repository ', end='')
            print(Style.BRIGHT + '{} '.format(repo), end='')
            repo_clone_thread = threading.Thread(target=Env.clone_thread, args=(repo, dest))
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

    def set_install_dir(self, args):
        if args.dir is None:
            self.install_dir = Env.get_home()
        else:
            abs_path = os.path.abspath(args.dir)
            if os.path.isdir(abs_path):
                self.install_dir = abs_path
            else:
                raise OSError('install directory[{}] does not exist'.format(abs_path))

    def set_setup_env_name(self, args):
        self.setup_env_name = args.env.title()

    def get_setup_env_name(self):
        return self.setup_env_name

    def get_install_dir(self):
        return self.install_dir

    def raise_exception_if_windows(self):
        if Env.is_windows():
            raise OSError('{} environment can not be setup in this OS'.format(self.get_setup_env_name()))

    # check if setup can be carried out for the current OS
    # In general derived class should reimplement this method
    def check_for_os_validity(self):
        pass

    # carry out common settings for all the environments
    def setup_common_env(self):
        print(Fore.CYAN + Env.get_welcome_msg(self.setup_env_name))
        Env.check_for_git_cmd()

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


class ZshEnv(Env):
    """Zsh environment setup class"""

    def __init__(self, args):
        super(ZshEnv, self).__init__(args)

    def check_for_os_validity(self):
        self.raise_exception_if_windows()


class BashEnv(Env):
    """Bash environment setup class"""

    def __init__(self, args):
        super(BashEnv, self).__init__(args)

    def check_for_os_validity(self):
        self.raise_exception_if_windows()


class VimEnv(Env):
    """Vim environment setup class"""

    def __init__(self, args):
        super(VimEnv, self).__init__(args)

    @staticmethod
    def get_vimrc_file_name():
        if Env.is_linux():
            return '.vimrc'
        elif Env.is_windows():
            return '_vimrc'
        else:
            return None

    def _set_vimrc_files(self):
        home_path = self.get_install_dir()
        print('Copying vimrc files to {}'.format(home_path))
        for f in ('.vimrc', '.gvimrc'):
            if Env.is_windows():
                # copy .vimrc & .gvimrc files as _vimrc and _gvimrc files respectively
                # to the $HOME folder
                shutil.copy(os.path.join('../', f),
                        os.path.join(home_path, '_' + f.split('.')[1]))
            elif Env.is_linux():
                # create a link to .vimrc & .gvimrc files in the home directory
                os.symlink(os.path.abspath(os.path.join('../', f)),
                        os.path.join(home_path, f))
            else:
                raise OSError('unknown os detected')

    def _install_vim_plugins(self):
        plugin_path = os.path.join(self.get_install_dir(), os.path.join('.vim', 'bundle'))
        if not os.path.isdir(plugin_path):
            os.makedirs(plugin_path)
        os.chdir(plugin_path)

        print('Installing vim plugins to {}'.format(plugin_path))
        p = re.compile('^Plugin +[\'\"](?P<plugin>[^\'\"]*)[\'\"]')
        with open(os.path.join(self.get_install_dir(), VimEnv.get_vimrc_file_name())) as fh:
            for line in fh.readlines():
                res = p.match(line)
                if res:
                    Env.clone_repo(**dict(repo='https://github.com/' + res.group('plugin')))

    def setup_env(self):
        self._set_vimrc_files()
        self._install_vim_plugins()


class MiscEnv(Env):
    """Misc environment setup class"""

    def __init__(self, args):
        super(MiscEnv, self).__init__(args)

    def check_for_os_validity(self):
        self.raise_exception_if_windows()

def main():
    parser = argparse.ArgumentParser(description='Set up the environment')
    parser.add_argument('-e', '--env',
                        choices=['zsh', 'bash', 'vim', 'misc'],
                        help='sets up the specified environment')
    parser.add_argument('-d', '--dir',
                        help='install directory')
    args = parser.parse_args()

    if args.env == 'zsh':
        ZshEnv(args).setup()
    elif args.env == 'bash':
        BashEnv(args).setup()
    elif args.env == 'vim':
        VimEnv(args).setup()
    elif args.env == 'misc':
        MiscEnv(args).setup()
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
        print(Fore.RED +'{}'.format(e))

