---
tags:
- clean code
- PHP
- php standars
type: post
status: publish
title: 'PHP short tags: a bad practice'
description: 'Recommendations about the use of php "short tags".'
published: true
layout: post
---
The use of php "short tags", for example: `<? echo "Hola Mundo!"; ?>` is a bad and widespread practice that many PHP developers still use.

The short tags format is only available using the function `short_tags()` in PHP3 or activating the `short_open_tag` in the **php.ini** configuration file (it comes activated by default). I do not recommend to use it when you develop applications to redistribute or use in external servers because it can cause issues for the user if short tags are not enabled.

In the official PHP manual and the Zend Framework manual, they recommend to not use "short tags" and it's going to be fully deprecated in version 6 of PHP.

Remember that clean code is very important. Always use: `<?php echo "Hola Mundo!"; ?>`.
