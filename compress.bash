name=LuneOS
 #https:// is mandatory in manifest link!
manifest=https://android.googlesource.com/platform/manifest
branch=android-4.4.4_r2.0.1

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=true
export compressnorepo=true

./skadoo.sh $name $manifest $branch

