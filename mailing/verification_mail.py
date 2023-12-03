#!/usr/bin/python3
import os
import smtplib
import ssl
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

if len(sys.argv) != 3:
    raise Exception("Wrong number of arguments")

port = 587  # For starttls
smtp_server = "smtp-mail.outlook.com"
sender_email = os.environ['EMAIL_USER']
password = os.environ['EMAIL_PASSWORD']
receiver_email = sys.argv[1]

msg = MIMEMultipart('alternative')
msg['Subject'] = "Email Bestätigung"
msg['From'] = os.environ['EMAIL_USER']
msg['To'] = sys.argv[1]

# Create the body of the message (a plain-text and an HTML version).
text = f"Folge diesem Link, um deinen Account zu aktivieren:\n{sys.argv[2]}"
html = f"""\
<html>
  <head></head>
  <body>
    <p>Klicke <a href="{sys.argv[2]}">hier</a>, um deinen Account zu aktivieren.</p>
  </body>
</html>
"""

# Record the MIME types of both parts - text/plain and text/html.
part1 = MIMEText(text, 'plain')
part2 = MIMEText(html, 'html')

# Attach parts into message container.
# According to RFC 2046, the last part of a multipart message, in this case
# the HTML message, is best and preferred.
msg.attach(part1)
msg.attach(part2)
# Send the message via local SMTP server.

context = ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
    server.starttls(context=context)
    server.login(sender_email, password)
    server.sendmail(sender_email, receiver_email, msg.as_string())

