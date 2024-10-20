#PROMPT='%B%F{2}%n@%m %. %%%f%b '
#PROMPT="\n\[\033[01;31m\]\u@\h\n\033[00;34m\]\`date +'%F %T'\` \[\033[00;32m\]\`pwd\`\n\[\033[01;31    m\]$ \[\033[00m\]"

PROMPT_MARKER='%% '
PROMPT_DATETIME='[%D{%Y-%m-%f} %D{%K:%M:%S}] '
PROMPT='%F{2}'$PROMPT_DATETIME'%B%n@%m %~ '$PROMPT_MARKER'%b%f'

export PATH=$PATH:~/code/confd/bin
export NPMVERSION=6.14.9

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word

## Aliases

alias nv="nvim"
alias vim="nvim"
alias oldvim=/usr/bin/vim
alias ll="ls -lahFBG"
alias lll="ls -lahFBG | less"
alias llg="ls -lahFBG | grep $1"
alias cwd="pwd | pbcopy"
alias code="open -a 'Visual Studio Code' $1"
alias apps="cd /Applications; ls"
alias slack="open /Applications/Slack.app --hide -g" 
alias spotify="open /Applications/Spotify.app --hide -g"
alias zoom="open /Applications/Zoom.app --hide -g"
alias killnode='killall -9 node'

openlocal() {
  open http://localhost:$(echo $1 | xargs)
}

tidy_screenshots() {
	i=0
	DEST=~/Desktop/screenshots
        echo "Moving Desktop screenshots to $DEST..."
	ls -la ~/Desktop | grep "Screen Shot" | while read -r line ; do
	  FILEPATH=$(echo "$line" | sed -E -e 's/^.+Screen/Screen/')
	  mv ~/Desktop/"$FILEPATH" $DEST
	  ((++i))
	done
	echo "Moved $i files"
}
alias tidy-screenshots=tidy_screenshots

# cd to the dir in the frontmost Finder window 
cdf() {
  currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
  )
  echo "cd to \"$currFolderPath\""
  cd "$currFolderPath"
}

# Open the current dir in a Finder window
finder() {
  open -a Finder .
}

# Git

HASH="%C(always,yellow)%h%C(always,reset)"
RELATIVE_TIME="%C(always,green)%ar%C(always,reset)"
AUTHOR="%C(always,bold blue)%an%C(always,reset)"
REFS="%C(always,red)%d%C(always,reset)"
SUBJECT="%s"

FORMAT="$HASH $RELATIVE_TIME{$AUTHOR{$REFS $SUBJECT"

# From https://registerspill.thorstenball.com/p/how-i-use-git 
pretty_git_log() {
  git log --graph --pretty="tformat:$FORMAT" $* |
  column -t -s '{' |
  less -XRS --quit-if-one-screen
}

alias ga="git add"
alias gb="git branch"
alias gbv="git branch -vv"
alias gck="git checkout"
alias gcm="git commit"
alias gd="git diff"
alias gl="git log"
alias glp=pretty_git_log
alias gm="git merge"
alias gpl="git pull"
alias gpu="git push"
alias grs="git restore --staged"
alias gs="git status"
alias sub='git submodule update --recursive --init'
alias diffnames="setbname; git diff master..$bname --name-status"

grepbranch() {
  git branch | grep $1
}

# Store current branch name in variable
set_b_name() {
	bname=$(git status | grep -i "on branch" | cut -f3 -d" ")
	echo "Set bname: $bname"
}
alias setbname=set_b_name

cpbranch() {
  set_b_name
  echo -n $bname | pbcopy
}

initial_push() {
	set_b_name
	git push -u origin $bname
}
alias firstpush=initial_push

## GO

alias air='/Users/jasonflorentino/go/bin/air'

## zsh

# Edit zshrc
alias zshrc="vim ~/.zshrc"

# Edit zshenv
alias zshenv="vim ~/.zshenv"

# Reload zshrc
alias reloadrc="source ~/.zshrc"

# Edit .npmrc
alias npmrc="vim ~/.npmrc"

# date to clipboard
alias cpdate="date | pbcopy"

# Launch iOS Simulartor
alias simulator="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"

## Redis

alias redis-start="~/code/redis-6.2.6/src/redis-server"
alias redis-cli="~/code/redis-6.2.6/src/redis-cli"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# bun completions
[ -s "/Users/jasonflorentino/.bun/_bun" ] && source "/Users/jasonflorentino/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
