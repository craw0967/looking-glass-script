#!/bin/bash

# Install this script to /usr/local/bin/looking-glass-startup.sh, set the permissions to 755 and make it executable, and then change the owner to root.
# sudo chmod 755 /usr/local/bin/looking-glass-startup.sh && sudo chown root:root /usr/local/bin/looking-glass-startup.sh/

# You can install this script anywhere you want if you don't want to put it in /usr/local/bin/, however you will have to change the path to the script in the desktop file.
# You also don't necessarily need to change ownership to root if you install it elsewhere. Just make sure the script is executable by the user you want to run it as.

# Set a default VM name. You can change this to whatever default name you wish.
# This is not strictly necessary if you specify the VM name with the -n option when you run the script.
vm_name=""

# Parse command-line options
# If no options are specified, use the default name of the VM
# If option -n: Set the name of the VM to the provided value
# If any other option is specified, print an error message and exit.
while getopts ":n:" opt; do
  case $opt in
    n) vm_name="$OPTARG";;
    \?) echo "Invalid option: -$OPTARG"; exit 1;;
  esac
done

# Check the current state of the VM
vm_state=$(virsh --connect qemu:///system list --all | grep " $vm_name " | awk '{ print $3}')

# If the VM doesn't exist or is shut down, start it
if [ "x$vm_state" == "x" ] || ([ "x$vm_state" != "xrunning" ] && [ "x$vm_state" != "xpaused" ]); then
    echo "VM does not exist or is shut down!"
    virsh --connect qemu:///system start "$vm_name"
    # Start the looking-glass-client
    looking-glass-client -S -m KEY_RIGHTCTRL &
    LG_PID=$!
# If the VM is paused, resume it
elif [ "x$vm_state" == "xpaused" ]; then
    echo "VM is suspended. Resuming..."
    virsh --connect qemu:///system resume "$vm_name"
    # Start the looking-glass-client
    looking-glass-client -S -m KEY_RIGHTCTRL &
    LG_PID=$!
# If the VM is already running, just start the looking-glass-client
else
    echo "VM is running!"
    # Start the looking-glass-client
    looking-glass-client -S -m KEY_RIGHTCTRL &
    LG_PID=$!
fi

# Wait for the looking-glass-client to exit
while kill -0 $LG_PID > /dev/null 2>&1; do
    sleep 1
done

# Check the current state of the VM again
vm_state=$(virsh --connect qemu:///system list --all | grep " $vm_name " | awk '{ print $3}')

# If the VM is still running, suspend it
if [ "x$vm_state" == "xrunning" ]; then
    echo "VM is running. Suspending..."
    virsh --connect qemu:///system suspend "$vm_name"
fi
