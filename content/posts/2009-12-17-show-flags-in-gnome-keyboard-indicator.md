---
tags:
    - Gnome
    - gnome panel
    - tips
type: post
status: publish
title: Show flags in gnome keyboard indicator
description: Simple trick to show flags in the Gnome keyboard indicator.
published: true
layout: post
---

One of the things that i dont like of Gnome Desktop is the keyboard indicator
applet  that not show country flags like KDE desktop. Searching in San Google i
found a solution to fix it, by default gnome support flags but most
distributions dont have this feature enabled, to enable it follow this steps:
<ol>
    <li>
        Press <strong>ALT+F2</strong> and it open the Execute App Dialog. Type
        <strong>gconf-editor </strong>and press<strong> Enter.</strong>
    </li>
    <li>
        Now, go to Desktop&gt;Gnome&gt;Peripherals&gt;Keyboard&gt;Indicator and
        check the box on the right side that says "showFlags". (If you have an
        older gnome desktop and u dont find it, try:
        Apps-&gt;gswitchit-&gt;Applet-&gt;showFlags).
    </li>
    <li>
        Download the flags of languages that you use(You can download SVG files
        from Wikipedia searching the country name). Scale it to
        <strong>64x43</strong> size and move to
        <strong>/usr/share/pixmaps</strong> Directory with name XX.png, where XX
        is the iso country name not the language name, for example i use es.png
        with cuban flag and my language is Spanish(Spain).
    </li>
    <li>
        Now restart your session and you will see the flags in your panel:<a
    </li>
</ol>

<img src="/imgs/gnome-panel1.png" alt="flags" />
