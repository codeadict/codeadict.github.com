---
layout: post
type: post
tags:
- Python
published: true
title: Make Short URLs with Python and goo.gl
---

Hi, on an application im working on that generates very long urls and need to show it easy for users i thinked on some online services that generates short URLs like bit.li or goo.gl and come with that script to make the urls shorten from Python programing language, i decided to use goo.gl service as im a huge Google fan. Here is the code i wrote and hopes can be usefull for someone


{% highlight python %}
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
      raise Exception('Server has returned Invalid Response')
    return json['short_url']
  raise Exception('Unknown error has Ocurred.')
{% endhighlight %}