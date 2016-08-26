name=DU
 #https:// is mandatory in manifest link!
manifest=https://github.com/DirtyUnicorns/android_manifest.git
branch=m

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=false
export compressnorepo=true

./skadoo.sh $name $manifest $branch

