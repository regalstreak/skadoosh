#!/bin/bash

# Authors - Neil "regalstreak" Agarwal, Harsh "MSF Jarvis" Shandilya, Tarang "DigiGoon" Kagathara
# 2016
# This file is used to run skadoo.sh easily. 
# Can also be configured with a webhook along with automation as regalstreak and msf-jarvis have done.


### Manifest Configuration ###

# Name of the ROM. No Spaces Please.
# Example: CyanogenMod

name=AOSP


# Manifest link. https:// is mandatory.
# Example: https://github.com/cyanogenmod/android

manifest=https://android.googlesource.com/platform/manifest


# Manifest branch.
# Example: cm-14.0

branch=android-7.0.0_r1


### Compression Configuration ###

# Change the value only if you know what these are.
# Default is true for both.

# compressrepo
# If true, will compress the .repo folder.

export compressrepo=false


# compressnorepo
# If true, will compress the stuff except for the .repo folder
export compressnorepo=true


### Finally, execute the stuff. ###

/bin/bash skadoo.sh $name $manifest $branch
