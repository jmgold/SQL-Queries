#!/usr/bin/env python3

"""
Jeremy Goldstein
Minuteman Library Network
based on code from Gem Stone-Logan

Create and email a weekly excel log of circ transactions for library of things collection at FPL
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

excelfile =  'fpl LoT circ{}.xlsx'.format(date.today())

# These are variables for the email that will be sent.
# Make sure to use your own library's email server (emaihost)
emailhost = ''
emailuser = ''
emailpass = ''
emailport = ''
emailsubject = 'FPL weekly LoT Circulation'
emailmessage = '''***This is an automated email***


The fpl LoT circ report has been attached.'''
# Enter your own email information
emailfrom= ''
# emailto can send to multiple addresses by separating emails with commas
emailto = ['']

# import configuration file containing our connection string
# app.ini looks like the following
#[db]
#connection_string = dbname='iii' user='PUT_USERNAME_HERE' host='sierra-db.library-name.org' password='PUT_PASSWORD_HERE' port=1032

config = configparser.ConfigParser()
config.read('Y:\\SQL Reports\\creds\\app.ini')

query = """\
SELECT
c.transaction_gmt,
c.application_name,
CASE
    WHEN c.op_code = 'o' THEN 'checkout'
    WHEN c.op_code = 'i' THEN 'checkin'
    WHEN c.op_code = 'n' THEN 'hold'
    WHEN c.op_code = 'h' THEN 'hold with recall'
    WHEN c.op_code = 'nb' THEN 'bib hold'
    WHEN c.op_code = 'hb' THEN 'hold recall bib'
    WHEN c.op_code = 'ni' THEN 'item hold'
    WHEN c.op_code = 'hi' THEN 'hold recall item'
    WHEN c.op_code = 'nv' THEN 'volume hold'
    WHEN c.op_code = 'hv' THEN 'hold recall volume'
    WHEN c.op_code = 'f' THEN 'filled hold'
    WHEN c.op_code = 'r' THEN 'renewal'
    WHEN c.op_code = 'b' THEN 'booking'
    WHEN c.op_code = 'u' THEN 'use count'
    ELSE 'unknown'
END AS transaction_type,
b.best_title,
b.material_code,
id2reckey(c.bib_record_id)||'a' as bib_num,
id2reckey(c.item_record_id)||'a' as item_num,
i.barcode,
i.call_number_norm,
c.stat_group_code_num,
c.due_date_gmt,
c.count_type_code_num,
c.itype_code_num,
c.icode1,
c.item_location_code,
c.loanrule_code_num,
--encrypt patron id
md5(CAST(c.patron_record_id AS varchar))

FROM
sierra_view.circ_trans c
JOIN
sierra_view.bib_record_property b
ON
c.bib_record_id = b.bib_record_id
JOIN
sierra_view.item_record_property i
ON
c.item_record_id = i.item_record_id
"""

try:
	# variable connection string should be defined in the imported config file
    conn = psycopg2.connect( config['db']['connection_string'] )
except:
    print("unable to connect to the database")
    clear_connection()
    return
        
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
eformat2= workbook.add_format({'num_format': 'mm/dd/yy hh:mm:ss'})
eformat3= workbook.add_format({'num_format': 'mm/dd/yy'})


# Setting the column widths
worksheet.set_column(0,0,16.29)
worksheet.set_column(1,1,10.29)
worksheet.set_column(2,2,15.29)
worksheet.set_column(3,3,68.43)
worksheet.set_column(4,4,8.86)
worksheet.set_column(5,5,10.14)
worksheet.set_column(6,6,10.14)
worksheet.set_column(7,7,15.43)
worksheet.set_column(8,8,48.14)
worksheet.set_column(9,9,15.29)
worksheet.set_column(10,10,11.14)
worksheet.set_column(11,11,20.86)
worksheet.set_column(12,12,10.57)
worksheet.set_column(13,13,9.43)
worksheet.set_column(14,14,13.00)
worksheet.set_column(15,15,13.57)
worksheet.set_column(16,16,34.14)

#Inserting a header
worksheet.set_header('Framingham Weekly Library Of Things Circulation')

# Adding column labels
worksheet.write(0,0,'Transaction_time', eformatlabel)
worksheet.write(0,1,'Application', eformatlabel)
worksheet.write(0,2,'Transaction_type', eformatlabel)
worksheet.write(0,3,'Best_title', eformatlabel)
worksheet.write(0,4,'Mat_type', eformatlabel)
worksheet.write(0,5,'Bib_num', eformatlabel)
worksheet.write(0,6,'Item_num', eformatlabel)
worksheet.write(0,7,'Barcode', eformatlabel)
worksheet.write(0,8,'Call_number_norm', eformatlabel)
worksheet.write(0,9,'Stat_group_num', eformatlabel)
worksheet.write(0,10,'Due_date', eformatlabel)
worksheet.write(0,11,'Count_type_code_num', eformatlabel)
worksheet.write(0,12,'Itype_code', eformatlabel)
worksheet.write(0,13,'Scat_code', eformatlabel)
worksheet.write(0,14,'Location_code', eformatlabel)
worksheet.write(0,15,'Loanrule_num', eformatlabel)
worksheet.write(0,16,'Patron_encrypted', eformatlabel)


# Writing the report for staff to the Excel worksheet
for rownum, row in enumerate(rows):
    worksheet.write(rownum+1,0,row[0], eformat2)
    worksheet.write(rownum+1,1,row[1], eformat)
    worksheet.write(rownum+1,2,row[2], eformat)
    worksheet.write(rownum+1,3,row[3], eformat)
    worksheet.write(rownum+1,4,row[4], eformat)
    worksheet.write(rownum+1,5,row[5], eformat)
    worksheet.write(rownum+1,6,row[6], eformat)
    worksheet.write(rownum+1,7,row[7], eformat)
    worksheet.write(rownum+1,8,row[8], eformat)
    worksheet.write(rownum+1,9,row[9], eformat)
    worksheet.write(rownum+1,10,row[10], eformat3)
    worksheet.write(rownum+1,11,row[11], eformat)
    worksheet.write(rownum+1,12,row[12], eformat)
    worksheet.write(rownum+1,13,row[14], eformat)
    worksheet.write(rownum+1,14,row[14], eformat)
    worksheet.write(rownum+1,15,row[15], eformat)
    worksheet.write(rownum+1,16,row[16], eformat)
    
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
