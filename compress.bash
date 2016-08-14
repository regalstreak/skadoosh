name=Omniromm
 #https:// is mandatory in manifest link!
manifest=https://github.com/omnirom/android.git
branch=android-4.4

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=true
export compressnorepo=true

./skadoo.sh $name $manifest $branch

