#!/usr/bin/env python3

"""
Jeremy Goldstein
Minuteman Library Network
Based on code from Gem Stone-Logan

Create a weekly report of fines paid in Cash at MLD for reconciling receipts
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

excelfile =  'mld weekly fines paid{}.xlsx'.format(date.today())

# These are variables for the email that will be sent.
# Make sure to use your own library's email server (emaihost)
emailhost = ''
emailuser = ''
emailpass = ''
emailport = ''
emailsubject = 'MLD weekly fines paid'
emailmessage = '''***This is an automated email***


The MLD weekly fines paid report has been attached.'''
# Enter your own email information
emailfrom= ''
# emailto can send to multiple addresses by separating emails with commas
emailto = ['']

#Connecting to Sierra PostgreSQL database
config = configparser.ConfigParser()
config.read('api_info.ini')
query = """\
    SELECT 
    f.paid_date_gmt::DATE AS DATE,
    COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code IN ('2','6'))::MONEY,0.00::MONEY) AS overdue,
    COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code = '5')::MONEY,0.00::MONEY) AS lost_book,
    COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code = '3')::MONEY,0.00::MONEY) AS replacement,
    COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code = '1')::MONEY,0.00::MONEY) AS manual_charge,
    COALESCE(SUM(f.billing_fee_amt) FILTER(WHERE f.charge_type_code = '4')::MONEY,0.00::MONEY) AS adjustment,
    COALESCE(SUM(f.paid_now_amt) FILTER(WHERE f.charge_type_code BETWEEN '1' AND '6')::MONEY,0.00::MONEY) AS total

    FROM
    sierra_view.fines_paid f

    WHERE
    f.tty_num::VARCHAR ~ '^50'
    AND f.payment_status_code NOT IN ('0','3')
    AND f.paid_now_amt > 0
    AND f.paid_date_gmt::DATE >= CURRENT_DATE - INTERVAL '1 week'

    GROUP BY 1
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
eformat2= workbook.add_format({'num_format': 'mm/dd/yy'})


# Setting the column widths
worksheet.set_column(0,0,12.86)
worksheet.set_column(1,1,8.43)
worksheet.set_column(2,2,9.3)
worksheet.set_column(3,3,12.71)
worksheet.set_column(4,4,14.86)
worksheet.set_column(5,5,10.86)
worksheet.set_column(6,6,8.43)

#Inserting a header
worksheet.set_header('Medfield Weekly Fines Paid')

# Adding column labels
worksheet.write(0,0,'Date', eformatlabel)
worksheet.write(0,1,'Overdue', eformatlabel)
worksheet.write(0,2,'Lost Book', eformatlabel)
worksheet.write(0,3,'Replacement', eformatlabel)
worksheet.write(0,4,'Manual Charge', eformatlabel)
worksheet.write(0,5,'Adjustment', eformatlabel)
worksheet.write(0,6,'Total', eformatlabel)


# Writing the report for staff to the Excel worksheet
for rownum, row in enumerate(rows):
    worksheet.write(rownum+1,0,row[0], eformat2)
    worksheet.write(rownum+1,1,row[1], eformat)
    worksheet.write(rownum+1,2,row[2], eformat)
    worksheet.write(rownum+1,3,row[3], eformat)
    worksheet.write(rownum+1,4,row[4], eformat)
    worksheet.write(rownum+1,5,row[5], eformat)
    worksheet.write(rownum+1,6,row[6], eformat)
    
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
