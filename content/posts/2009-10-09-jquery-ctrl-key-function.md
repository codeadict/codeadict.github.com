---
tags:
- Jquery
type: post
status: publish
title: 'Jquery Ctrl + Key function'
description: 'Reusable JQuery function to bind a Control + Key combination to an element'
published: true
layout: post
---
Hello friends, in a recent PHP app I'm working on, we had to make a Control+G key combination in a form to submit the data to a database. I create a JQuery function to make it reusable and work with all the **Control +**  combinations. Here I'm  sharing it with the community, hopingit could be useful to anyone out there.:

```javascript
$.ctrl = function(key, callback, args) {
  $(document).keydown(function(e) {
    if(!args) args=[]; // IE barks when args is null
    if(e.keyCode == key.charCodeAt(0) && e.ctrlKey) {
      callback.apply(this, args);
      return false;
    }
  });
};
```

The function can be called with 3 parameters, the first is the key you should press, second is the callback function to execute when you press the combination, and third is an additional array of arguments to pass to the callback funtion. Here is a function call example.

```javascript
$.ctrl('G', function(s) {
  alert(s);
}, ["Yo dude, dont press G"]);
```
