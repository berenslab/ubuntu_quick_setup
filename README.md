This repository was conceived as a way to quickly get up and running again after a fresh install of Ubuntu.

## What it will do:
- Extract config files of all your conda environments.
- Install a bunch of prespecified programmes from different sources without any intervention necessary.
- Install Anaconda 3, initialise it and set up your environments.

## What it won't do:
- Migrate any data
- Migrate any configs

...although feel free to add such functionalities or adapt it to your needs. If you do, consider making a pull request.

## How to use it?
### On your old system:
1. Activate conda and run `update_envs.py` (delete dummy `environment.yml` in `conda_envs`).
2. Check if applications you want to install as a snap are listed in snaps.txt and comment out those that you don't need.
3. Check if applications you want to install via apt are listed in apt-get.txt and that you have added their channels. Comment out those that you don't need.
4. Check if sources for all applications you want to download and install via a .deb are listed in deb_URLs.txt and those that you don't need are commented out.
5. Check if applications you want to install via the gnome-software center are listed in gnome-software.txt and those that you don't need are commented out.

6. Copy folder to new system.

### On your new system:
7. Change into directory with `cd getsetupfast` and start the setup with `bash getsetupfast.sh`.
8. When prompted give root privileges, specify username and watch it handle the rest for you. 
