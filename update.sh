#!/bin/bash

if command -v apt > /dev/null 2>&1; then
    echo "apt found in PATH. Updating the system..."
    echo "NOTE: this might take a while!"

    sudo apt update -y
    sudo apt upgrade -y
    sudo apt autoremove -y

    if [ -f /var/run/reboot-required ] || [ -f /run/reboot-required ]; then
        if [[ $(uname -r) != *"microsoft"* ]]; then
            sudo reboot
        else
            # We can't reboot from inside WSL so just suggest the next actions
            echo "The system requires a reboot. Close this terminal and call `wsl --shutdown` to reboot."
        fi
    fi
else
    echo "apt not found in PATH. There is nothing for me to do."
fi
