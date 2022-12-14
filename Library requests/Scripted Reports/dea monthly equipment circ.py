#!/usr/bin/env python3

"""
Jeremy Goldstein
Minuteman Library Network

Create and email a list of new items of the monthly circ totals for each of Dean's equipment items

Based in large part of code developed by Gem Stone-Logan
"""

import psycopg2
import xlsxwriter
import smtplib
import configparser
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import formatdate
from email import encoders
from datetime import date

#Name of Excel File

excelfile =  'dea monthly equipment circ{}.xlsx'.format(date.today())

# These are variables for the email that will be sent.
# Make sure to use your own library's email server (emaihost)
emailhost = ''
emailuser = ''
emailpass = ''
emailport = ''
emailsubject = 'DEA monthly equipment circulation report'
emailmessage = '''***This is an automated email***


The DEA monthly equipment circulation report has been attached.'''
# Enter your own email information
emailfrom= ''
# emailto can send to multiple addresses by separating emails with commas
emailto = ['']

#Connecting to Sierra PostgreSQL database
config = configparser.ConfigParser()
config.read('api_info.ini')
query = """\
    SELECT
    REPLACE(ip.call_number,'|a','') AS call_number,
    ip.barcode,
    COUNT(t.id) FILTER(WHERE t.op_code = 'o') AS checkout_total,
    COUNT(t.id) FILTER(WHERE t.op_code = 'r') AS renewal_total,
    COUNT(t.id) FILTER(WHERE t.op_code IN ('o','r')) AS circulation_total
    FROM
    sierra_view.circ_trans t
    JOIN
    sierra_view.item_record_property ip
    ON
    t.item_record_id = ip.item_record_id
    WHERE
    t.itype_code_num IN ('245','246','250') AND t.item_location_code ~ '^dea'
    AND t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month'
    GROUP BY 1,2
    ORDER BY 1
    """
conn = psycopg2.connect("dbname='iii' user='" + config['api']['sql_user'] + "' host='" + config['api']['sql_host'] + "' port='1032' password='" + config['api']['sql_pass'] + "' sslmode='require'")

#Opening a session and querying the database for weekly new items
cursor = conn.cursor()
cursor.execute(query)
#For now, just storing the data in a variable. We'll use it later.
rows = cursor.fetchall()
conn.close()

#Creating the Excel file for staff
workbook = xlsxwriter.Workbook(excelfile, {'remove_timezone': True})
worksheet = workbook.add_worksheet()


#Formatting our Excel worksheet
worksheet.set_landscape()
worksheet.hide_gridlines(0)

#Formatting Cells
eformat= workbook.add_format({'text_wrap': True, 'valign': 'top'})
eformatlabel= workbook.add_format({'text_wrap': True, 'valign': 'top', 'bold': True})


# Setting the column widths
worksheet.set_column(0,0,80.57)
worksheet.set_column(1,1,16.14)
worksheet.set_column(2,2,13.57)
worksheet.set_column(3,3,13)
worksheet.set_column(4,4,14.86)

#Inserting a header
worksheet.set_header('Dean Monthly Equipment Circ')

# Adding column labels
worksheet.write(0,0,'Call Number', eformatlabel)
worksheet.write(0,1,'Barcode', eformatlabel)
worksheet.write(0,2,'Checkout Total', eformatlabel)
worksheet.write(0,3,'Renewal Total', eformatlabel)
worksheet.write(0,4,'Circulation Total', eformatlabel)


# Writing the report for staff to the Excel worksheet
for rownum, row in enumerate(rows):
    worksheet.write(rownum+1,0,row[0], eformat)
    worksheet.write(rownum+1,1,row[1], eformat)
    worksheet.write(rownum+1,2,row[2], eformat)
    worksheet.write(rownum+1,3,row[3], eformat)
    worksheet.write(rownum+1,4,row[4], eformat)
    
workbook.close()

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
part.set_payload(open(excelfile,"rb").read())
encoders.encode_base64(part)
part.add_header('Content-Disposition','attachment; filename=%s' % excelfile)
msg.attach(part)

#Sending the email message
smtp = smtplib.SMTP(emailhost, emailport)
#for Google connection
smtp.ehlo()
smtp.starttls()
smtp.login(emailuser, emailpass)
smtp.sendmail(emailfrom, emailto, msg.as_string())
smtp.quit()
