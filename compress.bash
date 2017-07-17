#!/bin/bash

# Authors - Neil "regalstreak" Agarwal, Harsh "MSF Jarvis" Shandilya, Tarang "DigiGoon" Kagathara
# 2016, 2017
# This file is used to run skadoo.sh easily.
# Can also be configured with a webhook along with automation as regalstreak and msf-jarvis have done.

### Manifest Configuration ###
# Name of the . No Spaces Please.
# Example: CyanogenMod
name=octos

# Manifest link. https:// is mandatory.
# Example: https://github.com/cyanogenmod/android
manifest=https://github.com/Team-OctOS/platform_manifest -b oct-14.1


# Manifest branch.
# Example: cm-13.0
branch=octos-mm

### Finally, execute the stuff. ###
/bin/bash skadoo.sh $name $manifest $branch
