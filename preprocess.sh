#!/bin/sh

walk_dir () {    
    shopt -s nullglob dotglob

    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        else
            case "$pathname" in
                *.md|*.doc)
                    printf '%s\n' "$pathname"
            esac
        fi
    done
}

files=$(walk_dir ".")

while IFS= read -r line; do
    sed -e 's/^date\: \([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)[0-9]\{4\}/date\: \1-\2-\3/' -i '' $line
done <<< "$files"
