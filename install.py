#!/usr/bin/env python3

import os
import platform
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path

try:
    from utils import render, symlink, inject
except ModuleNotFoundError:
    pass

# Dotfiles repository URL
dotfiles_repo = 'git@github.com:pitaylor/dotfiles.git'

# Optionally override checkout branch
dotfiles_branch = os.getenv('BRANCH', 'main')

# Directory where repository is checked out
dotfiles_dir = Path.home() / '.dotfiles'

# Directory where template files are rendered
rendered_dir = dotfiles_dir / 'rendered'

# Directories that contain files to be symlinked
source_dirs = [dotfiles_dir / 'Default']

# Include platform specific source directory
if (platform_dir := dotfiles_dir / platform.system()).exists():
    source_dirs.append(platform_dir)

# Template variables
template_vars = {'HOME': Path.home()}

try:
    template_vars['BREW_PREFIX'] = subprocess.check_output(['brew', '--prefix']).decode('UTF-8').strip()
except (subprocess.CalledProcessError, FileNotFoundError):
    pass

if __name__ == '__main__':
    if not dotfiles_dir.exists():
        subprocess.check_call(['git', 'clone', '-b', dotfiles_branch, dotfiles_repo, dotfiles_dir])
        subprocess.check_call([dotfiles_dir / 'install.py'])
        sys.exit()

    if rendered_dir.exists():
        shutil.rmtree(rendered_dir)

    for source_dir in source_dirs:
        render(source_dir, rendered_dir, template_vars)

    for source_dir in source_dirs:
        symlink(source_dir, Path.home())

    symlink(rendered_dir, Path.home())

    inject('${HOME}/.dotfiles/bin/profile.sh', Path.home() / '.bash_profile')
    inject('${HOME}/.dotfiles/bin/bashrc.sh', Path.home() / '.bashrc')

    message = textwrap.dedent("""
    Useful Commands:
    
    dot-brew - install homebrew packages
    dot-pull - pull latest dotfiles
    """)

    print('Done!')
    print(message)
