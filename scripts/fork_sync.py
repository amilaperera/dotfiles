#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import os
import subprocess
import sys
import json
import re

def get_dev_null():
    """Returns writable /dev/null file descriptor"""
    return open(os.devnull, 'w')

class Colors(object):
    """Class used to colorize the text"""
    Red = '\033[31m'
    Green = '\033[32m'
    Yellow = '\033[33m'
    Pink = '\033[35m'
    End = '\033[0m'

    @staticmethod
    def Colorize(*args):
        """Static method used to colorize the text"""
        return args[1] + args[0] + Colors.End

class ForkSync(object):
    """The main application class which is used to synchronize
    the forks with the upstream.
    """
    def __init__(self, config_file):
        with open(config_file) as cf:
            self.config_data = json.load(cf)

    def run(self):
        for repo in self.config_data:
            Fork(**repo).sync()


class Fork(object):
    """This class handle a single forked repository"""
    def __init__(self, **kwargs):
        self.repo = kwargs

    def sync(self):
        try:
            # prints the starting message for the repository
            print(self._getrepo_start_message())

            # the functions below carry out the fork synchronization per repository
            # the functions are just self-explanatory
            self._change_dir()
            self._pull_from_remote()
            self._add_upstream_if_required()
            self._fetch_from_upstream()
            self._merge_with_upstream()

            # takes the git status and prints it with color formatting,
            # so that the user knows whether merged changes should be pushed or not
            print(self._get_status())

        except Exception as e:
            print('error synchronizing with the fork. {}'.format(e), file=sys.stderr)

    def _getrepo_start_message(self):
        try:
            msg = ' working on ' + Colors.Colorize(self.repo['repo_name'], Colors.Yellow) + ' '
            terminal_width = int(subprocess.check_output(['stty', 'size']).split()[1])
            format_spec = '{:-^'+ str(terminal_width - 10) + '}'
        except:
            raise
        else:
            return format_spec.format(msg)

    def _change_dir(self):
        try:
            os.chdir(os.path.expanduser(self.repo['dir']))
            print('changed to directory: {}'.format(self.repo['dir']))
        except:
            raise

    def _pull_from_remote(self):
        print('pulling from origin/master')
        subprocess.check_call(['git', 'pull'],
                stdout=get_dev_null(), stderr=subprocess.STDOUT, close_fds=True)

    def _add_upstream_if_required(self):
        # checks if the upstream repository exists
        print('checking for upstream')
        try:
            subprocess.check_call(['git', 'ls-remote', 'upstream'],
                    stdout=get_dev_null(), stderr=subprocess.STDOUT, close_fds=True)
        except:
            # since upstream repository is not added, add the upstream repo
            print('can not find the upstream remote...')
            print('adding upstream repostiory...')
            self._add_upstream()
        else:
            print('upstream found')

    def _add_upstream(self):
        subprocess.check_call(['git', 'remote', 'add', 'upstream',
            'https://github.com/' + self.repo['upstream_repo']])

    def _fetch_from_upstream(self):
        print('fetching from upstream')
        subprocess.check_call(['git', 'fetch', 'upstream'])

    def _merge_with_upstream(self):
        subprocess.check_call(['git', 'checkout', 'master'],
                stdout=get_dev_null(), stderr=subprocess.STDOUT, close_fds=True)

        print('merging with upstream')
        subprocess.check_call(['git', 'merge', 'upstream/master'],
                stdout=get_dev_null(), stderr=subprocess.STDOUT, close_fds=True)

    def _get_status(self):
        output = subprocess.check_output(['git', 'status']).split('\n')[1]
        return Colors.Colorize(output, Colors.Red) if re.search('[0-9]+', output) \
               else Colors.Colorize(output, Colors.Green)

def main():
    """Creates a ForkSync object and execute the sycnchronization of the forks"""
    try:
        ForkSync('.fork_sync.json').run()
    except Exception as e:
        print('error: {}'.format(e), file=sys.stderr)

if __name__ == "__main__":
    main()
