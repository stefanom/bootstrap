#!/bin/bash

CONFIG_REPO="git@github.com:stefanom/configs.git"
CONFIG_LOCAL=".cfg"
CONFIG_BACKUP=".config-backup"

if [ -f "$HOME/$CONFIG_LOCAL/HEAD" ]; then
    echo "This account has already been personalized, skipping."
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "git is not available. Install it before running this script."
fi

function config() {
   git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

echo "----> Make sure we're in the $HOME"
cd $HOME

echo "----> Clone the configs git repo $CONFIG_REPO into $HOME/$CONFIG_LOCAL"
git clone --bare $CONFIG_REPO "$HOME/$CONFIG_LOCAL"
 
echo "----> Checkout a local copy directly in $HOME"
config checkout

if [ $? = 0 ]; then
    echo "Checked out config to $HOME"
else
    echo "There were pre-existing files that would be overridden, so let's back them up."
    IFS=
    config checkout 2>&1 | while read -r line; do
        if [[ $line =~ ^[[:blank:]] ]]; then
            file=$(echo $line | awk '{print $1}')
            echo "  * File $file conflicts, moving it to $HOME/$CONFIG_BACKUP/$file"
            mkdir -p "$HOME/$CONFIG_BACKUP/$file"
            mv "$file" "$HOME/$CONFIG_BACKUP/$file"
        fi
    done
fi

config checkout

echo "----> Tell git to ignore the untracked files in $HOME"
config config status.showUntrackedFiles no

loading_block='

# -------- personalized configs -----------
if [ -f "$HOME/.bash_user" ]; then 
    . "$HOME/.bash_user"
fi
'

bashrc="$HOME/.bashrc"

if ! grep -qF -- ".bash_user" "$bashrc"; then
    echo "Appending the personalized configs loading block to $bashrc"
    echo "$loading_block" >> "$bashrc"
else
    echo "Personalized configs loading block already present in $bashrc, skipping."
fi

echo ""
echo "All done! Type `. .bashrc` to load the new environment and `rig` to finish the installation."
echo ""
