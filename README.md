# Skadoosh
## A project for your internet speed concerns.

All information available on the [XDA thread](http://forum.xda-developers.com/android/software/sources-android-sources-highly-t3231109) of the source index.

Click [here](https://sourceforge.net/projects/skadoosh/files/) to go to the SourceForge project files for downloading latest sources.

Click [here](https://www.androidfilehost.com/?w=files&flid=87142) (deprecated, go to SourceForge) to go to the AndroidFileHost folder for downloading old sources.

**Warning:** Do not upload your own password along with the repo if you modify the project!

**Usage:**

For android developers:
Check XDA Thread FAQ

For uploading sources:
```shell
# First change the rsync host and file directories in skadoo.sh
./compress.bash
```

### Automation

Originally, we have had a "Ask on the thread, we'll try" approach to how things work. This is changing now.
While this worked good enough for those asking for the sources, the people who did the actual work were overburdened. Frankly, the process was pretty sketchy.
We personally faced the burden part when there were about 6 or 7 ROMs to do! 
We actually forgot about one guy who made the request earliest, which kinda sucked.
Going forward, this is being changed now.

We now automate stuff with [Caddy](https://caddyserver.com) webserver.

Automation also has been made opensource now.
You can view the source of the automation stuff [here](https://github.com/regalstreak/skadhook)
