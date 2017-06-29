#!/bin/bash

# Authors - Neil "regalstreak" Agarwal, Harsh "MSF Jarvis" Shandilya, Tarang "DigiGoon" Kagathara
# 2017


# Definitions
BRANCH=$3
DIR=$(pwd)
LINK=$2
ROMNAME=$1

# Colors
CL_XOS="\033[34;1m"
CL_PFX="\033[33m"
CL_INS="\033[36m"
CL_RED="\033[31m"
CL_GRN="\033[32m"
CL_YLW="\033[33m"
CL_BLU="\033[34m"
CL_MAG="\033[35m"
CL_CYN="\033[36m"
CL_RST="\033[0m"

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

    echo -e $CL_RED"SHALLOW | Starting to sync."$CL_RST

    cd $DIR; mkdir -p $ROMNAME/shallow; cd $ROMNAME/shallow

    repo init -u $LINK -b $BRANCH --depth 1 -q

    THREAD_COUNT_SYNC=32

    # Sync it up!
    time repo sync -c -f -q --force-sync --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC

    echo -e $CL_RED"SHALLOW | Syncing done. Moving and compressing."$CL_RST

    cd $DIR/$ROMNAME/

    mkdir $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)
    mv shallow/.repo/ $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)
    cd $DIR/$ROMNAME/
    mkdir shallowparts
    export XZ_OPT=-9e
    time tar -I pxz -cf - $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)/ | split -b 4500M - shallowparts/$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).tar.xz.

    SHALLOW="shallowparts/$ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).tar.xz.*"

    cd $DIR/$ROMNAME/

    echo -e $CL_RED"SHALLOW | Done."$CL_RST

    echo -e $CL_RED"SHALLOW | Sorting."$CL_RST

    sortshallow
    upload

    cd $DIR/ROMNAME

    echo -e $CL_RED"SHALLOW | Cleaning"$CL_RST

    rm -rf upload
    rm -rf shallow
    rm -rf $SHALLOWMD5
    rm -rf shallowparts
    rm -rf $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d)

}

dofull(){

    echo -e $CL_CYN"FULL | Starting to sync."$CL_RST

    cd $DIR; mkdir -p $ROMNAME/full; cd $ROMNAME/full

    repo init -u $LINK -b $BRANCH -q

    THREAD_COUNT_SYNC=32

    # Sync it up!
    time repo sync -c -f --force-sync -q --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC

    echo -e $CL_CYN"FULL | Syncing done. Moving and compressing."$CL_RST

    cd $DIR/$ROMNAME/

    mkdir $ROMNAME-$BRANCH-full-$(date +%Y%m%d)
    mv full/.repo $ROMNAME-$BRANCH-full-$(date +%Y%m%d)
    cd $DIR/$ROMNAME/
    mkdir fullparts
    export XZ_OPT=-9e
    time tar -I pxz -cf - $ROMNAME-$BRANCH-full-$(date +%Y%m%d)/ | split -b 4500M - fullparts/$ROMNAME-$BRANCH-full-$(date +%Y%m%d).tar.xz.

    FULL="fullparts/$ROMNAME-$BRANCH-full-$(date +%Y%m%d).tar.xz.*"

    cd $DIR/$ROMNAME/

    echo -e $CL_CYN"FULL | Done."$CL_RST

    echo -e $CL_CYN"FULL | Sorting"$CL_RST

    sortfull
    upload

    cd $DIR/ROMNAME

    echo -e $CL_CYN"FULL | Cleaning"$CL_RST

    rm -rf upload
    rm -rf full
    rm -rf $FULLMD5
    rm -rf fullparts
    rm -rf $ROMNAME-$BRANCH-full-$(date +%Y%m%d)

}

sortshallow(){

    echo -e $CL_RED"SHALLOW | Begin to sort."$CL_RST

    cd $DIR/$ROMNAME
    rm -rf upload
    mkdir upload
    cd upload
    mkdir -p $ROMNAME/$BRANCH
    cd $ROMNAME/$BRANCH
    mkdir shallow
    cd $DIR/$ROMNAME
    mv $SHALLOW upload/$ROMNAME/$BRANCH/shallow

    echo -e $CL_PFX"Done sorting."$CL_RST

    # Md5s

    echo - $CL_PFX"Taking md5sums"

    cd $DIR/$ROMNAME/upload/$ROMNAME/$BRANCH/shallow
    md5sum * > $ROMNAME-$BRANCH-shallow-$(date +%Y%m%d).parts.md5sum

}

sortfull(){

    echo -e $CL_PFX"Begin to sort."$CL_RST

    cd $DIR/$ROMNAME
    rm -rf upload
    mkdir upload
    cd upload
    mkdir -p $ROMNAME/$BRANCH
    cd $ROMNAME/$BRANCH
    mkdir full
    cd $DIR/$ROMNAME
    mv $FULL upload/$ROMNAME/$BRANCH/full
    echo -e $CL_PFX"Done sorting."$CL_RST

    # Md5s

    echo - $CL_PFX"Taking md5sums"

    cd $DIR/$ROMNAME/upload/$ROMNAME/$BRANCH/full
    md5sum * > $ROMNAME-$BRANCH-full-$(date +%Y%m%d).parts.md5sum

}

upload(){

    echo -e $CL_XOS"Begin to upload."$CL_RST

    cd $DIR/$ROMNAME/upload
    rsync -avPh --relative -e ssh $ROMNAME regalstreak@frs.sourceforge.net:/home/frs/project/skadoosh/

    echo -e $CL_XOS"Done uploading."$CL_RST

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
    rm -rf $DIR/$ROMNAME
else
    echo "Something failed :(";
    rm -rf $DIR/$ROMNAME/shallow $DIR/$ROMNAME/full $DIR/$ROMNAME/shallowparts $DIR/$ROMNAME/fullparts $DIR/$ROMNAME/$SHALLOWMD5 $DIR/$ROMNAME/$FULLMD5 $DIR/$ROMNAME/upload
    exit 1;
fi
