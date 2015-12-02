#!/usr/bin/env python
# -*- coding: utf-8 -*-

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

class Env(object):
    """Environment setup base class"""
    def __init__(self):
        self.home = None

    def setup(self):
        pass

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
            return 'linux'
        elif Env.is_windows():
            return 'windows'
        else:
            # NOTE: add these as necessary for different environments
            raise OSError('unknown os detected')

    @staticmethod
    def get_setup_welcome_msg(setup_str):
        return 'Setting up {} environment on {}...'.format(setup_str, Env.get_env_name())

    @staticmethod
    def get_home_env_var():
        if Env.is_linux():
            return 'HOME'
        elif Env.is_windows():
            return 'USERPROFILE'
        else:
            raise('unknown user variable')

    def set_home(self, dir=None):
        if self.home is None or dir is not None:
            if (dir is not None):
                self.home = dir
            else:
                # vim usually looks for vimrc in HOME folder
                self.home = os.environ[Env.get_home_env_var()]
                if self.home in ('', None):
                    raise OSError('HOME environment variable is not set')

    def get_home(self):
        self.set_home()
        return self.home

    def _print_with_sleep(self, str):
        sys.stdout.write(str)
        sys.stdout.flush()
        time.sleep(0.20)

    def _animate_progress_rotation(self):
        self._print_with_sleep('-')
        self._print_with_sleep('\b\\')
        self._print_with_sleep('\b|')
        self._print_with_sleep('\b/')
        self._print_with_sleep('\b-')
        self._print_with_sleep('\b\\')
        self._print_with_sleep('\b|')
        self._print_with_sleep('\b/')
        self._print_with_sleep('\b.')

    def _clone_thread(self, repo, dest):
        git_cmd = ['git', 'clone', repo]
        if dest is not None:
            git_cmd.append(dest)

        with open(os.devnull, 'w') as devnull:
            subprocess.check_call(git_cmd, stdout=devnull,
                    stderr=subprocess.STDOUT)

    def _is_cloneable(self, **kwargs):
        # prevent git from asking password for bad urls
        new_env = os.environ.copy()
        new_env['GIT_ASKPASS'] = 'true'

        repo, dest = kwargs.get('repo'), kwargs.get('dest')
        if repo is None:
            print('repository is invalid', file=sys.stderr)
            return False

        if dest is None:
            # if destination is None we get the default directory suggested by git
            dest = os.path.join(os.getcwd(), repo.rstrip('/').split('/')[-1])

        if os.path.isdir(dest):
            print('destination directory not empty', file=sys.stderr)
            return False

        try:
            # we check if the remote repo is valid.
            # if it is invalid git ls-remote <url> would return error status,
            # causing subprocess.Popen() to throw an exception
            with open(os.devnull, 'w') as devnull:
                subprocess.Popen(['git', 'ls-remote', repo],
                        stdout=devnull, stderr=subprocess.STDOUT,
                        env=new_env)
        except:
            print('repository is invalid', file=sys.stderr)
            return False

        return True

    def clone_repo(self, **kwargs):
        if self._is_cloneable(**kwargs):
            repo, dest = kwargs.get('repo'), kwargs.get('dest')
            print('cloning from repository {} '.format(repo), end='')
            clone_thread = threading.Thread(target=self._clone_thread, args=(repo, dest))
            clone_thread.start()

            while clone_thread.is_alive():
                self._animate_progress_rotation()
            print('[done]')
        else:
            print('aborting repository cloning')

class ZshEnv(Env):
    """Zsh environment setup class"""

    def __init__(self):
        pass

    def setup(self):
        args = dict(
                repo='https://github.com/amilaperera/dotfiles',
                )
        self.clone_repo(**args)

class BashEnv(Env):
    """Bash environment setup class"""

    def __init__(self):
        pass

class VimEnv(Env):
    """Vim environment setup class"""

    def __init__(self):
        super(VimEnv, self).__init__()

    @staticmethod
    def get_vimrc_file_name():
        if Env.is_linux():
            return '.vimrc'
        elif Env.is_windows():
            return '_vimrc'
        else:
            return None

    def _set_vimrc_files(self):
        home_path = self.get_home()
        print('copying vimrc files to {}'.format(home_path))
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
        plugin_path = os.path.join(self.get_home(), os.path.join('.vim', 'bundle'))
        if not os.path.isdir(plugin_path):
            os.makedirs(plugin_path)
        os.chdir(plugin_path)

        print('installing vim plugins to {}'.format(plugin_path))
        p = re.compile('^Plugin +[\'\"](?P<plugin>[^\'\"]*)[\'\"]')
        with open(os.path.join(self.get_home(), VimEnv.get_vimrc_file_name())) as fh:
            for line in fh.readlines():
                res = p.match(line)
                if res:
                    self.clone_repo(**dict(repo='https://github.com/' + res.group('plugin')))

    def setup(self, args):
        print(Env.get_setup_welcome_msg('vim'))
        self.set_home(args.dir)
        self._set_vimrc_files()
        self._install_vim_plugins()

class MiscEnv(Env):
    """Misc environment setup class"""

    def __init__(self):
        pass

def main():
    parser = argparse.ArgumentParser(description='Set up the linux environment')
    parser.add_argument('-e', '--env',
                        choices=['zsh', 'bash', 'vim', 'misc'],
                        help='sets up the specified environment')
    parser.add_argument('-d', '--dir',
                        help='install directory')
    args = parser.parse_args()

    git_exe = None
    for dir in os.environ['PATH'].split(';'):
        git_exe = os.path.join(dir, 'git.exe' if Env.is_windows else 'git')
        if os.path.exists(git_exe):
            break

    if git_exe is None:
        raise OSError('Could not find the git executable in the PATH')

    if args.env == 'zsh':
        ZshEnv().setup()
    elif args.env == 'bash':
        BashEnv().setup()
    elif args.env == 'vim':
        VimEnv().setup(args)
    elif args.env == 'misc':
        MiscEnv().setup()
    else:
        pass

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print('{}: error: {}'.format(sys.argv[0], e))
