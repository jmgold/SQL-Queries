#!/usr/bin/env python3

"""
Jeremy Goldstein
Minuteman Library Network
Based on code from Gem Stone-Logan

Create and email monthly report totaling the value of items checked out at wyl, grouped by item type
"""

import psycopg2
import xlsxwriter
import smtplib
import configparser
import os
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import formatdate
from email import encoders
from datetime import date

#Name of Excel File
excelfile =  'WYLMonthlyCircValue{}.xlsx'.format(date.today())

# These are variables for the email that will be sent.
# Make sure to use your own library's email server (emaihost)
emailhost = ''
emailuser = ''
emailpass = ''
emailport = ''
emailsubject = 'Wayland Monthly Circ Value'
emailmessage = '''***This is an automated email***


The Wayland Monthly Circ Value report has been attached.'''
# Enter your own email information
emailfrom= ''
# emailto can send to multiple addresses by separating emails with commas
emailto = ['']

# import configuration file containing our connection string
# app.ini looks like the following
#[db]
#connection_string = dbname='iii' user='PUT_USERNAME_HERE' host='sierra-db.library-name.org' password='PUT_PASSWORD_HERE' port=1032

config = configparser.ConfigParser()
config.read('app.ini')

try:
	# variable connection string should be defined in the imported config file
    conn = psycopg2.connect( config['db']['connection_string'] )
except:
    print("unable to connect to the database")
    clear_connection()
    return
    
query = """\
SELECT *
FROM(
SELECT
it.name AS itype,
CAST(SUM(i.price) AS MONEY) AS value,
COUNT(DISTINCT c.id) AS circ_count,
(CAST(SUM(i.price) AS MONEY) / COUNT(DISTINCT c.id)) as value_per_circ

FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code

WHERE
c.op_code IN ('o','r')
AND
c.transaction_gmt::DATE >= (current_date - INTERVAL '1 month')
AND
c.stat_group_code_num BETWEEN '740' AND '749'

GROUP BY 1

UNION
SELECT
'Total' AS itype,
CAST(SUM(i.price) AS MONEY) AS value,
COUNT(DISTINCT c.id) AS circ_count,
(CAST(SUM(i.price) AS MONEY) / COUNT(DISTINCT c.id)) as value_per_circ

FROM
sierra_view.circ_trans c
JOIN
sierra_view.item_record i
ON
c.item_record_id = i.id
JOIN
sierra_view.itype_property_myuser it
ON
i.itype_code_num = it.code

WHERE
c.op_code IN ('o','r')
AND
c.transaction_gmt::DATE >= (current_date - INTERVAL '1 month')
AND
c.stat_group_code_num BETWEEN '740' AND '749'
)inner_query

ORDER BY CASE
	WHEN itype = 'Total' THEN 2
	ELSE 1
END,itype
"""

#Opening a session and querying the database for weekly new items
cursor = conn.cursor()
cursor.execute(query)
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
eformat2= workbook.add_format({'num_format': 'mm/dd/yy hh:mm:ss'})


# Setting the column widths
worksheet.set_column(0,0,16.86)
worksheet.set_column(1,1,11.86)
worksheet.set_column(2,2,11.14)
worksheet.set_column(3,3,14.14)

#Inserting a header
worksheet.set_header('Wayland Monthly Circ Value')

# Adding column labels
worksheet.write(0,0,'IType', eformatlabel)
worksheet.write(0,1,'Value', eformatlabel)
worksheet.write(0,2,'Circ_Count', eformatlabel)
worksheet.write(0,3,'Value_Per_Circ', eformatlabel)


# Writing the report for staff to the Excel worksheet
for rownum, row in enumerate(rows):
    worksheet.write(rownum+1,0,row[0], eformat)
    worksheet.write(rownum+1,1,row[1], eformat)
    worksheet.write(rownum+1,2,row[2], eformat)
    worksheet.write(rownum+1,3,row[3], eformat)
    
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

os.remove(excelfile)
