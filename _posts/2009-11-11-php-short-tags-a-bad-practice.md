--- 
tags: 
- clean code
- PHP
- php standars
type: post
status: publish
title: "PHP \"short tags\": a bad practice"
meta: 
  _edit_last: "7940715"
published: true
layout: post
---
The use of php "short tags", for example:`<? echo "Hola Mundo!"; ?>` is a bad and common practice 
that many PHP developers still use.
 
The short tags format is only available using the function `short_tags()` in PHP3 or activating the 
`short_open_tag` in the **php.ini** configuration file(it comes activated by default). I do not recommend 
to use it when you develop applications to redistribute or use in external servers because it can cause conflicts 
for the user if short tags are not enabled. 

In the official PHP manual and the Zend Framework manual, they recommend to not use "short tags" and it's going to be 
fully deprecated in version 6 of PHP. Remember that code clearness is very important to a professional developer. 
Always use: <?php echo "Hola Mundo!"; ?>.
