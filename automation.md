# How to automate usage of node-hikechat

In here is documented how I solved the issue of over and over executing the same monkey task to export my hike chats into a chat log available on a webserver for better searchability and overview of the conversation. As I only needed one conversation to be exported the solution does not contain folder management and parsing of the conversation list.

## Client-Side automation

As the `README.md` already states a rooted android device is required for this to work. If your device is not rooted you can stop reading at this point and come back when you've successfully rooted your device.

**Required apps:**

1. [BusyBox](https://play.google.com/store/apps/details?id=stericson.busybox) (in my case I used [BusyBox Pro](https://play.google.com/store/apps/details?id=stericson.busybox.donate) as it supports auto updating and other stuff
1. [Cron4Phone](https://play.google.com/store/apps/details?id=com.aes.cron4phonefree) to automate execution of the extraction script
1. [FolderSync](https://play.google.com/store/apps/details?id=dk.tacit.android.foldersync.full) to synchronize the backup of the hike database with the webserver using your favorite cloud provider (I'm using Dropbox for this)

**Steps:**

1. Ensure BusyBox has installed / updated the commands on your system to use tar
1. Create a folder called `hikesync` and a script called `hikebackup.sh` with this content on your `/sdcard/`
1. Go to Cron4Phone and add a task in your desired interval (for me `*/30 * * * *` is working perfect) and add the command `su -c /system/bin/sh /sdcard/hikebackup.sh`. This will create a `tar` backup of your hike databases into `/sdcard/hikesync`.
1. Set up FolderSync to sync `/sdcard/hikesync` to your desired cloud service

## Server-Side automation

1. Ensure the files uploaded to your desired cloud service are available on your server
1. Clone this repository into your homedir (or somewhere else)
1. Create a script to do these jobs (an example can be seen below named `hike2chat.sh`):
    1. Untar the uploaded archive
    1. Sync the `databases` directory into the checkout
    1. Run the `hike.coffee` script with your preferred parameters to create the chat log
1. If you set up everything before to work without user interaction you probably want to add your script to `crontab`

## Files mentioned above

### hikebackup.sh
```sh
#!/system/bin/sh
/system/bin/tar cf /sdcard/hikesync/hike.tar /data/data/com.bsb.hike/databases
```

### hike2chat.sh
```bash
#!/bin/bash

tar -x -C /tmp/ -f /home/luzifer/Dropbox/hikesync/hike.tar
rsync -ar /tmp/data/data/com.bsb.hike/databases/  /home/luzifer/hike/databases/
cd /home/luzifer/hike
./hike.coffee -n "Knut" 1 > /home/luzifer/httpd/conversation_1.txt
```
