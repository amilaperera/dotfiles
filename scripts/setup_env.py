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

    def is_windows(self):
        return sys.platform.startswith('win')

    def is_linux(self):
        return sys.platform.startswith('linux')

    def set_home(self, dir=None):
        if self.home is None or dir is not None:
            if (dir is not None):
                self.home = dir
            else:
                # vim usually looks for vimrc in $HOME folder
                self.home = os.environ['HOME']
                if self.home in ('', None):
                    raise OSError('$HOME environment variable is not set')

    def get_home(self):
        self.set_home()
        return self.home

    def get_env_name(self):
        if self.is_linux():
            return 'linux'
        elif self.is_windows():
            return 'windows'
        else:
            # NOTE: add these as necessary for different environments
            raise OSError('unknown os detected')

    def get_setup_welcome_msg(self, setup_str):
        return 'Setting up {} environment on {}...'.format(setup_str, self.get_env_name())

    def _get_install_command(self):
        if sys.platform.startswith('linux'):
            pass

    def _install_package(self):
        pass

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

        print(repo)

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

class Zsh(Env):
    """Zsh environment setup class"""

    def __init__(self):
        pass

    def setup(self):
        args = dict(
                repo='https://github.com/amilaperera/dotfiles',
                )
        self.clone_repo(**args)

class Bash(Env):
    """Bash environment setup class"""

    def __init__(self):
        pass

class Vim(Env):
    """Vim environment setup class"""

    def __init__(self):
        super(Vim, self).__init__()

    def _set_vimrc_files(self):
        home_path = self.get_home()
        print('copying vimrc files to {}'.format(home_path))
        for f in ('.vimrc', '.gvimrc'):
            if self.is_windows():
                # copy .vimrc & .gvimrc files as _vimrc and _gvimrc files respectively
                # to the $HOME folder
                shutil.copy(os.path.join('../', f),
                        os.path.join(home_path, '_' + f.split('.')[1]))
            elif self.is_linux():
                # create a link to .vimrc & .gvimrc files in the home directory
                os.symlink(os.path.join('../', f), home_path)
            else:
                raise OSError('unknown os detected')

    def _install_vim_plugins(self):
        plugin_path = os.path.join(self.get_home(), os.path.join('.vim', 'bundle'))
        if not os.path.isdir(plugin_path):
            os.makedirs(plugin_path)
        os.chdir(plugin_path)

        print('installing vim plugins to {}'.format(plugin_path))
        p = re.compile('^Plugin +[\'\"](?P<plugin>[^\'\"]*)[\'\"]')
        with open(os.path.join(self.get_home(), '_vimrc')) as fh:
            for line in fh.readlines():
                res = p.match(line)
                if res:
                    self.clone_repo(**dict(repo='https://github.com/' + res.group('plugin')))

    def setup(self, args):
        print(self.get_setup_welcome_msg('vim'))
        self.set_home(args.dir)
        self._set_vimrc_files()
        self._install_vim_plugins()

class Misc(Env):
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
    if args.env == 'zsh':
        Zsh().setup()
    elif args.env == 'bash':
        Bash().setup()
    elif args.env == 'vim':
        Vim().setup(args)
    elif args.env == 'misc':
        Misc().setup()
    else:
        pass

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print('{}: error: {}'.format(sys.argv[0], e))
