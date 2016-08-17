name=AOSB
 #https:// is mandatory in manifest link!
manifest=https://github.com/AOSB/android.git
branch=kitkat

## comment any of the self explanatory lines if you are only interested in a particular type, default is both.
export compressrepo=true
export compressnorepo=true

./skadoo.sh $name $manifest $branch

