
# install by adding a line like `source ~/prototypes/functions.sh` to your `~/.bashrc`

del(){ mv "$@" /tmp; }
stepShow () { ls -1t; }
pop() { cat "$@" && del "$@"; }
push(){ echo >> "$1" && cat >> "$1"; }
gagrep () { grep -Rli "$@" *; }
gafind () { find -iname "*$@*"; }
backup () { cp "$@" "$@.backup"; }
stick () { echo "$1" >> ~/.stick; }
grepHome () { grep -d skip $@ ~/*; }
pour () { mv "$1"/* . && rmdir "$1"; }
rankcount () { cat -b $@ | tail -n 3; }
gitSaveShy () { git commit -am "$(date)"; }
locateVisible () { locate $@ | grep -v "/\." ; }
gitSave () { git add -A && git commit -m "$(date)"; }
github-clone () { git clone "git@github.com:${@}.git"; }
gitCheck () { cd $@ && git status && git branch && cd -; }
hakyllPostTitle () { echo $(date -Idate)-post-${1:-1}.md; }
fileAndForget () { gitSave && git push origin HEAD; clear; }
clavado-wrapped () { echo $(clavado) && cd $(clavado) && lt; }
map () { local f="$1"; shift; while read a; do "$f" $a; done; }
fileAndForgetShy () { gitSaveShy && git push origin HEAD; clear; }
slight () { t=/tmp/$(date -Iseconds); mkdir "$t" && mv * "$t"; mv "$t" "$1"; }
turn () { echo "moves everything into a new div -- prototypes/functions.sh"; }
trim () { echo "remove spaces on the right side -- prototypes/functions.sh"; }

allGit () {
    ls -d */.git | while read d
    do d="${d%/.git}"
       cd $d
       echo $d
       git status $@
       cd ../
    done
}

net-reliability-meter() {
    cd /tmp/;
    clear;
    while sleep 10m; do date; done & ping google.com -f -i1;
    kill %-;
    cd -;
}

abs() {
    local PARENT_DIR=$(dirname "$1")
    cd "$PARENT_DIR"
    local ABS_PATH="$(pwd)"/"$(basename $1)"
    cd - >/dev/null
    echo $ABS_PATH
} # from http://jeetworks.org/node/98

alias neck=turn
alias fold=turn
alias past=turn
alias density=sieve
alias sediment=sieve
alias cave="runhaskell ~/lab/prototypes/cave.hs"

markupLintInPlace () {
    xmllint --format "$@" > /tmp/formatted && mv /tmp/formatted "$@"
}

