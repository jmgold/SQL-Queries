#!/usr/bin/env python3

"""
Jeremy Goldstein
Minuteman Library Network
Based on code from Gem Stone Logan

Gathers monthly checkin and checkout totals for hotspots owned by Newton for E-Rate reporting requirements
emails report as a csv file
"""

import psycopg2
import csv
import configparser
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import formatdate
from email import encoders
from datetime import date

#Name of csv File
csvFile =  'ntn hotspots {}.csv'.format(date.today())

# These are variables for the email that will be sent.
# Make sure to use your own library's email server (emaihost)
emailhost = ''
emailuser = ''
emailpass = ''
emailport = ''
emailsubject = 'ntn hotspots'
emailmessage = '''***This is an automated email***


The Newton Hotspots report has been attached.'''
# Enter your own email information
emailfrom= ''
# emailto can send to multiple addresses by separating emails with commas
emailto = ['']


config = configparser.ConfigParser()
config.read('C:\\SQL Reports\\creds\\app_SIC.ini')

#Connecting to Sierra PostgreSQL database
try:
    # variable connection string should be defined in the imported config file
    conn = psycopg2.connect( config['db']['connection_string'] )
except:
    print("unable to connect to the database")
    clear_connection()
    
query = """\
SELECT
t.transaction_gmt::DATE AS transaction_date,
CASE
	WHEN t.op_code = 'o' THEN 'CHECKOUT'
	ELSE 'CHECKIN'
END AS transaction_type,
i.barcode,
v.field_content AS internal_note

FROM sierra_view.record_metadata rm
JOIN sierra_view.bib_record_item_record_link l
	ON rm.id = l.bib_record_id
	AND rm.record_type_code||rm.record_num = 'b4055592'
JOIN sierra_view.item_record_property i
	ON l.item_record_id = i.item_record_id
JOIN sierra_view.circ_trans t
	ON i.item_record_id = t.item_record_id
	AND t.op_code IN ('o','i')
	AND t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month'
JOIN sierra_view.varfield v
	ON i.item_record_id = v.record_id
	AND v.varfield_type_code = 'x'
	AND v.field_content ~ '^IMEI'
ORDER BY 1
"""

#Opening a session and querying the database for weekly new items
cursor = conn.cursor()
cursor.execute(query)
#For now, just storing the data in a variable. We'll use it later.
rows = cursor.fetchall()
conn.close()

with open(csvFile,'w', encoding='utf-8', newline='') as tempFile:
     myFile = csv.writer(tempFile, delimiter=',')
     myFile.writerows(rows)
tempFile.close()


#Creating the email message
msg = MIMEMultipart()
msg['From'] = emailfrom
if type(emailto) is list:
    msg['To'] = ', '.join(emailto)
else:
    msg['To'] = emailto
msg['Date'] = formatdate(localtime = True)
msg['Subject'] = emailsubject
msg.attach (MIMEText(emailmessage))
part = MIMEBase('application', "octet-stream")
part.set_payload(open(csvFile,"rb").read())
encoders.encode_base64(part)
part.add_header('Content-Disposition','attachment; filename=%s' % csvFile)
msg.attach(part)

#Sending the email message
smtp = smtplib.SMTP(emailhost, emailport)
#for Google connection
smtp.ehlo()
smtp.starttls()
smtp.login(emailuser, emailpass)
smtp.sendmail(emailfrom, emailto, msg.as_string())
smtp.quit()

