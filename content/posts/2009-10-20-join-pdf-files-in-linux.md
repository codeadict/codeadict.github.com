---
tags:
- GNU/Linux cli
type: post
status: publish
title: Join PDF files in linux.
description: How to join two or more PDF files into one.
published: true
layout: post
---

Hello linux users: in this post I will show how to join two or more PDF files into one. You will have to install the
Ghostscript driver using the following commands in your terminal (** On Debian based distros):

```bash
apt-get install gs
apt-get install pdftk
```

Now we join the PDFs with this command:

```bash
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=unidos.pdf file1.pdf  file2.pdf
```

Here is the explanation of command:

* **gs:**: Call to the Ghostscript program.
* **-dBATCH**: Close the Ghostscript when the process terminates.
* **-dNOPAUSE**: Don't pause the program to ask for user interaction.
* **-q**: </strong>Don't show messages during the process.
* **-sDEVICE=pdfwrite**: Use Ghostscript PDF generator to do the process.
* **-sOutputFile=unidos.pdf**: The name of the result file.

You can also join all PDF files in a directory by providing `*.pdf` as the input files.
