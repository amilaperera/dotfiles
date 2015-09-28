#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import argparse
import os
import platform
import subprocess
import sys
import time
import threading

def get_dev_null():
    """Returns writable /dev/null file descriptor"""
    return open(os.devnull, 'w')

class Env(object):
    """Environment setup base class"""
    def __init__(self):
        pass

    def setup(self):
        pass

    def _get_install_command(self):
        if sys.platform.startwith('linux'):
            pass

    def _install_package(self):
        pass

    def _print_with_sleep(self, str):
        sys.stdout.write(str)
        sys.stdout.flush()
        time.sleep(0.10)

    def _animate_progress_rotation(self):
        self._print_with_sleep('-')
        self._print_with_sleep('\b\\')
        self._print_with_sleep('\b|')
        self._print_with_sleep('\b/')
        self._print_with_sleep('\b-')
        self._print_with_sleep('\b\\')
        self._print_with_sleep('\b|')
        self._print_with_sleep('\b.')

    def _clone_thread(self, repo, dest):
        git_cmd = ['git', 'clone', repo]
        if dest is not None:
            git_cmd.append(dest)

        subprocess.check_call(git_cmd, stdout=get_dev_null(),
                stderr=subprocess.STDOUT, close_fds=True)

    def clone_repo(self, **kwargs):
        if self._is_cloneable(**kwargs):
            repo, dest = kwargs.get('repo'), kwargs.get('dest')
            print('cloning from repository {} '.format(repo), end='')
            clone_thread = threading.Thread(target=self._clone_thread, args=(repo, dest))
            clone_thread.start()

            while clone_thread.is_alive():
                self._animate_progress_rotation()

            print()
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

        try:
            # we check if the remote repo is valid.
            # if it is invalid git ls-remote <url> would return error status,
            # causing subprocess.Popen() to throw an exception
            subprocess.Popen(['git', 'ls-remote', repo],
                    stdout=get_dev_null(), stderr=subprocess.STDOUT,
                    env=new_env, close_fds=True)
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
        pass

class Misc(Env):
    """Misc environment setup class"""

    def __init__(self):
        pass

def main():
    parser = argparse.ArgumentParser(description='Set up the linux environment')
    parser.add_argument('-e', '--env',
                        choices=['zsh', 'bash', 'vim', 'misc'],
                        help='sets up the specified environment')
    args = parser.parse_args()
    if args.env == 'zsh':
        Zsh().setup()
    elif args.env == 'bash':
        Bash().setup()
    elif args.env == 'vim':
        Bash().setup()
    elif args.env == 'misc':
        Misc().setup()
    else:
        pass

if __name__ == '__main__':
    main()
