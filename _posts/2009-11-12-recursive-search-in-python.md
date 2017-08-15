--- 
tags: 
- Python
type: post
status: publish
title: Recursive file search using Python
meta: 
  _edit_last: "7940715"
published: true
layout: post
---
I wrote this script this script to make recursive searches in a specified folder in Linux, 
including all its subdirectories, just like the [find](https://linux.die.net/man/1/find) command does.
Here is it and hope it can be useful to someone or at least have fun with it :):

```python
#! /usr/bin/env python
import os


def search(path, file_name):
    try:
        files = os.listdir(path)
        for f in files:
            if os.path.isdir(path + f):
                search(path + f + '/', file_name)
            else:
                try:
                    if f.index(file_name):
                        print
                        'Found:' + path + f
                except ValueError:
                    continue
    except OSError as e:
        print
        'An error occured: ' + unicode(e)


if __name__ == '__main__':
    path = raw_input('Search Folder: ')
    file = raw_input('File to Search: ')
    search(path, file)
 ```

