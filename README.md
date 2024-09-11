# Installation

```
git clone git@github.com:gunjunlee/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
bash setup.sh
zsh
python3 install.py
```

If icons appear broken, you can download a font you like from [Nerd Fonts](https://www.nerdfonts.com/font-downloads) and apply it locally. (I recommend D2Coding.)

If nvim is failed to run, remove nvchad using command below and try again.

```
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

