#!/bin/bash

# Authors - Neil "regalstreak" Agarwal, Harsh "MSF Jarvis" Shandilya, Tarang "DigiGoon" Kagathara
# 2016
# This file is used to run skadoo.sh easily.
# Can also be configured with a webhook along with automation as regalstreak and msf-jarvis have done.


### Manifest Configuration ###

# Name of the ROM. No Spaces Please.
# Example: CyanogenMod

name=AOSPA


# Manifest link. https:// is mandatory.
# Example: https://github.com/cyanogenmod/android

manifest=https://github.com/AOSPA/manifest

# Manifest branch.
# Example: cm-14.0

branch=nougat-caf

### Finally, execute the stuff. ###

/bin/bash skadoo.sh $name $manifest $branch