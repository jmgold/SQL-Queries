#!/usr/bin/env python3

"""Create and email a list of new items

Author: Gem Stone-Logan
Contact Info: gem.stone-logan@mountainview.gov or gemstonelogan@gmail.com
"""

import psycopg2
import xlsxwriter
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import formatdate
from email import encoders

#Name of Excel File
excelfile =  'OrdersWithoutGrids.xlsx'

# These are variables for the email that will be sent.
# Make sure to use your own library's email server (emaihost)
emailhost = 'smtp.gmail.com'
emailuser = ''
emailpass = ''
emailport = '587'
emailsubject = 'Orders without grids'
emailmessage = '''***This is an automated email***


The weekly new report has been attached. Please take a look and let the Technology Librarian know if there are any questions about it.'''
# Enter your own email information
emailfrom= ''
# emailto can send to multiple addresses by separating emails with commas
emailto = ['','']

#Connecting to Sierra PostgreSQL database
conn = psycopg2.connect("dbname='' user='' host='' port='' password='' sslmode='require'")

#Opening a session and querying the database for weekly new items
cursor = conn.cursor()
cursor.execute("SELECT id2reckey(order_view.record_id)||'a', order_record_cmf.location_code, order_view.accounting_unit_code_num FROM sierra_view.order_view JOIN sierra_view.order_record_cmf ON order_view.record_id=order_record_cmf.order_record_id WHERE order_record_cmf.location_code = 'none';")
#For now, just storing the data in a variable. We'll use it later.
rows = cursor.fetchall()
conn.close()

#Creating the Excel file for staff
workbook = xlsxwriter.Workbook(excelfile)
worksheet = workbook.add_worksheet()


#Formatting our Excel worksheet
worksheet.set_landscape()
worksheet.hide_gridlines(0)

#Formatting Cells
eformat= workbook.add_format({'text_wrap': True, 'valign': 'top'})
eformatlabel= workbook.add_format({'text_wrap': True, 'valign': 'top', 'bold': True})

# Setting the column widths
worksheet.set_column(0,0,14.43)
worksheet.set_column(1,1,7.71)
worksheet.set_column(2,2,9.57)

#Inserting a header
worksheet.set_header('orders without grids')

# Adding column labels
worksheet.write(0,0,'Record_number', eformatlabel)
worksheet.write(0,1,'Location', eformatlabel)
worksheet.write(0,2,'accounting unit', eformatlabel)

# Writing the report for staff to the Excel worksheet
for rownum, row in enumerate(rows):
    worksheet.write(rownum+1,0,row[0], eformat)
    worksheet.write(rownum+1,1,row[1], eformat)
    worksheet.write(rownum+1,2,row[2], eformat)
    
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
