#!/usr/bin/env python

import argparse
import os, errno
import tempfile
import urllib.request
import tarfile
import subprocess
from colorama import Fore, Style, init


def process(args):
    # retrive meta information from the provided arguments
    version, temp_dir, url, file_name = metainfo(args);

    # download boost from 'url' and store it in 'file_name'
    download(url, file_name)

    # extract boost to 'temp_dir'
    extract_directory = extract(temp_dir, file_name)

    # install
    # run bootstrap
    bootstrap(args.path, extract_directory, version)
    # run b2
    b2(extract_directory)


def metainfo(args):
    version_with_dots = args.version + '.0'
    version_with_underscore = version_with_dots.replace('.', '_')

    temp_dir = tempfile.gettempdir();
    print('temp directory used: {}'.format(temp_dir))

    # name of the boost archive
    archive_name = 'boost_' + version_with_underscore + '.tar.gz'

    # destination file name
    file_name = os.path.join(temp_dir, archive_name)

    # url to retrieve
    url = 'https://boostorg.jfrog.io/artifactory/main/release/' + \
            version_with_dots + '/source/' + archive_name

    return version_with_dots, temp_dir, url, file_name


def download(url, dest):
    print(Fore.GREEN + 'Downloading: ', end='')
    print('{} into {}'.format(url, dest))

    # https://stackoverflow.com/questions/7243750/download-file-from-web-in-python-3
    # Download the file from `url` and save it locally under `dest`:
    with urllib.request.urlopen(url) as response, open(dest, 'wb') as out_file:
        data = response.read()
        out_file.write(data)


def extract(temp_dir, file_name):
    print(Fore.GREEN + 'Extracting: ', end='')
    dir_name = file_name.split('.')[0]
    print(dir_name)
    with tarfile.open(file_name) as tar:
        tar.extractall(temp_dir)
    return os.path.join(temp_dir, dir_name)


def bootstrap(path, extract_directory, version):
    if os.name == 'nt':
        cmd = ['bootstrap.bat']
    else:
        cmd = ['./bootstrap.sh']

    # Even though, the default path for Linux is /usr/local,
    # it doesn't place the headers in separate directories per version.
    # However, in Windows this is done under C:\boost\boost_x_x folder.
    # Therefore, if the path isn't specified for Linux, let's put this
    # nicely in version specific directories
    if not path and os.name != 'nt':
        path = '/usr/local/boost_' + version

    if path:
        prefix_path = os.path.normpath(path)
        cmd.append('--prefix=' + prefix_path)
        print('Install path: {}'.format(prefix_path))

    subprocess.run(cmd, shell=True, cwd=extract_directory)


def b2(extract_directory):
    if os.name == 'nt':
        cmd = ['b2.exe', '-j 8', 'install']
        subprocess.run(cmd, shell=True, cwd=extract_directory)
    else:
        cmd = ['sudo', './b2', '-j 8', 'install']
        subprocess.run(cmd, check=True, cwd=extract_directory)


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

