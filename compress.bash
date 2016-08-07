name=AOSP-G3
 #https:// is mandatory in manifest link!
manifest=https://github.com/AOSP-G3/platform_manifest.git
branch=mm6.0

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=true
export compressnorepo=true

./skadoo.sh $name $manifest $branch

