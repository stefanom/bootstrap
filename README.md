# Bootstrap

This repository contains scripts that can be invoked directly from the command line on new Linux installations (either in WSL or rPI) to automate various activities.

Here are the command lines for how we expect the scripts to be invoked:

## Update.sh

This [script]("update.sh") runs apt to update and upgrade the system. Since this could also result in a kernel upgrade, the script reboots the system at the end.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stefanom/bootstrap/main/update.sh | sh
```

## Personalize

This [script](personalize.sh) installs modern dotconfigs for the environment stored in this [git repo](https://github.com/stefanom/configs). This script automates the use of [a bare git] repository to manage dotfiles in version control.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stefanom/bootstrap/main/personalize.sh | sh
```
