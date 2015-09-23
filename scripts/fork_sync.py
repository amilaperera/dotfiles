#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import os
import subprocess
import sys
import json
import re

def get_dev_null():
    return open(os.devnull, 'w')

class Colors(object):
    Red = '\033[31m'
    Green = '\033[32m'
    Yellow = '\033[33m'
    Pink = '\033[35m'
    End = '\033[0m'

    @staticmethod
    def Colorize(*args):
        return args[1] + args[0] + Colors.End

class ForkSync(object):

    def __init__(self, config_file):
        with open(config_file) as cf:
            self._config_data = json.load(cf)

    def run(self):
        for repo in self._config_data:
            Fork(**repo).sync()


class Fork(object):

    def __init__(self, **kwargs):
        self._repo = kwargs

    def sync(self):
        try:
            print(self.get_repo_start_message())
            self.change_dir()
            self.pull_from_remote()
            # checks if the upstream repository exists
            print('checking for upstream')
            if subprocess.call(['git', 'ls-remote', 'upstream'],
                               stdout=get_dev_null(), stderr=subprocess.STDOUT, close_fds=True):
                # since upstream repository is not added, add the upstream repo
                print('can not find the upstream remote...')
                print('adding {} as the upstream repository...'.format(self._repo['upstream_repo']))
                self.add_upstream_repo()

            self.fetch_from_upstream()
            self.merge_with_upstream()
            print(self.get_status())

        except Exception as e:
            print('error synchronizing with the fork', file=sys.stderr)

    def get_repo_start_message(self):
        try:
            msg = ' working on ' + Colors.Colorize(self._repo['repo_name'], Colors.Yellow) + ' '
            terminal_width = int(subprocess.check_output(['stty', 'size']).split()[1])
            format_spec = '{:-^'+ str(terminal_width - 10) + '}'
        except:
            raise
        else:
            return format_spec.format(msg)

    def change_dir(self):
        try:
            os.chdir(os.path.expanduser(self._repo['dir']))
            print('changed to directory: {}'.format(self._repo['dir']))
        except OSError as e:
            print('error changing to directory: {} ({})'.format(self._repo['dir'], e),
                  file=sys.stderr)
            raise

    def pull_from_remote(self):
        print('pulling from origin/master')
        if subprocess.call(['git', 'pull'],
                           stdout=get_dev_null(), stderr=subprocess.STDOUT, close_fds=True):
            print('error pulling from remote', file=sys.stderr)
            raise CoProcessError

    def add_upstream_repo(self):
        if subprocess.call(['git', 'remote', 'add', 'upstream', self.repo['upstream_repo']]):
            print('error adding the remote upstream: {}'.format(self.repo['upstream_repo']),
                  file=sys.stderr)
            raise CoProcessError

    def fetch_from_upstream(self):
        print('fetching from upstream')
        if subprocess.call(['git', 'fetch', 'upstream']):
            print('error fetching from upstream', file=sys.stderr)
            raise CoProcessError

    def merge_with_upstream(self):
        if subprocess.call(['git', 'checkout', 'master'],
                           stdout=get_dev_null(), stderr=subprocess.STDOUT, close_fds=True):
            print('error switching to master branch')
            raise CoProcessError

        print('merging with upstream')
        if subprocess.call(['git', 'merge', 'upstream/master'],
                           stdout=get_dev_null(), stderr=subprocess.STDOUT, close_fds=True):
            print('error merging with upstream: {}'.format(self._repo['upstream_repo']),
                  file=sys.stderr)

    def get_status(self):
        output = subprocess.check_output(['git', 'status']).split('\n')[1]
        return Colors.Colorize(output, Colors.Red) if re.search('[0-9]+', output) \
               else Colors.Colorize(output, Colors.Green)

def main():
    try:
        ForkSync('.fork_sync.json').run()
    except Exception as e:
        print('error: {}'.format(e), file=sys.stderr)

if __name__ == "__main__":
    main()
