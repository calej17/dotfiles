# ENVIRONMENT VARIABLES #
#########################

# Theme
ZSH_THEME="half-life"
# ZSH_THEME="jonathan"

# No brainer, default to ~Vim~, ~Atom~, VS Code?
export EDITOR="code"

# Color LS output to differentiate between directories and files
export LS_OPTIONS="--color=auto"
export CLICOLOR="Yes"
export LSCOLOR=""

# Speed up the rubies
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_GC_HEAP_FREE_SLOTS=200000

# Add sbin, Homebrew, Postgres.app, and NPM related directories to path
if [ "$(sysctl -n sysctl.proc_translated)" = "1" ]; then
  local brew_path="/usr/local/homebrew/bin"
  local brew_opt_path="/usr/local/opt"
  local nvm_path="$HOME/.nvm-x86"
else
  local brew_path="/opt/homebrew/bin"
  local brew_opt_path="/opt/homebrew/opt"
  local nvm_path="$HOME/.nvm"
fi

export PATH="${brew_path}:${PATH}"
export NVM_DIR="${nvm_path}"

# This loads nvm
[ -s "${brew_opt_path}/nvm/nvm.sh" ] && . "${brew_opt_path}/nvm/nvm.sh"
# This loads nvm bash_completion
[ -s "${brew_opt_path}/nvm/etc/bash_completion.d/nvm" ] && . "${brew_opt_path}/nvm/etc/bash_completion.d/nvm"

# Make sure rbenv can be found
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Export NVM path
# export NVM_DIR=~/.nvm
# source $(brew --prefix nvm)/nvm.sh

# export PATH=/sbin:$PATH
# export PATH=/usr/local/bin:$PATH
# export PATH=/Applications/Postgres93.app/Contents/MacOS/bin:$PATH
# export PATH=/usr/local/share/npm/bin:$PATH

# Configure GOPATH and add go/bin to Path
# export GOPATH=$HOME/code/go
# export PATH=$GOPATH/bin:$PATH

# Add GOROOT to PATH for access to godoc
# export PATH=$PATH:/usr/local/Cellar/go/1.2/libexec/bin

# Keep working directory in new tab
function term_current_pwd () {
  local PWD_URL="file://$HOSTNAME${PWD// /%20}"
  printf '\e]7;%s\a' $PWD_URL
}
chpwd_functions+=(term_current_pwd)

# GPG Config
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# CONFIG #
###########
# OC GH/Yarn
# export YARN_NPM_AUTH_TOKEN=<token>

# ALIASES #
###########

# ZSH
alias ztheme='() { export ZSH_THEME="$@" && source $ZSH/oh-my-zsh.sh }'

# Standard Shell
alias c='clear'
alias l='ls -l'
alias ll='ls -la'
# alias bloat='du -k | sort -nr | more'
alias cdp='cd Projects'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO'

# Dotfiles
alias dots='cd Projects/dotfiles'

# Bundle Exec
alias be="bundle exec"

# Git
alias gs='git status -s'
alias ga='git add .'
alias gb='git branch'
alias gc='git commit -m'
alias gd='git diff'
alias gf='git fetch'
alias gl='git log --oneline'
alias gm='git merge'
alias gr='git remote -v'
alias gra='git remote add'
alias gre='git rebase'
alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias gbm='git branch -m'
alias gca='git commit -am'
alias gco='git checkout'
alias gcob='git checkout -b'
alias grpr='git remote prune origin'
alias grso='git remote show origin'

# Homebrew
alias cellar='open /usr/local/Cellar'

# Postgres
alias pgStart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgStop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# SSH
alias ocErrbit='ssh -i .ssh/identity/prod-07022018.pem ec2-user@18.232.62.149 -L 8086:10.30.17.73:80 -N'

# DayCFO - NO LONGER ReactOnRails
# alias dcfoStart='foreman start -f Procfile.dev'

# OC
alias ocYarn='yarn install && yarn start-dev'

# TMUX
# alias attach='tmux attach-session -t'
# alias switch='tmux switch-session -t'
# alias tmk='tmux kill-session -t'
# alias tls='tmux ls'

# Server fanciness with python
# alias server='open http://localhost:1337/ && python -m SimpleHTTPServer 1337'

# Xcode
# alias pngcrush='/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush -q -revert-iphone-optimizations -d'

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
# alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

# Flush DNS Cache
# alias dnsflush='dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# ZSH CONFIGURATION #
#####################

# Turn off Vi mode
bindkey -e

# Source zsh syntax highlighting
[[ -s $HOME/bin/zsh-syntax-highlighting.zsh ]] && source $HOME/bin/zsh-syntax-highlighting.zsh

# Source Marked.app command line function
[[ -s $HOME/bin/marked.sh ]] && source $HOME/bin/marked.sh

# Source Tmuxinator if installed
# [[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Virtualenv & Virtualenvwrapper setup if installed
VIRTUAL_ENV_DISABLE_PROMPT=1
if which virtualenv > /dev/null;
then
  VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
  export WORKON_HOME=$HOME/.virtualenvs
  source /usr/local/bin/virtualenvwrapper.sh
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
fi

# Load completions for Ruby, Git, etc.
autoload compinit && compinit -C

# Make git completions not be ridiculously slow
__git_files () {
  _wanted files expl 'local files' _files
}

# Case insensitive auto-complete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# PROMPT FUNCTIONS AND SETTINGS #
#################################

# Colors
autoload -U colors && colors
setopt prompt_subst

# Display Virtualenv cleanly in right column
function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# Display whether you are in a Git or Mercurial repo
function prompt_char {
  git branch >/dev/null 2>/dev/null && echo ' ±' && return
  hg root >/dev/null 2>/dev/null && echo ' ☿' && return
  echo ' ○'
}

# Display current ruby version
function ruby_info {
  echo "$(ruby -v | sed 's/.* \([0-9p\.]*\) .*/\1/')"
}

# Show previous command status
local command_status="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_colors%})"

# Show relative path on one line, then command status
PROMPT='
%{$fg[cyan]%}%n@%m%{$fg[white]%}: %{$fg[cyan]%}%~ %{$fg[white]%}
${command_status} %{$reset_color%} '

# Show virtualenv, rbenv, branch, sha, and repo dirty status on right side
RPROMPT='%{$fg[cyan]%}$(virtualenv_info)%{$fg[white]%}$(ruby_info)$(prompt_char)$(~/bin/git-cwd-info.sh)%{$reset_colors%}'

### Added by the Heroku Toolbelt
# export PATH="/usr/local/heroku/bin:$PATH"
