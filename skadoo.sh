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

    fi
    
}

romsync(){
    cd $DIR; mkdir -p $ROMNAME/full; cd $ROMNAME/full
    
    repo init -u $LINK -b $BRANCH
    
    THREAD_COUNT_SYNC=69

    # VENDOREDIT
    if [ $(hostname) != 'krieger' ] || [ "$HUTIYA" != "nope" ]; then
    
        # Gather the number of threads
        CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
        # Use 8 times the cpucount
        THREAD_COUNT_SYNC=$(($CPU_COUNT * 8))

    fi
    
    # Sync it up!
    time repo sync -c -f --force-sync --no-clone-bundle --no-tags -j$THREAD_COUNT_SYNC

    # Store the return value
    Rrs=$?
}

separatestuff(){
    cd $DIR/$ROMNAME/

    # Only repo folder
    if [ "$compressrepo" = "true" ]; then
    mkdir $ROMNAME-$BRANCH-repo-$(date +%Y%m%d)
    mv full/.repo $ROMNAME-$BRANCH-repo-$(date +%Y%m%d)
    fi

    # Without repo folder
    if [ "$compressnorepo" = "true" ]; then
    mkdir $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d)
    mv full/* $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d)
    fi
    
    # Store the return value
    Rss=$?
}

compressstuff(){
    cd $DIR/$ROMNAME/
    export XZ_OPT=-9e

    # Only repo folder
    if [ "$compressrepo" = "true" ]; then
    time tar -I pxz -cvf $ROMNAME-$BRANCH-repo-$(date +%Y%m%d).tar.xz $ROMNAME-$BRANCH-repo-$(date +%Y%m%d)/
    fi

    # Without repo folder
    if [ "$compressnorepo" = "true" ]; then
    time tar -I pxz -cvf $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d).tar.xz $ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d)/
    fi
  
    # Store the return value
    Rcs=$?
}

checkstarttime(){

    # Check the starting time
    TIME_START=$(date +%s.%N)

    # Show the starting time
    echo -e "Starting time:$(echo "$TIME_START / 60" | bc) minutes $(echo "$TIME_START" | bc) seconds"
}

uploadstuff(){
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
    
    REPO="$ROMNAME-$BRANCH-repo-$(date +%Y%m%d).tar.xz"
    NOREPO="$ROMNAME-$BRANCH-no-repo-$(date +%Y%m%d).tar.xz"

    cd $DIR/$ROMNAME/

    if [ "$compressrepo" = "true" ] || [ -e $REPO ]; then
    # Upload Repo Only
    wput $REPO ftp://"$USER":"$PASSWD"@"$HOST"/
    else
    echo "$REPO does not exist. Not uploading the repo tarball."
    fi
    
    if [ "$compressnorepo" = "true" ] || [ -e $NOREPO ]; then
    # Upload No Repo
    wput $NOREPO ftp://"$USER":"$PASSWD"@"$HOST"/
    else
    echo "$NOREPO does not exist. Not uploading the no-repo tarball."
    fi

    # Store the return value
    Rus=$?

}
cleanup(){
    cd $DIR/$ROMNAME/
    
    # Check MD5 if something seems wrong
    md5sum $REPO > $DIR/$REPO.txt
    md5sum $NOREPO > $DIR/$NOREPO.txt
    
    # Remove the folder
    cd $DIR
    rm -rf $ROMNAME

    # Store the return value
    Rcu=$?
}

checkfinishtime(){
    # Check the finishing time
    TIME_END=$(date +%s.%N)
    
    # Show the ending time
    echo -e "Ending time:$(echo "$TIME_END / 60" | bc) minutes $(echo "$TIME_END" | bc) seconds"
    
    # Show total time taken to upoload
    echo -e "Total time elapsed:$(echo "($TIME_END - $TIME_START) / 60" | bc) minutes $(echo "$TIME_END - $TIME_START" | bc) seconds"
}

# Do All The Stuff

doallstuff(){
    # Start the counter
    checkstarttime
    
    # Install stuff
    installstuff

    # Sync it up
    romsync
    case $Rrs in
      0) echo "ROM Sync Completed Successfully"
         ;;
      *) echo "ROM Sync Failed"
         exit 1
         ;;
    esac

    # Separate the stuff
    separatestuff
    case $Rss in
      0) echo "Separating Completed Successfully"
         ;;
      *) echo "Separating Failed"
         exit 1
         ;;
    esac

    # Compress it
    compressstuff
    case $Rcs in
      0) echo "Compressing Completed Successfully"
         ;;
      *) echo "Compressing Failed"
         exit 1
         ;;
    esac

    # Upload it
    uploadstuff
    case $Rus in
      0) echo "Uploading Completed Successfully"
         ;;
      *) echo "Uploading Failed"
         exit 1
         ;;
    esac

    # Clean all up
    cleanup

    echo "Thank you for using Skadoosh!"

    # End the counter
    checkfinishtime
}


# So at last do everything
doallstuff
if [ $? -eq 0 ]; then
  echo "Everything done!"
else
  echo "Something failed :(";
  exit 1;
fi
