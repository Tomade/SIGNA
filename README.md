# SIGNA
## Sistema Informativo Gare Nuoto Amatoriale

A now ancient implementation of an MS-DOS application designed to help manage competitive swimming events. I volunteered to write this for fun back in 1996, for my old team in Florence, Italy.  Written in Clipper 5.2 (a dBASE IV compiler).

We used the app to collect the data for all participants - names, age, specific races and par time for each race - print out the individual report cards, input the recorded race times during the event, and eventually print out all the final rankings grouped by various keys.  It worked very well and made it possible for us to host a number of successful events for over a year.  I eventually left Florence and my team, and passed it on to a friend for further maintenance.  Regrettably, we lost touch and I don't know what happened afterwards.  This version is the last one I worked on.

The repository includes the single executable built at the time, together with the database and index files required.  It seems to run OK under DOSbox, as follows:

1. Install and run DOSbox.
2. At the DOS prompt, mount the directory where you cloned this repo, with something like "mount c ~/SIGNA" then change dir into it with "C:"
3. Type "SIGNA" to start the app.

This whole thing was still a work in progress when I passed it on, and in particular it lacked a way to configure a specific event from the app itself, so one had to prepare for an event editing directly the file MANIFEST.dbf.  Note that this is a dBASE database file, not a text file, and you'll need some tool capable of working with such ancient beasts unless you're good at editing strings in binary files directly (*hexl-mode* in emacs is fine).  In fact, I had to change a date in MANIFEST.dbf so that the app would not crash at startup, to circumvent a certain dumb check it does right after loading.

I doubt this repo will be of any interest to anyone, although (much to my amazement) I found over 150 other xBase repos on GitHub.  It is now an archeological curiosity at best, but I thought the source code was worth saving, even if just for nostalgic reasons.  In case you're crazy enough to want to build a new binary you will need to first find  working copies of the Clipper compiler and the Blinker linker.  Check the makefile for more information (you'll also need some DOS make, or write your own batch file).

Have fun browsing.