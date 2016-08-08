#!/bin/bash

# Authors - Neil "regalstreak" Agarwal, Harsh "MSF Jarvis" Shandilya, Tarang "DigiGoon" Kagathara
# 2016


# Definitions
BRANCH=$3
DIR=$(pwd)
LINK=$2
ROMNAME=$1


# Functions
installstuff(){
    # Check if repo is installed
    if [ !$( which repo ) ]; then
      echo "Installing repo for Downloading the sources"
      sudo apt install repo
    fi
    
    # Check if user has bc, if not install it
    if [ !$( which bc ) ]; then
      echo "Installing bc"
      sudo apt install bc
    fi
    
    # Check if user has pxz, if not install it
    if [ !$( which pxz ) ]; then
      echo "Installing pxz for multi-threaded compression"
      sudo apt install pxz
    fi
    
    # Check if user has wput, if not install it
    if [ !$( which wput ) ]; then
      echo "Installing wput for uploading"
      sudo apt install wput
    fi
}

romsync(){
    cd $DIR;mkdir -p $ROMNAME/full;cd $ROMNAME/full

    repo init -u $LINK -b $BRANCH
    THREAD_COUNT_SYNC=49
    if [ $(hostname) != 'krieger' ];then
    # Gather the number of threads
    CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
    # Use 8 times the cpucount
    THREAD_COUNT_SYNC=$(($CPU_COUNT * 8))
    fi
    
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
    if [ $compressrepo ]; then
    time tar -I pxz -cvf $ROMNAME-$BRANCH-repo-$(date +%Y%m%d).tar.xz $ROMNAME-$BRANCH-repo-$(date +%Y%m%d)/
    fi

    # Without repo folder
    if [ $compressnorepo ]; then
    time tar -I pxz -cvf $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d).tar.xz $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d)/
    fi
}

# Check the starting time
TIME_START=$(date +%s.%N)
# Show the starting time
echo -e "Starting time:$(echo "$TIME_START / 60" | bc) minutes $(echo "$TIME_START" | bc) seconds"

uploadstuff(){
    # Definitions
    HOST="uploads.androidfilehost.com"
    if [ !$USER ]; then
      USER="yourid"
    fi
    if [ !$PASSWD ]; then
      PASSWD="yourpw"
    fi
    REPO="$ROMNAME-$BRANCH-repo-$(date +%Y%m%d).tar.xz"
    NOREPO="$ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d).tar.xz"

    cd $DIR/$ROMNAME/

    if [ $compressrepo ]; then
    # Upload Repo Only
    wput $REPO ftp://"$USER":"$PASSWD"@"$HOST"/
    fi
    if [ $compressnorepo ]; then
    # Upload No Repo
    wput $NOREPO ftp://"$USER":"$PASSWD"@"$HOST"/
    fi

}
cleanup(){
    cd $DIR;rm -rf $ROMNAME
}

# Check the finishing time
TIME_END=$(date +%s.%N)
# Show the ending time
echo -e "Ending time:$(echo "$TIME_END / 60" | bc) minutes $(echo "$TIME_END" | bc) seconds"
# Show total time taken to upoload
echo -e "Total time elapsed:$(echo "($TIME_END - $TIME_START) / 60" | bc) minutes $(echo "$TIME_END - $TIME_START" | bc) seconds"

installstuff
romsync
separatestuff
compressstuff
uploadstuff
cleanup

echo "Thank you"
