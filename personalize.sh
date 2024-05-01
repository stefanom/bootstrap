#!/bin/bash

CONFIG_REPO="git@github.com:stefanom/configs.git"
CONFIG_LOCAL=".cfg"
CONFIG_BACKUP=".config-backup"

if [ -f "$HOME/$CONFIG_LOCAL/HEAD" ]; then
    echo "This account has already been personalized, skipping."
    exit 1
fi

function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
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

echo "----> Saving old $HOME/.profile to $HOME/.profile.old"
cp .profile .profile.old

echo "----> Replacing $HOME/.profile for our new environment"
curl -o .profile https://raw.githubusercontent.com/stefanom/configs/main/.profile

echo "----> Reload the enviornment with the new configurations"
. ~/.profile

echo ""
echo "All done! Enjoy!"
echo "
