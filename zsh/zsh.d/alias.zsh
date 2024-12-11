# github copilot
alias co="gh copilot suggest"

# python alias
alias ca="conda activate"
alias sa="source .venv/bin/activate"
alias jn="jupyter notebook"
alias jl="jupyter lab"

#  nvidia-smi
alias smi="nvidia-smi"
function ns() {
  watch -n 0.1 "nvidia-smi $@"
}

alias cudamem="fuser -v /dev/nvidia*"
alias gpumem="cudamem"

if [ -x "$(command -v nvim)" ]; then
	alias vim="nvim"
fi

if [ -x "$(command -v eza)" ]; then
  if command eza --version > /dev/null 2>&1; then
    alias ls="eza"
  fi
fi
alias ll="ls -algh"
if [ -x "$(command -v bat)" ]; then
  if command bat --version > /dev/null 2>&1; then
	  alias cat="bat -p"
  fi
fi
if [ -x "$(command -v fdfind)" ]; then
  if command fdfind --version > /dev/null 2>&1; then
    alias fd="fdfind"
  fi
fi
alias c="command"
alias watch="command watch --color"
alias w="watch"

# git alias
alias gstat="git status -u"
alias gstatus="gstat"
alias gdiff="git diff"
alias gadd="git add"

alias gd="git diff --no-prefix"
alias gdc="gd --cached --no-prefix"
alias gds="gd --staged --no-prefix"
alias gs="git stat"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gl="git lg"
alias gp="git push"
alias ga="git add"
alias gb="git branch"
alias gpl="git pull"
alias gf="git fetch"
alias gbl="git branch -l"
alias gco="git checkout"
alias gcp="git cherry-pick"

alias gluname="git config --local user.name"
alias gguname="git config --global user.name"
alias gluemail="git config --local user.email"
alias gguemail="git config --global user.email"

function gluser(){
	gluname $1
	gluemail $2
}

function gguser(){
	gguname $1
	gguemail $2
}

# tmux
alias tl="tmux ls"
alias ta="tmux attach -t"
alias tn="tmux new -s"

# zellij
alias zl="zellij list-sessions"
alias za="zellij attach"
alias zn="zellij attach -c"

# pip
pip(){
	if [[ $@ == "clear" ]]; then
		pip freeze | grep --color=auto -v "^-e" | awk -F ' @ ' '{print $1}' | xargs pip uninstall -y
	else
		command pip "$@"
	fi
}

# conda
alias conex="curl -s https://raw.githubusercontent.com/gunjunlee/Conda-Tools/main/conda_export.py | python - --from-history"
