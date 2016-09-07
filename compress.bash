#!/bin/bash

# Authors - Neil "regalstreak" Agarwal, Harsh "MSF Jarvis" Shandilya, Tarang "DigiGoon" Kagathara
# 2016
# This file is used to run skadoo.sh easily.
# Can also be configured with a webhook along with automation as regalstreak and msf-jarvis have done.


### Manifest Configuration ###

# Name of the ROM. No Spaces Please.
# Example: CyanogenMod

name=MiUi


# Manifest link. https:// is mandatory.
# Example: https://github.com/cyanogenmod/android

manifest=https://github.com/MiCode/patchrom


# Manifest branch.
# Example: cm-14.0

branch=kitkat

### Compression Configuration ###

# Change the value only if you know what these are.
# Default is true for both.

# compressrepo
# If true, will compress the .repo folder.

export compressrepo=false


# compressnorepo
# If true, will compress the stuff except for the .repo folder
export compressnorepo=true


### Check branchname for slashes. ###

branchtest=$(echo $branch | tr / -)
if [ "$branch" = "$branchtest" ]; then
  echo ""
else
  unset $branch 2>/dev/null
  branch=$branchtest
fi

### Finally, execute the stuff. ###

/bin/bash skadoo.sh $name $manifest $branch
