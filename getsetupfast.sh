#!/bin/bash
#ask for root privileges at the start
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# SET HOME DIR
read -p "Enter the system's username for getsetupfast to use: " USR
HOMEDIR="/home/"$USR
# Where to install anaconda and zotero to. If zou want to install it into /HOME,
# then remove '/Applications'
APP_DIR="$HOMEDIR/Applications"
DIR=$(pwd)

#Runs inputs as user from within root
runasuser() {
    sudo -u $USR $1
}

# check whether user exists.
if [ -d $HOMEDIR ]
then

  # ---- create application folder ----
  echo CREATING APPLICATIONS FOLDER
  runasuser "mkdir $APP_DIR"

  # ---- update system ---
  echo UPDATING SYSTEM
  apt-get update && apt-get upgrade -y

  # download, unpack and create desktop shortcut for zotero
  echo DOWNLOADING ZOTERO
  curl -sL https://apt.retorque.re/file/zotero-apt/install.sh | sudo bash
  
  # ---- prerequisites for spotify ---
  curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

  # ---- update system channels ---
  echo UPDATING REPOS / CHANNELS AGAIN
  apt-get update

  # ---- install applications ----
  # -- install applications via apt-get install --
  echo INSTALLING PACKAGES FROM REPOS
  DEBIAN_FRONTEND=noninteractive apt-get install -y $(grep -vE "^\s*#" apt-get.txt  | tr "\n" " ")

  # -- install applications via gnome-software --
  gnome-software --install=$(grep -vE "^\s*#" gnome-software.txt  | tr "\n" " ")

  # -- install applications via snap --
  snap install $(grep -vE "^\s*#" snaps.txt  | tr "\n" " ")

  # -- download .deb and install --
  # download .deb files and name them with {count}.deb
  echo DOWNLOADING DEBS
  runasuser "mkdir debs"
  ((count = 1))
  for name  in $(grep -vE "^\s*#" deb_URLs.txt  | tr "\n" " ")
  do
  runasuser "wget $name -O ./debs/$count.deb"
  ((count++))
  done

  # unpack all downloads and remove archives
  # tar -C ./debs/ -xf ./debs/*.tar.xz -v
  # tar -C ./debs/ -xf ./debs/*.tar -v
  # rm ./debs/*.tar
  # rm ./debs/*.tar.xz

  install .debs
  echo INSTALLING DEBS
  for name in ./debs/*.deb
  do 
  DEBIAN_FRONTEND=noninteractive apt -y install $name
  done

  ## download and install anaconda
  echo DOWNLOADING AND INSTALLING ANACONDA
  runasuser "wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh -O $HOMEDIR/Downloads/anaconda.sh"
  runasuser "bash $HOMEDIR/Downloads/anaconda.sh -b -p $APP_DIR/anaconda3"
  #opens subshell with user privileges
  runasuser "bash anaconda_init.sh"

  #cleaning up installation
  echo REMOVING OBSOLETE PACKAGES
  apt-get autoremove -y

  #ASK WHETHER TO DELETE GETSETUP OR DEBS
  while true; do
    read -p "Do you want to delete all installation files used in getsetupfast? [Y,n]: " ANS
    case $ANS in 
      'Y') 
        delete=1
        break;;
      'n') 
        delete=0  
        break;;
      *) 
        echo "Wrong answer, try again";;
    esac
  done

  if [ $delete = 1 ]; then
    cd ..
    rm -rf ./getsetupfast
    #umount -f -l /mnt/NAS
    echo DELETED SETUP FOLDER
  fi
  echo FINISHED SETTING UP


else
  echo THE USER PROVIDED DOES NOT EXIST
fi

exit
