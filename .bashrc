# ENV
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export EDITOR='vim'
export REACT_EDITOR=vscode

export GPG_TTY=$(tty)
export LESS=-R # Colors in less

# ALIAS
alias ll='ls -lhAF' # long list
alias lt='ls -c -lt -lh -A -F --full-time --color=auto' # long list
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias linecount='find . -type f | xargs wc -l'
alias rmnodemod='find . -type d -name node_modules -a -prune -exec rm -rf {} \;'
alias gzip-size='gzip -9c | wc -c | tr -d " "'
alias reload='source ~/.bash_profile'

# GIT
alias g='git'
alias recommit="$(git config --global core.editor) .git/COMMIT_EDITMSG"
alias gitbl="git for-each-ref --sort=committerdate refs/heads/ --color=always --format='%(color:cyan)%(committerdate:short)%(color:reset),%(color:yellow)%(authorname)%(color:reset),%(color:green)%(refname:short)%(color:reset)' | column -t -s ','"
alias switch='gitbl | tail -20'
alias odm='vscode $(git diff master...HEAD --name-only | xargs)'
alias olc='vscode $(git diff HEAD^...HEAD --name-only | xargs)'
alias removemergedremotebranches='git branch -a --merged remotes/origin/master | grep -v master | grep "remotes/origin/alex" | sed 's/remotes\/origin\///g' | xargs -n 1 git push --delete origin'

# FUNCTIONS
convertimestamp() {
	date -j -f "%s" $1 +"%Y-%m-%d %H:%M:%S"
}
alias timestamp=convertimestamp

# Calculate the percentage of code that has been rewritten in a branch or between two given commits.
# Takes a start and end commit as argument, which default to master & HEAD.
# Except for whitespace changes, the aim should be for this to be 0%.
githistorycomplexity() {
  diffcount=$(git diff ${1:-master}...${2:-HEAD} --shortstat | grep "files\? changed" | awk '{changes+=($4+$6)} END {print changes}')
  logcount=$(git log ${1:-master}..${2:-HEAD} --shortstat | grep "files\? changed" | awk '{changes+=($4+$6)} END {print changes}')
  if [[ $diffcount =~ ^-?[0-9]+$ ]] then
    echo "Diff stat changes: $diffcount"
    echo "Log stat changes: $logcount"
    echo "Branch history complexity: $((($logcount - $diffcount) * 100 / $diffcount))%"
  else
    echo "Error: Empty diff between given commits"
  fi
}
alias ghc=githistorycomplexity

gitfilesinseveralcommits() {
  git log ${1:-master}..${2:-HEAD} --name-only --pretty=format:'' | grep . | sort | uniq -d
}
alias gfisc=gitfilesinseveralcommits
