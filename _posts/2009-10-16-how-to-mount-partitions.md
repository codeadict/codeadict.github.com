--- 
tags: 
- GNU/Linux cli
type: post
status: publish
title: Linux:how to mount partitions at startup
meta: 
  _edit_last: "7940715"
published: true
layout: post
---
If you want to add a extra drive/partition and want it to automatically mount on Linux system startup,
 then here is what i did:
 
 * Firstly you need to gather the information of the drive/partition you want to mount. 
 To do it open a Terminal and type the following command:
 
```bash
$ blkid
```

You will see an output like this:

```
/dev/sda1: UUID="FAF804CFF8048C57" LABEL="Sistema" TYPE="ntfs"
/dev/sda3: UUID="87d8a036-4271-4063-81d0-fc8a78889bf6" TYPE="ext4"
/dev/sda5: UUID="E884ED1284ECE3D2" LABEL="Work" TYPE="ntfs"
/dev/sda6: UUID="144A5E7CA87A5099" LABEL="Sof-CEAC" TYPE="ntfs"
/dev/sda7: TYPE="swap" UUID="43a7e90c-7ad9-4790-a169-14ae9b8b1945"
```

If you want to mount the first drive **sda1** named  *Sistema*, you need to follow these steps:

* Create a new directory in **/media** with the drive name, in this case **sda1**:

```bash
$ sudo mkdir /media/sda1
```

* Now you have to write to the **/etc/fstab** file to mount the partition:
 
```bash
$ sudo echo "UUID=81046201045E60A media/sda1 ntfs defaults 0 2" >> /etc/fstab
```

**fstab** is a FileSystem Table configuration file that contains information of all the partitions and
 storage devices in your computer. The file is composed by space or tabs separated fields in this order:
 
 1. **device-spec** – The device name, label, UUID, or other means of specifying the partition entry refers to.
                       mount-point – Directory where the contents of the device may be accessed after mounting.
 2. **fs-type** – The type of file system to be mounted.
 3. **options** – Options describing various other aspects of the file system, such as whether it is automatically mounted at boot,
                  which users may mount or access it, whether it may be written to or only read from, its size;
                  the special option *defaults* refers to a predetermined set of options depending on the file system type.
 4. **dump** – A number indicating whether and how often the file system should be backed up by the dump program;
               a 0 indicates the file system will never be automatically backed up.
 5. **pass** – A number indicating the order in which the fsck program will check the devices for errors at boot time; 
               this is 1 for the root file system and either 2 (meaning check after root) or 0 (do not check) for all other devices.

* Finally, restart your computer and the drive should appear mounted automatically.
