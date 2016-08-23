name=AOSP
 #https:// is mandatory in manifest link!
manifest=https://android.googlesource.com/platform/manifest
branch=android-7.0.0_r1

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=false
export compressnorepo=true

./skadoo.sh $name $manifest $branch

