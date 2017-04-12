#!/usr/bin/env python3

"""Create and email a list of new items

Author: Gem Stone-Logan
Contact Info: gem.stone-logan@mountainview.gov or gemstonelogan@gmail.com
"""

import psycopg2
import xlsxwriter

#Connecting to Sierra PostgreSQL database
conn = psycopg2.connect("dbname='iii' user='mlnjeremy' host='sierra-db.minlib.net' port='1032' password='mlnjeremy' sslmode='require'")

#Opening a session and querying the database for weekly new items
cursor = conn.cursor()
cursor.execute("SELECT id2reckey(order_view.record_id)||'a', order_record_cmf.location_code, order_view.accounting_unit_code_num FROM sierra_view.order_view JOIN sierra_view.order_record_cmf ON order_view.record_id=order_record_cmf.order_record_id WHERE order_record_cmf.location_code = 'none';")
#For now, just storing the data in a variable. We'll use it later.
rows = cursor.fetchall()
conn.close()

#Creating the Excel file for staff
workbook = xlsxwriter.Workbook("WeeklyNewItem.xlsx")
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


