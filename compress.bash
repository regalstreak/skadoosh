name=AOSPA-legacy
 #https:// is mandatory in manifest link!
manifest=https://github.com/AOSPA-legacy/manifest.git -b kitkat
branch=kitkat

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=true
export compressnorepo=false

./skadoo.sh $name $manifest $branch

