#!/bin/sh

#--------------- colors -----------------
# Reset
NC='\033[0m'       # Text Reset

# Regular Colors
BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
PURPLE='\033[0;35m'       # Purple
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White
#----------------------------------------
#-------------- statuses ----------------
STATUSOK="[$GREEN OK$NC ]"
STATUSERR="[$RED ERR$NC ]"
#----------------------------------------
#-------- log files ---------------------
LOGFILE=pm.log
PACKAGELIST=list.pm
#----------------------------------------
PACKAGES_INFO_DIR=./pmpkgs

printf "" > pm.log

[ ! -d $PACKAGES_INFO_DIR ] && mkdir -v $PACKAGES_INFO_DIR &>> $LOGFILE

#----------- check status function ------
check_status () {
    if [ $? -eq 0 ]; then
        printf "$STATUSOK\n";
    else 
        printf "$STATUSERR\n";
        printf "$YELLOW Check the pm install log file$NC\n"
        exit 1
    fi
}
#----------------------------------------
#---------------- help function ---------------------
help () {
    printf "$YELLOW Use $0 [option] [package_name]\n\n$NC"
    printf "$YELLOW Options:\n"
    printf "\t$GREEN-l, l, list, --list $BLUE->$NC list of installed packages\n"
    printf "\t$GREEN-il, il, localinstall, --localinstall $BLUE->$NC install local package\n"
    printf "\t$GREEN-r, r, remove, --remove $BLUE->$NC remove package\n"
    exit 0
}
#----------------------------------------------------
#--------------- list of installed packages ---------
list_installed_packages () {
    for i in $(cat $PACKAGELIST); do
        echo $i
    done
    # echo $(cat $PACKAGELIST)
    exit 0
}
#---------------------------------------------------
#----------- install local package -----------------
install_local () {
    [ "$2" == "" ] && help
    if [[ "$(cat $PACKAGELIST)" =~ "$2" ]]; then
        printf "$YELLOW This package already installed\n$NC"
        exit 1
    fi
    printf "$GREEN -->$NC install started\n"

    printf "$GREEN -->$NC unpacking "
    printf "$2.tar.gz "
    tar -xvf $2.tar.gz &>> $LOGFILE
    check_status

    printf "$GREEN -->$NC installing "
    $2.package/install.sh &>> $LOGFILE
    mkdir -pv $PACKAGES_INFO_DIR/$2 &>> $LOGFILE
    if [ -f $2.package/rmf ]; then
        cp -v $2.package/rmf $PACKAGES_INFO_DIR/$2 &>> $LOGFILE
        check_status
    fi
    if [ -f $2.package/rmd ]; then 
        cp -v $2.package/rmd $PACKAGES_INFO_DIR/$2 &>> $LOGFILE
        check_status
    fi
    # echo $?
    # check_status

    rm -rv $2.package &>> $LOGFILE
    if [ $? -eq 0 ]; then
        printf "$GREEN instal success\n";
        printf "$2\n" >> $PACKAGELIST
        exit 0
    else 
        printf "$STATUSERR\n";
        printf "$YELLOW Check the pm install log file$NC\n"
        exit 1
    fi
}
#--------------------------------------------------
#-------------- remove package --------------------
remove_package () {
    [ "$2" == "" ] && help
    [ ! -d "$PACKAGES_INFO_DIR/$2" ] && printf "$YELLOW package is not installed\n" && exit 1
    [ -f "$PACKAGES_INFO_DIR/$2/rmf" ] && rm -v $(cat $PACKAGES_INFO_DIR/$2/rmf) &>> $LOGFILE
    [ -f "$PACKAGES_INFO_DIR/$2/rmd" ] && rmdir -v $(cat $PACKAGES_INFO_DIR/$2/rmd) &>> $LOGFILE
    rm -rv $PACKAGES_INFO_DIR/$2 &>> $LOGFILE
    sed -i "/$2/d" "$PACKAGELIST"
    printf "$GREEN $2 removed\n"
}
#--------------------------------------------------
#---------- main ----------------------------------
[ $# -eq 0 ] && help
[ "$1" == "-l" ] || [ "$1" == "l" ] || [ "$1" == "list" ] || [ "$1" == "--list" ] && list_installed_packages
[ "$1" == "-il" ] || [ "$1" == "il" ] || [ "$1" == "localinstall" ] || [ "$1" == "--localinstall" ] && install_local $@
[ "$1" == "-r" ] || [ "$1" == "r" ] || [ "$1" == "remove" ] || [ "$1" == "--remove" ] && remove_package $@
#--------------------------------------------------