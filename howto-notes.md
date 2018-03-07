# My How-To Guide
This is a collections of tutorials on problems I stumble upon. This guide consolidates solutions from multiple sources for each problem. I will include the source of the solution, but in case the source page cannot be found, I still have this guide to refer to.

### How to mount a remote directory to local
I wanted to be able to edit files on a remote server using the editor on my local machine. First I used `rsync`. but it is too much work to sync it everytime i make a small change. Then I discovered `sshfs` from [this source](https://blogs.harvard.edu/acts/2013/11/08/the-newbie-how-to-set-up-sshfs-on-mac-os-x/) and [this source](https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh). It will mount a remote directory to local machine, so I can use a gui editor, and no need to sync. Here is how (My local machine is iMac):
1. downloaded the latest version of FUSE for OS X at the [FUSE for OS X web site](https://osxfuse.github.io) (its located on the right side panel).
2. installed FUSE for OS X on my laptop by double-clicking the disk image, then double-clicking on the installation package. There is pretty standard Mac OS X stuff; it went without a hitch.
3. downloaded the latest version of SSHFS for OS X at the [FUSE for OS X web site](https://osxfuse.github.io) (same location as FUSE package, right under it).
4. installed SSHFS by double-clicking on the downloaded file.
5. Both FUSE for OS X and SSFHS were now installed.
6. Next, I needed to create a new folder on my laptop which would serve as the mount point. Let’s call that folder `~/mountpoint`.
7. I used this command `sudo sshfs -o allow_other,defer_permissions,IdentityFile=~/.ssh/id_rsa $username@xxx.xxx.xxx.xxx:/ ~/mountpoint` because I have ssh key to the remote server. If you don't have ssh key, then just use this command: `sudo sshfs -o allow_other,defer_permissions $username@xxx.xxx.xxx.xxx:/ ~/mountpoint`
8. To unmount, do this `sudo umount ~/mountpoint`
9. To permanantly mount at this location, do this `sudo vim /etc/fstab`, and then scroll to the bottom of the file and add the following entry: `$username@xxx.xxx.xxx.xxx:/ ~/mountpoint`. **WARNING**: This is a potential security risk, because if your local machine is compromised it allows a direct route to your `mountpoint`. Therefore it is not recommended to setup permanent mounts on production servers.
10. Save the changes to `/etc/fstab` and reboot if necessary.
