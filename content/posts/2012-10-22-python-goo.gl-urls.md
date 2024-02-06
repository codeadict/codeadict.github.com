---
layout: post
type: post
tags:
- Python
published: true
title: Make Short URLs with Python and goo.gl
description: A simple Python function to shorten URLs using goo.gl
---

I recently worked on an app that generates very long URLs and needs to present them to the users. These long URL's messed up the design in the screen and were hard to read.

I thought about some online services that generate short URLs like bit.ly or goo.gl and came up with this small script to shorten URLs from Python. Here is the code I wrote, and I hope it can be useful for someone:


```python
import re
from urllib import quote
from urllib2 import urlopen, Request, HTTPError
import simplejson as json

def make_short_url(url):
  """
  Shorten a URL with goo.gl
  """
  if not re.match('http://',url):
    raise Exception('Invalid URL')
  try:
    urlopen(Request('http://goo.gl/api/url','url=%s'%quote(url),
    				{'UserAgent':'Python'}))
  except HTTPError, e:
    json = json.loads(e.read())
    if 'short_url' not in json:
      raise Exception('Server has returned invalid Response')
    return json['short_url']
  except:
    raise Exception('An unknown error has ocurred.')
```
