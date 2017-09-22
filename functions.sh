# install by adding a line like `source ~/prototypes/functions.sh` to
# your `~/.bashrc`
hakyllPostTitle () { echo $(date -Idate)-post-${1:-1}.md; }
gitSave () { git commit -am "$(date)"; }
fileAndForget () { gitSave && git push ; clear; }
shameless () { touch "$*" && git add "$*" && fileAndForget; }
shy () { touch "$*" && clear; }
