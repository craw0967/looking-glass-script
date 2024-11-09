# looking-glass-script
Script to handle starting up and opening virtual machines and the Looking Glass Client for AMD GPUs with the reset bug that can't be fixed by other means.

This is not a tutorial or script to help configure and set up a virtual machine with GPU passthrough. However, if you do have a multi GPU computer with a GPU passed through to a virtual machine and set up to use the Looking Glass Client application, this script may be helpful to you.

## Why?
I primarily wrote this because my AMD RX 6700XT is plagued with the AMD reset bug. For some time, many AMD GPUs have had a bug where they aren't able to reset properly when the VM they're passed through to is shut down. This bug prevents users from starting the VM a second time with GPU hardware acceleration, or at all in many cases. Starting with the RX 6000 series GPUs, some AMD cards do not have this issue. Before the 6000 series GPUs, the bug was slightly different and could be fixed by other means.

## Who Is It For?
If you have an older AMD GPU with the reset bug, check out this project here - https://github.com/gnif/vendor-reset. It may resolve your issues so that you don't need this script.

If you're unable to fix the reset issues via other means, this script may be for you.  If you just want an easy way to open and close the VM and Looking Glass Client without manually stopping and starting the VM each time, this script may be for you.

This is a bash script for Linux meant to be used by individuals who have a GPU accelerated virtual machine managed by libvirt and configured to be used and viewed through the Looking Glass application.

The desktop entry file can be used by any Linux desktop environment that supports standard desktop entry files.

## What This Script Does
1) Checks if a given VM is running.
2) If the VM is not running, start it and open Looking Glass Client
3) If the VM is running, but suspended/pause, resume the VM and open Looking Glass Client
4) If the VM is running normally, open Looking Glass Client
5) Monitor Looking Glass Client and when it is exited, suspend the given VM.

## How to Install
1) Clone this repository or download the raw files - looking-glass-startup.desktop and looking-glass-startup.sh
2) Install the script to `/usr/local/bin/looking-glass-startup.sh`. There are more instructions and options noted in the comments in the script. Feel free to review.
3) Set the permissions to 755 and make it executable and then change the owner to root.
```
sudo chmod 755 /usr/local/bin/looking-glass-startup.sh && sudo chown root:root /usr/local/bin/looking-glass-startup.sh/
```
4) Install the desktop entry file to `/usr/share/applications/` or `~/.local/share/applications/`. Once again, there are more instructions and options noted in the comments in the desktop entry file. Please do review and update the file.
5) Update the desktop entry file to suit your needs and your VM configuration. At the minimum you will need to update the virtual machine name on the `Exec=` command line. You will likely want to customize the other details. You can configure and install as many copies of the desktop entry files as you like, so long as you configure each of them for the VM you want to launch and give them unique file names.
6) [Recommended] Optionally, install an icon image to `/usr/share/icons/` or `~/.local/share/icons/` and update the desktop entry file to use the desired icon. Just list the file name of any icon in one of those directories or their subdirectories.
7) If you have questions, read the comments in the script and desktop entry file. I added a lot of comments to make it easy to understand and configure.