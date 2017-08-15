--- 
tags: 
- GNU/Linux cli
- kernel drivers
- security
- USB
type: post
status: publish
title: Disable USB storage devices in Linux
meta: 
  _edit_last: "7940715"
published: true
layout: post
---
For security reasons, mainly in schools where kids mess around with flash drives containing unappropriated information, 
we are completely disabling USB storage devices on the computers at lab.  It is important because students can bring a 
virus or also can take out any private information. There is an easy way to do it in Linux blacklisting the USB kernel
 driver:
 
 1. Open the `/etc/modprobe.d/blacklist.conf` file.
 2. Type the following: `blacklist usb-storage` at the end of the file and save it.

Now nobody can use a USB drives in that computer. To enable it again, just comment or delete the previous line.
