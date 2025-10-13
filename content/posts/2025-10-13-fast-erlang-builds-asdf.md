---
layout: post
type: post
tags:
  - asdf
  - erlang
  - elixir
  - beam
  - tips
  - productivity
published: true
title: Skip the wait - Fast Erlang builds with asdf prebuilt packages
description: How I stopped wasting time compiling Erlang from source and started using prebuilt packages with asdf
social:
  name: Dairon Medina
  links:
    - https://www.linkedin.com/in/codeadict
    - https://github.com/codeadict
---

I've been using `asdf-vm` for years to juggle different Erlang and Elixir versions across projects. It's been a lifesaver, honestly. Just drop a `.tool-versions` file in your project, and boom - the right versions are there when you need them.

But here's the thing that always bugged me: every time I needed to install a new Erlang version, I'd run the command and then... wait. And wait some more. The default Erlang plugin uses `kerl` under the hood, which downloads source code and compiles everything from scratch.

Sure, compiling from source gives you control over build settings, but it also means:
- Waiting around for 20+ minutes (sometimes longer)
- Dealing with random build failures (especially on macOS after updates)

I spent way too much time reading the plugin's README, which is basically a troubleshooting guide for all the ways Erlang compilation can go wrong.

## There's a better way

A while back, I discovered that [Michał Łępicki](https://github.com/michallepicki) created an alternative asdf Erlang plugin that just downloads precompiled packages. No more waiting for builds!

These packages come from the [erlef/otp_builds](https://github.com/erlef/otp_builds) project, so they're legit and maintained.

Here's how to switch:

First, remove the default Erlang plugin if you're already using it:

```console
asdf plugin remove erlang
```

Then add the prebuilt version instead:

```console
asdf plugin add erlang https://github.com/michallepicki/asdf-erlang-prebuilt-macos.git
```

That's it! Now when you run:

```console
asdf install erlang 26.2.1
```

It just downloads the binary and you're ready to go. No compilation, no waiting, no headaches.

This simple change has saved me hours of waiting time. Thank you so much Michał!

Happy hacking!
