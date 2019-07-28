#!/bin/sh

# note
# this program need sudo permission. 
# please set below config by using sudo visudo
# username     ALL=(ALL) NOPASSWD:ALL


# environment
# git variables
user_name="m8821016"
user_email="m8821016@gmail.com"

# Reset
Color_Off="\033[0m"       # Text Reset

# Regular Colors
Black="\033[0;30m"        # Black
Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Yellow="\033[0;33m"       # Yellow
Blue="\033[0;34m"         # Blue
Purple="\033[0;35m"       # Purple
Cyan="\033[0;36m"         # Cyan
White="\033[0;37m"        # White

title() {
  echo   "                                        "                                                                                        
  echo   "  _|  _   _ | _|_  _  ${Red}.${Color_Off}_     _  _ _|_     ${Red}.${Color_Off}_  "
cecho b  " (_| (/_ _> |< |_ (_) |_)   _> (/_ |_ |_| |_) "
cecho r  "                      |                   |   "
cecho gr " be easy, strong and good     - m8821016" 
cecho gr " --"
}

cecho() {
  local code="\033["
  case "$1" in
    black  | bk) color="${code}0;30m";;
    red    |  r) color="${code}1;31m";;
    green  |  g) color="${code}1;32m";;
    yellow |  y) color="${code}1;33m";;
    blue   |  b) color="${code}1;34m";;
    purple |  p) color="${code}1;35m";;
    cyan   |  c) color="${code}1;36m";;
    gray   | gr) color="${code}0;37m";;
    *) local text="$1"
  esac
  [ -z "$text" ] && local text="$color$2${code}0m"
  echo "$text"
}

title

read -p "Continue to setup desktop (y/n)? " answer
case ${answer} in
  y|Y)
    break
  ;;
  *)
    exit
  ;;
esac

# update
cecho y "\nupdate..."
sudo apt update; sudo apt-get update; sudo apt-get -y autoremove
 
# install basic utils
cecho y "\ninstall basic utils..."
sudo apt-get -y install net-tools iputils-ping ssh curl vim tree xclip lsb npm kolourpaint
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
 
# install notepad++
cecho y "\ninstall editor notepad++..."
sudo apt-get -y install wine-stable notepad-plus-plus wine-stable
sudo snap install notepad-plus-plus
 
# dvp tools
cecho y "\ndvp tools..."
sudo apt-get -y install openjdk-8-jdk git maven virtualbox
 
# config git global variable
cecho y "\nconfig git..."
git config --global user.name $user_name
git config --global user.email $user_email
git config --global core.editor "vim"
 
# mkdir working directory
cecho y "\nmake working directories..."
mkdir dvp && cd dvp && mkdir tools 3party projects recycle
tree ~

# install docker, ref. https://docs.docker.com/install/linux/docker-ce/ubuntu/
cecho y "\ninstall docker..."
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
 
# add docker group
cecho y "\nconfig for docker..."
sudo groupadd docker
sudo usermod -aG docker maxlee
  
# set ACL for user
cecho y "\nset acl for for docker..."
sudo setfacl -m user:maxlee:rw /var/run/docker.sock
sudo docker run hello-world

cd Download
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv -v minikube /usr/local/bin
 
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv -v kubectl /usr/local/bin

# docker autocomplete
cecho y "\ninstall autocomple for docker..."
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

# firewall setting
cecho y "\nfirewall setting..."
sudo apt-get -y install ufw
ufw allow from 192.168.70.2
ufw allow 22
sudo apt-get -y install ssh
/etc/init.d/ssh start

#install postman
cecho y "\ninstall postman"
sudo snap install postman

#completed
cecho b "\nDesktop setup is completed. You are ready to go."
echo ""



