echoIf () {
    $@ && echo "$dir";
}

intoEach () {
    base=$(pwd)
    while read dir;
    do cd "$dir";
       $@;
       cd $base;
    done;
}

#ls | intoEach echoIf "test '$(eval git status -s)'"
#ls | intoEach echoIf test '! -e .git' # not a git repo
