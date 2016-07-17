#!/bin/bash

# Author - Neil "regalstreak" Agarwal
# 2016


# Definitions
BRANCH=$3
DIR=$(pwd)
LINK=$2
ROMNAME=$1


# Functions
romsync(){
    cd $DIR;mkdir -p $ROMNAME/full;cd $ROMNAME/full
    
    repo init -u $LINK -b $BRANCH

    # Gather the number of threads
    CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
    # Use 8 times the cpucount
    THREAD_COUNT_SYNC=$(($CPU_COUNT * 8))
    
    # Sync it up!
    time repo sync -c -f --force-sync --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC
}

separatestuff(){
    cd $DIR/$ROMNAME/

    # Only repo folder
    mkdir $ROMNAME-$BRANCH-repo-$(date +%Y%m%d)
    mv full/.repo $ROMNAME-$BRANCH-repo-$(date +%Y%m%d)
    
    # Without repo folder
    mkdir $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d)
    mv full/* $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d)
}

compressstuff(){
    cd $DIR/$ROMNAME/
    export XZ_OPT=-9e
    
    # Only repo folder
    time tar -cvJf $ROMNAME-$BRANCH-repo-$(date +%Y%m%d).tar.xz $ROMNAME-$BRANCH-repo-$(date +%Y%m%d)/
    
    # Without repo folder
    time tar -cvJf $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d).tar.xz $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d)/
}

uploadstuff(){
    # Definitions
    HOST="yourhost"
    USER="yourid"
    PASSWD="yourpw"
    REPO="$ROMNAME-$BRANCH-repo-$(date +%Y%m%d).tar.xz"
    NOREPO="$ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d).tar.xz"
    
    # Check if user has wput, if not install it
    if [ !$( which wput ) ]; then
      echo "Installing wput for uploading"
      sudo apt install wput
    fi
    
    cd $DIR/$ROMNAME/

    # Upload Repo Only
    wput $REPO ftp://"$USER":"$PASSWD"@"$HOST"/

    # Upload No Repo
    wput $NOREPO ftp://"$USER":"$PASSWD"@"$HOST"/
    
}


romsync
separatestuff
compressstuff
uploadstuff

echo "Thank you"
