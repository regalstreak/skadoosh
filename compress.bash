name=LuneOS
 #https:// is mandatory in manifest link!
manifest=git://github.com/webOS-ports/android.git
branch=wop-10.1

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=true
export compressnorepo=true

./skadoo.sh $name $manifest $branch

