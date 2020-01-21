# python alias
alias ca="conda activate"
alias sa="source .venv/bin/activate"
alias jn="jupyter notebook"
alias jl="jupyter lab"

# 
alias smi="nvidia-smi"
function ns() {
        watch -n 0.1 "nvidia-smi $@"
}

alias v="vim"

if [ -x "$(command -v exa)" ]; then
	alias ls="exa"
fi
alias ll="ls -alFh"
if [ -x "$(command -v bat)" ]; then
	alias cat="bat --no-pager"
fi
alias c="command"

# git alias
alias gstat="git status -u"
alias gstatus="gstat"
alias gdiff="git diff"
alias gadd="git add"

alias gh="git history"
alias gha="gh --all"
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
