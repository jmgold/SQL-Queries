#!/usr/bin/env python3

"""
Jeremy Goldstein
Minuteman Library Network

Generates custom new Chinese Language title lists requested by Bedford, 
display Chinese authors/titles when available or English when not.
"""

import psycopg2
import xlsxwriter
import os
#import pysftp
import configparser
import sys
import time
from datetime import date
import configparser

#connect to Sierra-db and store results of an sql query
def runquery(query):

    # import configuration file containing our connection string
    # app.ini looks like the following
    #[db]
    #connection_string = dbname='iii' user='PUT_USERNAME_HERE' host='sierra-db.library-name.org' password='PUT_PASSWORD_HERE' port=1032

    config = configparser.ConfigParser()
    config.read('Y:\\SQL Reports\\creds\\app.ini')
      
    try:
	    # variable connection string should be defined in the imported config file
        conn = psycopg2.connect( config['db']['connection_string'] )
    except:
        print("unable to connect to the database")
        clear_connection()
        return
        
    #Opening a session and querying the database for weekly new items
    cursor = conn.cursor()
    cursor.execute(open(query,"r").read())
    #For now, just storing the data in a variable. We'll use it later.
    rows = cursor.fetchall()
    conn.close()
    
    return rows

#convert sql query results into formatted excel file
def excelWriter(query_results,excelfile):
    
    #Creating the Excel file for staff
    workbook = xlsxwriter.Workbook(excelfile,{'remove_timezone': True})
    
    worksheet = workbook.add_worksheet('New Titles')

    #Formatting our Excel worksheet
    worksheet.set_landscape()
    worksheet.hide_gridlines(0)

    #Formatting Cells
    eformat= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformaturl= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'font_color': 'blue', 'top': 1, 'bottom': 1, 'right': 1})
    eformatlabel= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'bold': True, 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
   
    # Setting the column widths
    worksheet.set_column(0,0,25.71)
    worksheet.set_column(1,1,36.29)
    worksheet.set_column(2,2,80.43)
    worksheet.set_column(3,3,20)
    worksheet.set_column(4,4,36.29)
    worksheet.set_column(5,5,80.43)

    #Inserting a header
    worksheet.set_header('BED New Titles')

    # Adding column labels
    worksheet.write(0,0,'Call Number', eformatlabel)
    worksheet.write(0,1,'Author', eformatlabel)
    worksheet.write(0,2,'Title', eformatlabel)
    worksheet.write(0,3,'ISBN', eformatlabel)
    worksheet.write(0,4,'Author_English', eformatlabel)
    worksheet.write(0,5,'Title_English', eformatlabel)

    # Writing the report for staff to the Excel worksheet
    row0 = 1

    for rownum, row in enumerate(query_results):
        worksheet.write(row0,0,row[0], eformat)
        worksheet.write(row0,1,row[3], eformat)
        worksheet.write_url(row0,2,row[5], eformaturl, string=row[1])
        worksheet.write(row0,3,row[6], eformat)
        worksheet.write(row0,4,row[4], eformat)
        worksheet.write(row0,5,row[2], eformat)
        row0 += 1    
    
    workbook.close()

    
def main():
	
    tempFile1 = runquery("bed chinese titles.sql")
    excelFile1 =  'BEDChineseTitles.xlsx'.format(date.today())
    excelWriter(tempFile1,excelFile1)
    tempFile2 = runquery("bed chinese titles juv.sql")
    excelFile2 =  'BEDChineseTitlesJuv.xlsx'.format(date.today())
    excelWriter(tempFile2,excelFile2)

main()
