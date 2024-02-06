---
layout: post
type: post
tags:
- golang
- ubuntu
- linux
published: true
title: Setting up a Golang development environment on Ubuntu Linux
description: A simple guide to set up a development environment for Golang on Ubuntu Linux.
---
![Haking Golang](/imgs/golang_coffee.webp)

I am actually in the process of learning the Go programming language. I'm not only doing this because i believe that it's an important skill to add to my Resume, but also because it's a compiled language, similar to C/C++ stack but with nicer syntax and also because is has a pretty powerful web server built-in and creating web services its very straightforward process. Also being a compiled language, distributing and deploying apps is very simple. And finally because the [dev team](https://en.wikipedia.org/wiki/Go_%28programming_language%29) behind go have a great track creating powerful languages.

This guide intends to help the novice starter in Golang, like me, to set up a development environment fast and without the headaches of compiling the language itself. This tutorial assumes you have a basic understanding of Linux commandline and at least have a notion of what is Golang and how it works. If you don't have it don't worry, reading [this great book](http://www.gopl.io/) can help you a lot. So here we go:


First we install the header dependencies on our Operating System:

```bash
sudo apt-get update
sudo apt-get install curl git mercurial make binutils bison gcc
```

Now lets install GVM, a Go Version Manager very similar to Ruby's RVM or Node.js NVM, that will be your best friend working with different projects and different versions of Go:

```bash
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source $HOME/.gvm/scripts/gvm
```

Now we can install the version of go needed for our first app, the last version of go till date is [1.6](https://blog.golang.org/go1.6) but since version 1.5 Go relies on a previous version to compile itself so we can install version 1.4 and later install the last one:

```bash
gvm install go1.4
gvm install go1.6
gvm use go1.6 --default
```

Once this is done Go will be in the path and ready to use. $GOROOT and $GOPATH are set automatically. At this point we may need to reload bash again with `source ~/.bashrc`. Now we can test our installed go version by running:

```bash
go version
```

And voilà we are ready to start hacking on go, so simple and you can play with different versions by using `gvm`.
