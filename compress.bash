name=FlareROM
 #https:// is mandatory in manifest link!
manifest=https://android.googlesource.com/platform/manifest
branch=android-6.0.1_r63

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=true
export compressnorepo=true

./skadoo.sh $name $manifest $branch

