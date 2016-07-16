#!/bin/bash

# Author - Neil "regalstreak" Agarwal
# 2016


# Definitions
DIR=`pwd`
LINK=$2
ROMNAME=$1


# Functions
romsync(){
    cd $DIR;mkdir -p $ROMNAME/full;cd $ROMNAME/full
    
    repo init $LINK

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
    mkdir $ROMNAME-repo-$(date +%Y%m%d)
    mv full/.repo $ROMNAME-repo-$(date +%Y%m%d)
    
    # Without repo folder
    mkdir $ROMNAME-no-repo-$(date +%Y%m%d)
    mv full/* $ROMNAME-no-repo-$(date +%Y%m%d)
}

compressstuff(){
    cd $DIR/$ROMNAME/
    export XZ_OPT=-9e
    
    # Only repo folder
    time tar -cvJf "$ROMNAME-repo-$(date +%Y%m%d).tar.xz $ROMNAME-repo-$(date +%Y%m%d)/"
    
    # Without repo folder
    time tar -cvJf "$ROMNAME-no-repo-$(date +%Y%m%d).tar.xz $ROMNAME-no-repo-$(date +%Y%m%d)/"
}

uploadstuff(){
    # Definitions
    HOST='yourhost'
    USER='yourid'
    PASSWD='yourpw'
    REPO='$ROMNAME-repo-$(date +%Y%m%d).tar.xz'
    NOREPO='$ROMNAME-no-repo-$(date +%Y%m%d).tar.xz'

    cd $DIR/$ROMNAME/

# Upload Repo Only
ftp -n $HOST <<EOF
quote USER $USER
quote PASS $PASSWD
put $REPO
quit
EOF

# Upload No Repo
ftp -n $HOST <<EOF
quote USER $USER
quote PASS $PASSWD
put $NOREPO
quit
EOF
    
}


romsync
separatestuff
compressstuff
uploadstuff

echo "Thank you"