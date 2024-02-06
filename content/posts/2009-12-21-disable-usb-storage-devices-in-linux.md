---
tags:
- GNU/Linux cli
- kernel drivers
- security
- USB
type: post
status: publish
title: Disabling USB storage devices in Linux
description: Trick for disabling USB storage devices in Linux.
published: true
layout: post
---
For security reasons, mainly in school where kids mess around with flash drives containing unappropriated information, we are completely disabling USB storage device access in the computers at the lab. It is important because students can bring a
virus or take out any private information. There is an easy way to do it in Linux blacklisting the USB kernel driver:

 1. Open the `/etc/modprobe.d/blacklist.conf` file.
 2. Type the following: `blacklist usb-storage` at the end of the file and save it.

Now nobody can use a USB drives in that computer. To enable it again, just comment or delete the previous line.
