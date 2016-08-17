name=FlareROM
 #https:// is mandatory in manifest link!
manifest=https://github.com/FlareROM/android.git
branch=1.0-MM

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=true
export compressnorepo=true

./skadoo.sh $name $manifest $branch

