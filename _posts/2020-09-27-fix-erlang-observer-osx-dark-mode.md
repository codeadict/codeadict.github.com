---
layout: post
type: post
tags:
  - elixir
  - erlang
  - beam
  - osx
  - observer
published: true
title: Fixing the Erlang observer on OSX with dark-mode.
description: The Erlang observer looks a bit bizarre in OSX when using dark-mode. This guide helps fixing it.
twitter:
  username: RedClawTech
  card: summary
social:
  name: Dairon Medina
  links:
    - https://twitter.com/RedClawTech
    - https://www.linkedin.com/in/codeadict
    - https://github.com/codeadict
---
The Erlang [observer](https://erlang.org/doc/man/observer.html) looks a bit bizarre on OSX Mojave or newer when using dark-mode. 
This has been annoying since I've been switching from my favorite dark-mode to the light one to use the observer. 
The following is an image of how it looks:

<figure>
<img src="{{ site.url }}/imgs/observer_bad.png" alt="Observer looking bad in Dark Mode"/>
</figure>

Tonight, I took some time to research how this could be improved and stumbled upon the issue [ERL-921](https://bugs.erlang.org/projects/ERL/issues/ERL-921) in the Erlang/OTP bug tracker.
This lead me to check the WXWidgets changelog at https://github.com/wxWidgets/wxWidgets/blob/master/docs/changes.txt#L376 and dark-mode support was introduced in version 3.1.3: (released 2019-10-28).
The default version that comes in Homebrew is wxMac 3.0.5 for OSX Catalina. Heh, here is my problem! 

To fix this seems like a new version of WX Widgets is needed. Heading to https://github.com/wxWidgets/wxWidgets/releases, **3.1.4** seems to be the latest release as of today's date.
We are going to edit the Homebrew formulae located at `/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/wxmac.rb` with our preferred editor or just run `brew edit wxmac`. 
These are the changes we are going to perform:

1. Change `url` with the path to the version we want to install: "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.4/wxWidgets-3.1.4.tar.bz2".
2. Change `sha256` with the file sha256 checksum, in this version's caseit is "3ca3a19a14b407d0cdda507a7930c2e84ae1c8e74f946e0144d2fa7d881f1a94".
3. Add `"--enable-compat28",` to the args inside `def install` in the formulae. This one took me a bit of reading to make it work, but always the great OTP documentation helped http://erlang.org/doc/installation_guide/INSTALL.html#Advanced-configuration-and-build-of-ErlangOTP_Building_Building-with-wxErlang

Now we can install the new `wxmac` version from the edited formulae and run `brew upgrade wxmac`.

Went to compile Erlang/OTP with my favorite tool named kerl:

``` console
$ kerl build 23.0 23.0
$ kerl install 23.0
```

And after that, running the observer worked nicely with dark-mode:

<figure>
<img src="{{ site.url }}/imgs/observer_good.png" alt="Observer looking great in Dark Mode"/>
</figure>

That's all folks! Hope this helps some of you.
