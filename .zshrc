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
alias cpdate="date | pbcopy"
alias curs="open -a 'Cursor' $1"
alias notes="vim ~/jason/notes.md"
alias cursor="open -a 'Cursor' $1"
alias apps="cd /Applications; ls"
alias slack="open /Applications/Slack.app --hide -g" 
alias spotify="open /Applications/Spotify.app --hide -g"
alias zoom="open /Applications/Zoom.app --hide -g"
alias killnode='killall -9 node'
alias zed="open -a Zed $@"
alias lsnode="ps aux | grep node"

resize_2400() {
  (cd ~/Desktop; sips -Z 2400 $@)
}
alias resize=resize_2400

web_size() {
  sips -Z 2100 "$@" --out "${@%.*}-2100.jpg"
}
alias websize=web_size


jpg_size() {
  for file in *.JPG; do sips -Z $@ "$file" --out "${file%.*}-$@.jpg"; done
}
# jpgsize 2100
alias jpgsize=jpg_size

shrink_vid() {
  local input="$1"
  local base_name

  base_name="$(basename "$input")"
  base_name="${base_name%.*}"

  ffmpeg -i "$input" \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    -vcodec libx264 -crf 28 -preset fast \
    -an -movflags +faststart -y \
    "${base_name}-shrunk.mp4"
}

alias shrinkvid=shrink_vid

alias imgprocess="/Users/jason.florentino/jason/code/jasonflorentino/bin/img_process"

# Ghostty

alias ghosttyrc="vim '/Users/jason.florentino/Library/Application Support/com.mitchellh.ghostty/config'"

# Elixir

export PATH=$PATH:/opt/homebrew/bin/elixir

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

git_log_one() {
  git log \
    -n 20 \
    --pretty=format:"%C(auto)%h %C(green)%ad%C(blue) %an%C(reset) %s" \
    --color \
    --date=short \
    -- $* | awk '{start=substr($0, 1, 100); end=substr($0, length($0)-7); printf "%-100s / %-7s\n", start, end}'
}

git_last() {
  local lines="${1:-1}"
  git log --oneline -n $lines
}

alias lastbranch=/Users/jason.florentino/jason/code/jasonflorentino/bin/last_branch

alias main="git checkout main || git checkout master"
alias master="git checkout master || git checkout main"
alias staging="git checkout staging"

alias glast=git_last
alias ga="git add"
alias gaa="git add -A; gs"
alias gb="git branch"
alias gbm="git branch -m"
alias gbv="git branch -vv"
alias gck="git checkout"
alias gcm="git commit"
alias gcmm="git commit -m"
alias gcma="git commit --amend"
alias gd="git diff"
alias gl="git log"
alias glp=pretty_git_log
alias gm="git merge"
alias gmm="git merge master || git merge main"
alias gpl="git pull"
alias gps="git push"
alias grs="git restore --staged"
alias gs="git status"
alias sub='git submodule update --recursive --init'
alias diffnames="setbname; git diff master..$bname --name-status"

alias openremote=git_remote_open

git_remote_open() {
  REMOTE=$(git remote get-url origin)
  URL=https://$(echo $REMOTE | sed 's/git@//' | sed 's/:/\//' | sed 's/.git//')
  echo Opening $URL
  open $URL
}

alias pullurl=pull_url

pull_url() {
  echo
  echo "Getting pull URL"

  git rev-parse --is-inside-work-tree &>/dev/null || {
    echo "Not a git repo" >&2
    return 1
  }

  local remote="origin"
  local branch url cleaned base user repo pr_url

  branch=$(git branch --show-current)
  [[ -n "$branch" ]] || { echo "No branch checked out" >&2; return 1; }
  echo "branch: $branch"

  url=$(git remote get-url "$remote")
  [[ -n "$url" ]] || { echo "No remote URL found on '$remote'" >&2; return 1; }

  # --- Normalize GitHub URL to HTTPS form ---
  case "$url" in
    git@github.com:*)
      # SSH → extract path after colon
      cleaned="${url#git@github.com:}"
      ;;
    ssh://git@github.com/*)
      cleaned="${url#ssh://git@github.com/}"
      ;;
    https://github.com/*)
      cleaned="${url#https://github.com/}"
      ;;
    *)
      echo "Remote '$remote' does not look like a GitHub URL: $url" >&2
      return 1
      ;;
  esac

  # remove trailing .git if present
  cleaned="${cleaned%.git}"

  # split into user + repo
  user="${cleaned%%/*}"
  repo="${cleaned#*/}"

  echo "user: $user"
  echo "repo: $repo"

  if [[ -z "$user" || -z "$repo" ]]; then
    echo "Failed to parse GitHub user/repo from $url" >&2
    return 1
  fi

  base="https://github.com/$user/$repo"

  pr_url="$base/compare/$branch?expand=1"
  #
  # Print and copy
  printf '%s\n' "$pr_url"
  printf '%s' "$pr_url" | pbcopy

  # Open in default browser
  if command -v open &>/dev/null; then
    open "$pr_url"           # macOS
  elif command -v xdg-open &>/dev/null; then
    xdg-open "$pr_url"       # Linux
  else
    echo "Cannot automatically open browser; please open the URL manually."
  fi
}

alias repourl=repo_url

repo_url() {
  BASEURL="https://github.com/relayfinancial"
  REPO=$(basename `git rev-parse --show-toplevel`)
  URL="$BASEURL/$REPO"
  echo $URL | pbcopy
  echo $URL
}

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
  git branch --show-current | pbcopy
}
alias copybranch=cpbranch
alias branchcopy=cpbranch

initial_push() {
	bname=$(git branch --show-current)
	git push -u origin $bname

	URL=$(pull_url)
}

alias firstpush=initial_push

merge_master() {
  BRANCH=$(git branch --show-current)
  git checkout master
  git pull
  git checkout $BRANCH
  git merge master
}

alias mergemaster=merge_master

merge_main() {
  BRANCH=$(git branch --show-current)
  git checkout main  
  git pull 
  git checkout $BRANCH
  git merge main 
}

alias mergemain=merge_main

## GO

export PATH=$PATH:/usr/local/go/bin
alias air='~/go/bin/air'

## ROC

export PATH=$PATH:/usr/local/roc/roc_nightly-macos_apple_silicon-2025-02-04-59ff9bddb38

## tmux
alias tmuxconf="vim ~/.tmux.conf"

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

export PATH="/opt/homebrew/bin:$PATH"
. "/Users/jason.florentino/.deno/env"

source ~/.cargo/env 

