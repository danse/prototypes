# install by adding a line like `source ~/prototypes/functions.sh` to
# your `~/.bashrc`
hakyllPostTitle () { echo $(date -Idate)-post-${1:-1}.md; }
gitSave () { git add -A && git commit -m "$(date)"; }
fileAndForget () { gitSave && git push ; clear; }
clay () { touch "$*" && git add "$*" && fileAndForget; }
clayShy () { touch "$*" && clear; }
step () { ls -1t; }
