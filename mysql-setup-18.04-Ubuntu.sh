#!/bin/sh

# note
# please download mysql-5.7.27-linux-glibc2.12-x86_64.tar.gz to $mysql_base 


# environment
mysql_base="/home/maxlee/dvp/3party"
mysql_home="/home/maxlee/dvp/3party/mysql"
mysql_tar="mysql-5.7.27-linux-glibc2.12-x86_64.tar.gz"

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
    echo "                                      " 
    echo " ${Red}.${Color_Off}_ _      _  _${Red}.${Color_Off} |    _  _ _|_     ${Red}.${Color_Off}_ " 
cecho b  " | | | \/ _> (_| |   _> (/_ |_ |_| |_)" 
cecho y  "       /       |                   |  " 
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

continued() {
  echo ""
  read -p "Continue to setup desktop (y/n)? " answer
  case ${answer} in
    y|Y)
      break
    ;;
    *)
      exit
    ;;
  esac
}

checkDownloaded() {
  if [ ! -f $mysql_base/$mysql_tar ]; then 
    cecho r "\nNot found $mysql_base/$mysql_tar. Please download it from mysql site first."
    exit 
  fi
}

checkIsMySqlInstalled() {
  if [ -d $mysql_home/bin ]; then 
    cecho r "\nFound mysql installed in $mysql_base."
    showStartCommand
    exit
  fi
}

installRequiredLibaio() {
  cecho y "\ninstall libaio ..."
  apt-get install libaio1 libaio-dev
}

extractMySql() {
  cecho y "\nextract mysql $mysql_tar..."
  cd $mysql_base
  tar -xzf $mysql_tar
  mv `echo $mysql_tar | sed -e s/.tar.gz//g` mysql
}

installMySql() {
  cecho y "\ncreate mysql user..."
  groupadd mysql
  useradd -r -g mysql -s /bin/false mysql
  # note
  # -r: Create a system account which is reserved for services and daemons for limiting the access to files.. A user with a UID lower than the value of UID_MIN defined in /etc/login.defs and whose password does not expire. Note that useradd will not create a home directory for such an user, regardless of the default setting in /etc/login.defs.
  # -s /bin/false: immediately exits, returning false. /bin/true is same to let someone immediately exits but return true. /sbin/nologin is more user friendly to give user a customized message from /etc/nologin.txt.


  cecho y "\nlink folder..."
  ln -s $mysql_home/ /usr/local/mysql

  cecho y "\ncreate mysql-files..." 
  cd $mysql_home
  mkdir mysql-files
  chown mysql:mysql mysql-files
  chmod 705 mysql-files
  # note
  # the server limits import and export operations to work only with files in that directory. The directory must exist; the server will not create it. https://dev.mysql.com/doc/refman/8.0/en/data-directory-initialization.html

  cecho y "\ninitial mysql..."
  cd $mysql_home/bin
  ./mysqld --initialize --user=mysql

  cecho y "\nsetup ssl..."
  ./mysql_ssl_rsa_setup
}

completed() {
  cecho b "\nmysql setup is completed. You are ready to go."
  showStartCommand
  echo ""
}

showStartCommand(){
  echo "\nNote: It is important that the MySQL server be run using an unprivileged (non-root) login account. To ensure this, run mysqld_safe as rootand include the --user option"
  cecho b "./mysqld_safe --user=mysql &"
  echo ""
}

checkIsRoot() {
  if [ `whoami` != "root" ]; then 
    cecho r "\nPlease change user to root!"
    exit
  fi
}

main() {
  title
  checkIsRoot
  checkIsMySqlInstalled
  continued
  installRequiredLibaio
  extractMySql
  installMySql
  completed
}

main
