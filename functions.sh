# install by adding a line like `source ~/prototypes/functions.sh` to
# your `~/.bashrc`
hakyllPostTitle () { echo $(date -Idate)-post-${1:-1}.md; }
gitSave () { git add -A && git commit -m "$(date)"; }
gitSaveShy () { git commit -am "$(date)"; }
fileAndForget () { gitSave && git push ; clear; }
fileAndForgetShy () { gitSaveShy && git push ; clear; }
clay () { touch "$*" && git add "$*" && fileAndForget; }
clayShy () { touch "$*" && clear; }
step () { ls -1t; }
# look everywhere in small repos like rotterdam
gagrep () { grep -Rli "$@" *; }
gafind () { find -iname "*$@*"; }
allGit () { ls -d */.git | while read d; do d="${d%/.git}"; cd $d; git $@; cd ../; done }
markupLintInPlace () {
    xmllint --format "$@" > /tmp/formatted && mv /tmp/formatted "$@"
}
abs() {
    local PARENT_DIR=$(dirname "$1")
    cd "$PARENT_DIR"
    local ABS_PATH="$(pwd)"/"$(basename $1)"
    cd - >/dev/null
    echo $ABS_PATH
} # from http://jeetworks.org/node/98
