"""
lgj970401's dotfile
https://github.com/lgj970401/dotfiles.git
"""
print(__doc__)

import os
import argparse
import subprocess
from signal import signal, SIGPIPE, SIG_DFL

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--force', action="store_true", default=False,
                    help='If set, it will override existing symbolic links')
args = parser.parse_args()

tasks = {
        '~/.zshrc': 'zsh/zshrc',
        '~/.gitconfig': 'git/gitconfig',
        '~/.batconfig': 'bat/batconfig',
        '~/.vim': 'vim/',
        '~/.vimrc': 'vim/vimrc',
        '~/.tmux.conf': 'tmux/tmuxconfig',
        '~/.tmux/plugins/tpm': 'tmux/tpm/',
        '~/.zsh': 'zsh/',
        '~/.zprofile': 'zsh/zprofile',

        '~/.local/bin/fasd': 'zsh/fasd/fasd',

        '~/.slimzsh': 'zsh/slimzsh/'
        }

post_actions = [
# install miniforge
'''
if ! [ -x "$(command -v mamba)" ]; then
    wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    bash Miniforge3.sh -b -p "${HOME}/conda"
    source "${HOME}/conda/etc/profile.d/conda.sh"
    source "${HOME}/conda/etc/profile.d/mamba.sh"
    mamba init zsh
fi
''',

# install compilers and build tools using mamba
'''
source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
mamba install -y ccache cmake ninja gcc gxx libzlib llvm-openmp
''',

# install zplug
'''
if ! [ -e $HOME/.zplug ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi
''',

# install Rust
'''
export CPATH=${CPATH}:"${CONDA_PREFIX}"/include
source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
if [ -e $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi
if ! [ -x "$(command -v rustc)" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
fi
''',

# install fd
'''
export CPATH=${CPATH}:"${CONDA_PREFIX}"/include
source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
if [ -e $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi
if ! [ -x "$(command -v fd)" ]; then
    cargo install fd-find
fi
''',

# install bat
'''
export CPATH=${CPATH}:"${CONDA_PREFIX}"/include
source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
if [ -e $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi
if ! [ -x "$(command -v bat)" ]; then
    cargo install bat
fi
''',

# install eza
'''
export CPATH=${CPATH}:"${CONDA_PREFIX}"/include
source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
if [ -e $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi
if ! [ -x "$(command -v eza)" ]; then
    cargo install eza
fi
''',

# install ripgrep
'''
export CPATH=${CPATH}:"${CONDA_PREFIX}"/include
source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
if [ -e $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi
if ! [ -x "$(command -v rg)" ]; then
    cargo install ripgrep
fi
''',

# install vim-plug
# https://github.com/junegunn/vim-plug
'''
if ! [ -e $HOME/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
''',

# install fzf
# install fzf via zplug doens't activate key-bindings, so install it in here
'''
if ! [ -x "$(command -v fzf)" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --update-rc
fi
''',

# install github cli
'''
export CPATH=${CPATH}:"${CONDA_PREFIX}"/include
source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
if ! [ -x "$(command -v gh)" ]; then
    mamba install gh
fi
''',

# install github copilot
'''
if ! gh copilot > /dev/null 2>&1; then
    gh extension install github/gh-copilot
else
    gh extension upgrade gh-copilot
fi
''',

# install github cli
'''
export CPATH=${CPATH}:"${CONDA_PREFIX}"/include
source "${HOME}/conda/etc/profile.d/conda.sh"
source "${HOME}/conda/etc/profile.d/mamba.sh"
if ! [ -x "$(command -v direnv)" ]; then
    mamba install direnv
fi
''',
]

def _wrap_colors(ansicode):
    return (lambda msg: ansicode + str(msg) + '\033[0m')
GRAY   = _wrap_colors("\033[0;37m")
WHITE  = _wrap_colors("\033[1;37m")
RED    = _wrap_colors("\033[0;31m")
GREEN  = _wrap_colors("\033[0;32m")
YELLOW = _wrap_colors("\033[0;33m")
CYAN   = _wrap_colors("\033[0;36m")
BLUE   = _wrap_colors("\033[0;34m")

current_dir = os.path.abspath(os.path.dirname(__file__))
os.chdir(current_dir)

print(CYAN("Creating symbolic links"))
for target, source in sorted(tasks.items()):
    # normalize paths
    source = os.path.expanduser(os.path.join(current_dir, source))
    target = os.path.expanduser(target)

    # bad entry if source does not exists...
    if not os.path.lexists(source):
        print(RED("source %s : does not exist" % source))
        continue

    if os.path.lexists(target):
        is_broken_link = os.path.islink(target) and not os.path.exists(os.readlink(target))
        if args.force or is_broken_link:
            if os.path.islink(target):
                os.unlink(target)
            else:
                print("{:50s} : {}".format(
                    BLUE(target),
                    YELLOW("already exists but not a symbolic link; --force option ignored")
                ))
        else:
            print("{:50s} : {}".format(
                BLUE(target),
                GRAY("already exists, skipped") if os.path.islink(target) \
                    else YELLOW("exists, but not a symbolic link. Check by yourself!!")
            ))

    # make a symbolic link if available
    if not os.path.lexists(target):
        mkdir_target = os.path.split(target)[0]
        os.makedirs(mkdir_target, exist_ok=True)
        print(GREEN('Created directory : %s' % mkdir_target))

        os.symlink(source, target)
        print("{:50s} : {}".format(
            BLUE(target),
            GREEN("symlink created from '%s'" % source)
        ))

errors = []
for action in post_actions:
    if not action:
        continue

    print(CYAN("Executing: " + action))
    ret = subprocess.call(['bash', '-c', action],
                          preexec_fn=lambda: signal(SIGPIPE, SIG_DFL))

    if ret:
        errors.append(action)


print()
if errors:
    print(YELLOW("You have %3d warnings or errors -- check the logs!" % len(errors)))
    for e in errors:
        print("   " + YELLOW(e))
    print()
else:
    print(GREEN("✔  You are all set! "))
