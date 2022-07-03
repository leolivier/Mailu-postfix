#############################
# tests for sending an email
#############################
import smtplib
import imaplib
import time
import sys
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import ntpath
from email.mime.base import MIMEBase
from email import encoders

msg = MIMEMultipart()
msg['From'] = "admin@mailu.io"
msg['To'] = "user@mailu.io"
msg['Subject'] = "File Test"
msg.attach(MIMEText(sys.argv[1], 'plain'))

if len(sys.argv) == 3:
    part = MIMEBase('application', 'octet-stream')
    part.set_payload((open(sys.argv[2], "rb")).read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', "attachment; filename=%s" % ntpath.basename(sys.argv[2]))
    msg.attach(part)

try:
    smtp_server = smtplib.SMTP('localhost')
    smtp_server.set_debuglevel(1)
    smtp_server.connect('localhost', 587)
    smtp_server.ehlo()
    smtp_server.starttls()
    smtp_server.ehlo()
    smtp_server.login("admin@mailu.io", "password")

    smtp_server.sendmail("admin@mailu.io", "user@mailu.io", msg.as_string())
    smtp_server.quit()
except:
    sys.exit(25)
