#!/usr/bin/env python

import argparse
import os, errno
import tempfile
import urllib.request
import tarfile
from colorama import Fore, Style, init


def process(args):
    version_with_dots = args.version + '.0'
    version_with_underscore = version_with_dots.replace('.', '_')

    temp_dir = tempfile.gettempdir();
    print(Style.BRIGHT + 'Temporary Directory: {}'.format(temp_dir))

    # name of the boost archive
    archive_name = 'boost_' + version_with_underscore + '.tar.gz'
    # destination file name
    file_name = os.path.join(temp_dir, archive_name)
    # url to retrieve
    url = 'https://boostorg.jfrog.io/artifactory/main/release/' + \
            version_with_dots + '/source/' + archive_name

    download(url, file_name)
    extract(file_name, temp_dir)


def download(url, dest):
    print(Fore.GREEN + 'Downloading: ', end='')
    print('{} into {}'.format(url, dest))

    # https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3
    # Download the file from `url` and save it locally under `dest`:
    with urllib.request.urlopen(url) as response, open(dest, 'wb') as out_file:
        data = response.read()
        out_file.write(data)


def extract(file_name, path):
    print(Fore.GREEN + 'Extracting: ', end='')
    print(format(file_name.split('.')[0]))
    with tarfile.open(file_name) as tar:
        tar.extractall(path)


def main():
    parser = argparse.ArgumentParser(description='Install boost from source code')
    parser.add_argument('-v', '--version', required=True,
                        help='boost version to be installed')
    parser.add_argument('-p', '--path', help='installation path')

    args = parser.parse_args()
    process(args)


if __name__ == '__main__':
    try:
        # Initialize colorama
        # Automate sending reset sequences after each colored output
        init(autoreset=True)
        main()

    except Exception as e:
        print('Error: ', end='')
        print(Fore.RED + '{}'.format(e))

