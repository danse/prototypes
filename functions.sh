# install by adding a line like `source ~/prototypes/functions.sh` to
# your `~/.bashrc`
hakyllPostTitle () { echo $(date -Idate)-post-${1:-1}.md; }
gitSave () { git commit -am "$(date)"; }
shameless () { touch "$*" && git add "$*" && gitSave && clear; }
shy () { touch "$*" && clear; }
