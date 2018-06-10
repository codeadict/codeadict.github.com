---
layout: post
type: post
tags:
- commandline
- bash
- tricks
- hacks
- productivity
published: true
title: Hey command, ping me when you are done
---

Certain commands take a lifetime. When I’m running tests, installing dependencies, deploying to a server or creating infrastructure using AWS CloudFormation, I usually switch to another window to not waste that time looking at the screen while the operations happen. But also I like to know when the task is done so I can carry on with the work I was doing.

Bash is really powerful and I really love adding aliases and small tricks to my configuration to improve my productivity, so i created this alias that can be added to the `~/.bashrc` or `~/.bash_profile` files to notify me when a task is done or exited with an error:

```bash
pingme_fn() {
    "$@" && say "Hey $USER, command finished successfully" || say  "Mehhh, command finished with exit status $?"
}
pingme=pingme_fn
```

Then after sourcing the file that contains the alias, e.g: `$ source ~/.bash_profile`, you can use it like `$ pingme long_running_command`:

```console
$ pingme rebar3 compile
```

This trick works on MacOS only, to make it work in Linux, you will need to use another command like **espeak**.

Hope it can be useful to anyone out there. Happy hacking!
