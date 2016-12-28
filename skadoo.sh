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
    # VENDOREDIT
    if [ "$HUTIYA" != "nope" ]; then

        # Check if repo is installed
        if [ $( which repo ) == "" ]; then
          echo "Installing repo for Downloading the sources"
          sudo apt install repo
        fi

        # Check if user has bc, if not install it
        if [ $( which bc ) == "" ]; then
          echo "Installing bc"
          sudo apt install bc
        fi

        # Check if user has pxz, if not install it
        if [ $( which pxz ) == "" ]; then
          echo "Installing pxz for multi-threaded compression"
          sudo apt install pxz
        fi

        # Check if user has wput, if not install it
        if [ $( which wput )  == "" ]; then
          echo "Installing wput for uploading"
          sudo apt install wput
        fi

    fi

}

checkstarttime(){

    # Check the starting time
    TIME_START=$(date +%s.%N)

    # Show the starting time
    echo -e "Starting time:$(echo "$TIME_START / 60" | bc) minutes $(echo "$TIME_START" | bc) seconds"
}

checkfinishtime(){
    # Check the finishing time
    TIME_END=$(date +%s.%N)

    # Show the ending time
    echo -e "Ending time:$(echo "$TIME_END / 60" | bc) minutes $(echo "$TIME_END" | bc) seconds"

    # Show total time taken to upoload
    echo -e "Total time elapsed:$(echo "($TIME_END - $TIME_START) / 60" | bc) minutes $(echo "$TIME_END - $TIME_START" | bc) seconds"
}


doshallow(){
    cd $DIR; mkdir -p $ROMNAME/shallow; cd $ROMNAME/shallow

    repo init -u $LINK -b $BRANCH --depth 1 -q --reference $DIR/$ROMNAME/full/

    THREAD_COUNT_SYNC=8

    # Sync it up!
    time repo sync -c -f --force-sync --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC


    cd $DIR/$ROMNAME/

    mkdir $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)
    mv shallow/.repo/ $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)
    cd $DIR/$ROMNAME/
    export XZ_OPT=-9e
    time tar -I pxz -cvf $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).tar.xz $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)/
    # Definitions
    if [ -z "$HOST" ]; then
        echo "Please read the instructions"
        echo "HOST is not set"
        echo "Uploading failed"
        exit 1
    fi

    if [ -z "$USER" ]; then
        echo "Please read the instructions"
        echo "USER is not set"
        echo "Uploading failed"
        exit 1
    fi

    if [ -z "$PASSWD" ]; then
        echo "Please read the instructions"
        echo "PASSWD is not set"
        echo "Uploading failed"
        exit 1
    fi

    SHALLOW="$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).tar.xz"

    cd $DIR/$ROMNAME/

}

dofull(){
    cd $DIR; mkdir -p $ROMNAME/full; cd $ROMNAME/full

    repo init -u $LINK -b $BRANCH

    THREAD_COUNT_SYNC=8

    # Sync it up!
    time repo sync -c -f --force-sync -q --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC


    cd $DIR/$ROMNAME/

    mkdir $ROMNAME-$BRANCH-full-$(date +%Y%m%d)
    mv full/.repo $ROMNAME-$BRANCH-full-$(date +%Y%m%d)
    cd $DIR/$ROMNAME/
    export XZ_OPT=-9e
    time tar -I pxz -cvf $ROMNAME-$BRANCH-full-$(date +%Y%m%d).tar.xz $ROMNAME-$BRANCH-full-$(date +%Y%m%d)/
    # Definitions
    if [ -z "$HOST" ]; then
        echo "Please read the instructions"
        echo "HOST is not set"
        echo "Uploading failed"
        exit 1
    fi

    if [ -z "$USER" ]; then
        echo "Please read the instructions"
        echo "USER is not set"
        echo "Uploading failed"
        exit 1
    fi

    if [ -z "$PASSWD" ]; then
        echo "Please read the instructions"
        echo "PASSWD is not set"
        echo "Uploading failed"
        exit 1
    fi

    FULL="$ROMNAME-$BRANCH-full-$(date +%Y%m%d).tar.xz"

    cd $DIR/$ROMNAME/

}

upload(){
  if [ -e $FULL ]; then
    wput $FULL ftp://"$USER":"$PASSWD"@"$HOST"/
  else
    echo "$FULL does not exist. Not uploading the shallow tarball."
  fi

  if [ -e $SHALLOW ]; then
  wput $SHALLOW ftp://"$USER":"$PASSWD"@"$HOST"/
  else
  echo "$SHALLOW does not exist. Not uploading the shallow tarball."
  fi

}
# Do All The Stuff

doallstuff(){
    # Start the counter
    checkstarttime

    # Install stuff
    installstuff

    # Compress full
    dofull

    # Compress shallow
    doshallow

    # Upload that shit
    upload

    checkfinishtime
}


# So at last do everything
doallstuff
if [ $? -eq 0 ]; then
  echo "Everything done!"
  rm -rf $DIR/$ROMNAME
else
  echo "Something failed :(";
  rm -rf $DIR/$ROMNAME/shallow $DIR/$ROMNAME/full
  exit 1;
fi
