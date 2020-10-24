
# install by adding a line like `source ~/prototypes/functions.sh` to your `~/.bashrc`

step () { ls -1t; }
pop() { cat "$@" && rm "$@"; }
push(){ echo >> "$1" && cat >> "$1"; }
gagrep () { grep -Rli "$@" *; }
gafind () { find -iname "*$@*"; }
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
stef() { s=$(step | tail -n1) && cat "$s" && touch "$s" && echo "\ $s"; }
slight () { t=/tmp/$(date -Iseconds); mkdir "$t" && mv * "$t"; mv "$t" "$1"; }
turn () { echo "moves everything into a new div -- prototypes/functions.sh"; }
trim () { echo "remove spaces on the right side -- prototypes/functions.sh"; }
tag-overlaps-find () { find "$1"/* | while read f; do tag-ged-find "$f"; done }
tag-root-clone () { ls "$1/tags" | while read tag; do mkdir -p "tags/$tag"; done; }
tag-overlaps () { tag-overlaps-find "$1" | cut -d "/" -f 3 | sort | uniq -c | sort -rn ; }
tag-root-merge () { echo "functions.sh"; } # ls "$1/tags" | while read tag; do cp "$1/tags/$tag/*" "$2/tags/$tag"; done; }
tag-ged-find () { find . -samefile "$1" 2> /dev/null; } # https://unix.stackexchange.com/questions/201920/how-to-find-all-hard-links-to-a-given-file

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
    while sleep 10m; do date; done & ping amazon.com -f -i1;
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

tag-ged-stats () {
    ls tags/ | while read t
    do echo -n "$t "
       ls "tags/$t" | wc -l
    done | sort -nr -k 2
}

alias neck=turn
alias fold=turn
alias past=turn
alias density=sieve
alias sediment=sieve
alias cave="runhaskell ~/lab/prototypes/cave.hs"

tag-ged-remove () {
    h=$(pwd)
    n=$(basename $1)
    rm -v $h/tags/*/"$n";
}

markupLintInPlace () {
    xmllint --format "$@" > /tmp/formatted && mv /tmp/formatted "$@"
}

