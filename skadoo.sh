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

    echo -e "SHALLOW | Starting to sync."

    cd $DIR; mkdir -p $ROMNAME/shallow; cd $ROMNAME/shallow

    repo init -u $LINK -b $BRANCH --depth 1 -q --reference $DIR/$ROMNAME/full/

    THREAD_COUNT_SYNC=32

    # Sync it up!
    time repo sync -c -f --force-sync --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC

    echo -e "SHALLOW | Syncing done. Moving and compressing."

    cd $DIR/$ROMNAME/

    mkdir $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)
    mv shallow/.repo/ $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)
    cd $DIR/$ROMNAME/
    mkdir shallowparts
    export XZ_OPT=-9e
    time tar -I pxz -cf - $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)/ | split -b 4800M - shallowparts/$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).tar.xz.

    echo -e "SHALLOW | Compressing done. Taking md5sums."

    md5sum shallowparts/* > $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).parts.md5sum

    SHALLOW="shallowparts/$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).tar.xz.*"
    SHALLOWMD5="$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).parts.md5sum"

    cd $DIR/$ROMNAME/

    echo -e "SHALLOW | Done."

}

dofull(){

    echo -e "FULL | Starting to sync."

    cd $DIR; mkdir -p $ROMNAME/full; cd $ROMNAME/full

    repo init -u $LINK -b $BRANCH

    THREAD_COUNT_SYNC=32

    # Sync it up!
    time repo sync -c -f --force-sync -q --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC

    echo -e "FULL | Syncing done. Moving and compressing."

    cd $DIR/$ROMNAME/

    mkdir $ROMNAME-$BRANCH-full-$(date +%Y%m%d)
    mv full/.repo $ROMNAME-$BRANCH-full-$(date +%Y%m%d)
    cd $DIR/$ROMNAME/
    mkdir fullparts
    export XZ_OPT=-9e
    time tar -I pxz -cf - $ROMNAME-$BRANCH-full-$(date +%Y%m%d)/ | split -b 4800M - fullparts/$ROMNAME-$BRANCH-full-$(date +%Y%m%d).tar.xz.

    echo -e "FULL | Compressing done. Taking md5sums."

    md5sum fullparts/* > $ROMNAME-$BRANCH-full-$(date +%Y%m%d).parts.md5sum

    FULL="fullparts/$ROMNAME-$BRANCH-full-$(date +%Y%m%d).tar.xz.*"
    FULLMD5="$ROMNAME-$BRANCH-full-$(date +%Y%m%d).parts.md5sum"

    cd $DIR/$ROMNAME/

    echo -e "FULL | Done."

}

sort(){

    echo -e "Begin to sort."

    cd $DIR/$ROMNAME
    mkdir upload
    cd upload
    mkdir -p $ROMNAME/$BRANCH
    cd $ROMNAME/$BRANCH
    mkdir shallow
    mkdir full
    cd $DIR/$ROMNAME
    mv $FULL upload/$ROMNAME/$BRANCH/full
    mv $SHALLOW upload/$ROMNAME/$BRANCH/shallow
    mv $FULLMD5 upload/$ROMNAME/$BRANCH/full
    mv $SHALLOWMD5 upload/$ROMNAME/$BRANCH/full

    echo -e "Done sorting."

}

upload(){

    echo -e "Begin to upload."

    cd $DIR/$ROMNAME/upload
    rsync -avPh --relative -e ssh $ROMNAME regalstreak@frs.sourceforge.net:/home/frs/project/skadoosh/

    echo -e "Done uploading."

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

    # Sort out all for scp upload
    sort

    # Upload that shit
    upload

    checkfinishtime
}


# So at last do everything
doallstuff
if [ $? -eq 0 ]; then
  echo "Everything done!"
#  rm -rf $DIR/$ROMNAME
else
  echo "Something failed :(";
#  rm -rf $DIR/$ROMNAME/shallow $DIR/$ROMNAME/full $DIR/$ROMNAME/shallowparts $DIR/$ROMNAME/fullparts $DIR/$ROMNAME/$SHALLOWMD5 $DIR/$ROMNAME/$FULLMD5 $DIR/$ROMNAME/upload
  exit 1;
fi
