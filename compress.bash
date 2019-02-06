#!### Manifest Configuration ###
# Name of the ROM. No Spaces Please.
# Example: CyanogenMod

name=AOSP

# Manifest link. https:// is mandatory.
# Example: https://github.com/cyanogenmod/android

manifest=https://android.googlesource.com/platform/manifest

# Manifest branch.
# Example: cm-14.0

branch=android-9.0.0_r11

### Finally, execute the stuff. ###
/bin/bash skadoo.sh $name $manifest $branch
