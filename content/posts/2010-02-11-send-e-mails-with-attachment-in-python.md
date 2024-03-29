---
tags:
- email
- Programming
- Python
- smtplib
type: post
status: publish
title: Send e-mails with attachments in Python
description: 'A simple example of how to send e-mails with attachments using Python'
published: true
layout: post
---

Now I'm working on an application that has to send emails with attachments using [Python](http://python.org).
I came up with this code that I'm sharing here and hope it can be helpful/reusable to somebody:


```python
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from smtplib import SMTP

msg = MIMEMultipart()
msg['Subject'] = 'Email From Python'
msg['From'] = 'me@domain.cu'
msg['Reply-to'] = 'somebody@domain.com'
msg['To'] = 'rms@gnu.org'

# That is what u see if dont have an email reader:
msg.preamble = 'Multipart massage.\n'

# This is the textual part:
part = MIMEText('Hello im sending an email from a python program')
msg.attach(part)

# This is the binary part(The Attachment):
part = MIMEApplication(open('file.pdf', 'rb').read())
part.add_header('Content-Disposition', 'attachment', filename='file.pdf')
msg.attach(part)

# Create an instance in SMTP server
smtp = SMTP('smtp.domain.cu')
# Start the server:
smtp.ehlo()
smtp.login('me@domain.cu', 'mypassword')

# Send the email
smtp.sendmail(msg['From'], msg['To'], msg.as_string())
```
