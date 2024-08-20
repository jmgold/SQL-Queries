#!/usr/bin/env python3

"""
Jeremy Goldstein
Minuteman Library Network

Generates custom new title lists requested by Cambridge as part of their website.
Produces 3 excel files, adult, childrens and branches, each of which includes multiple tabs representing different collections

Resulting files are then uploaded to an ftp server
"""

import psycopg2
import xlsxwriter
import os
import pysftp
import configparser
import sys
import time
from datetime import date

#connect to Sierra-db and store results of an sql query
def runquery(query):

    # import configuration file containing our connection string
    # app.ini looks like the following
    #[db]
    #connection_string = dbname='iii' user='PUT_USERNAME_HERE' host='sierra-db.library-name.org' password='PUT_PASSWORD_HERE' port=1032

    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\app_SIC.ini')
      
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
def excelWriter(query_results):
    #Name of Excel File
    excelfile =  'CAMNewTitles{}.xlsx'.format(date.today())
    excelfile2 =  'CAMNewTitlesChildrens{}.xlsx'.format(date.today())

    #Creating the Excel file for staff
    workbook = xlsxwriter.Workbook(excelfile,{'remove_timezone': True})
    workbook2 = xlsxwriter.Workbook(excelfile2,{'remove_timezone': True})
    worksheet = workbook.add_worksheet('General Fiction')
    worksheet1 = workbook.add_worksheet('Mystery')
    worksheet2 = workbook.add_worksheet('Science Fiction')
    worksheet3 = workbook.add_worksheet('Romance')
    worksheet4 = workbook.add_worksheet('Large Print')
    worksheet5 = workbook.add_worksheet('Poetry')
    worksheet6 = workbook.add_worksheet('Non-Fiction')
    worksheet7 = workbook.add_worksheet('Non-Fiction Large Print')
    worksheet8 = workbook.add_worksheet('Comics')
    worksheet9 = workbook.add_worksheet('DVD Blu-rays')
    worksheet10 = workbook.add_worksheet('CDs')
    worksheet11 = workbook.add_worksheet('Audiobooks')

    worksheet12 = workbook2.add_worksheet('Fiction')
    worksheet13 = workbook2.add_worksheet('Picture Books')
    worksheet14 = workbook2.add_worksheet('Begining Readers')
    worksheet15 = workbook2.add_worksheet('Board')
    worksheet16 = workbook2.add_worksheet('Comics')
    worksheet17 = workbook2.add_worksheet('Nonfiction')
    worksheet18 = workbook2.add_worksheet('Foreign language')
    worksheet19 = workbook2.add_worksheet('DVD Blu Rays')
    worksheet23 = workbook2.add_worksheet('AV')
    worksheet20 = workbook2.add_worksheet('YA Fiction')
    worksheet21 = workbook2.add_worksheet('YA Comics')
    worksheet22 = workbook2.add_worksheet('YA Nonfiction')
    worksheet24 = workbook2.add_worksheet('YA AV')

    #Formatting our Excel worksheet
    worksheet.set_landscape()
    worksheet.hide_gridlines(0)

    #Formatting Cells
    eformat= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformaturl= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'font_color': 'blue', 'top': 1, 'bottom': 1, 'right': 1})
    eformatlabel= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'bold': True, 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformatlabelurl= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'bold': True, 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'right': 1})
    eformat2= workbook2.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformaturl2= workbook2.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'font_color': 'blue', 'top': 1, 'bottom': 1, 'right': 1})
    eformatlabel2= workbook2.add_format({'text_wrap': True, 'valign': 'bottom', 'bold': True, 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformatlabelurl2= workbook2.add_format({'text_wrap': True, 'valign': 'bottom', 'bold': True, 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'right': 1})

    # Setting the column widths
    worksheet.set_column(0,0,25.71)
    worksheet.set_column(1,1,36.29)
    worksheet.set_column(2,2,80.43)
    worksheet1.set_column(0,0,25.71)
    worksheet1.set_column(1,1,36.29)
    worksheet1.set_column(2,2,80.43)
    worksheet2.set_column(0,0,25.71)
    worksheet2.set_column(1,1,36.29)
    worksheet2.set_column(2,2,80.43)
    worksheet3.set_column(0,0,25.71)
    worksheet3.set_column(1,1,36.29)
    worksheet3.set_column(2,2,80.43)
    worksheet4.set_column(0,0,25.71)
    worksheet4.set_column(1,1,36.29)
    worksheet4.set_column(2,2,80.43)
    worksheet5.set_column(0,0,25.71)
    worksheet5.set_column(1,1,36.29)
    worksheet5.set_column(2,2,80.43)
    worksheet6.set_column(0,0,25.71)
    worksheet6.set_column(1,1,36.29)
    worksheet6.set_column(2,2,80.43)
    worksheet7.set_column(0,0,25.71)
    worksheet7.set_column(1,1,36.29)
    worksheet7.set_column(2,2,80.43)
    worksheet8.set_column(0,0,25.71)
    worksheet8.set_column(1,1,36.29)
    worksheet8.set_column(2,2,80.43)
    worksheet9.set_column(0,0,25.71)
    worksheet9.set_column(1,1,36.29)
    worksheet9.set_column(2,2,80.43)
    worksheet10.set_column(0,0,25.71)
    worksheet10.set_column(1,1,36.29)
    worksheet10.set_column(2,2,80.43)
    worksheet11.set_column(0,0,25.71)
    worksheet11.set_column(1,1,36.29)
    worksheet11.set_column(2,2,80.43)
    worksheet12.set_column(0,0,25.71)
    worksheet12.set_column(1,1,36.29)
    worksheet12.set_column(2,2,80.43)
    worksheet13.set_column(0,0,25.71)
    worksheet13.set_column(1,1,36.29)
    worksheet13.set_column(2,2,80.43)
    worksheet14.set_column(0,0,25.71)
    worksheet14.set_column(1,1,36.29)
    worksheet14.set_column(2,2,80.43)
    worksheet15.set_column(0,0,25.71)
    worksheet15.set_column(1,1,36.29)
    worksheet15.set_column(2,2,80.43)
    worksheet16.set_column(0,0,25.71)
    worksheet16.set_column(1,1,36.29)
    worksheet16.set_column(2,2,80.43)
    worksheet17.set_column(0,0,25.71)
    worksheet17.set_column(1,1,36.29)
    worksheet17.set_column(2,2,80.43)
    worksheet18.set_column(0,0,25.71)
    worksheet18.set_column(1,1,36.29)
    worksheet18.set_column(2,2,80.43)
    worksheet19.set_column(0,0,25.71)
    worksheet19.set_column(1,1,36.29)
    worksheet19.set_column(2,2,80.43)
    worksheet20.set_column(0,0,25.71)
    worksheet20.set_column(1,1,36.29)
    worksheet20.set_column(2,2,80.43)
    worksheet21.set_column(0,0,25.71)
    worksheet21.set_column(1,1,36.29)
    worksheet21.set_column(2,2,80.43)
    worksheet22.set_column(0,0,25.71)
    worksheet22.set_column(1,1,36.29)
    worksheet22.set_column(2,2,80.43)
    worksheet23.set_column(0,0,25.71)
    worksheet23.set_column(1,1,36.29)
    worksheet23.set_column(2,2,80.43)
    worksheet24.set_column(0,0,25.71)
    worksheet24.set_column(1,1,36.29)
    worksheet24.set_column(2,2,80.43)

    #Inserting a header
    worksheet.set_header('Cam New Titles')

    # Adding column labels
    worksheet.write(0,0,'Call Number', eformatlabel)
    worksheet.write(0,1,'Author', eformatlabel)
    worksheet.write(0,2,'Title', eformatlabelurl)
    worksheet1.write(0,0,'Call Number', eformatlabel)
    worksheet1.write(0,1,'Author', eformatlabel)
    worksheet1.write(0,2,'Title', eformatlabelurl)
    worksheet2.write(0,0,'Call Number', eformatlabel)
    worksheet2.write(0,1,'Author', eformatlabel)
    worksheet2.write(0,2,'Title', eformatlabelurl)
    worksheet3.write(0,0,'Call Number', eformatlabel)
    worksheet3.write(0,1,'Author', eformatlabel)
    worksheet3.write(0,2,'Title', eformatlabelurl)
    worksheet4.write(0,0,'Call Number', eformatlabel)
    worksheet4.write(0,1,'Author', eformatlabel)
    worksheet4.write(0,2,'Title', eformatlabelurl)
    worksheet5.write(0,0,'Call Number', eformatlabel)
    worksheet5.write(0,1,'Author', eformatlabel)
    worksheet5.write(0,2,'Title', eformatlabelurl)
    worksheet6.write(0,0,'Call Number', eformatlabel)
    worksheet6.write(0,1,'Author', eformatlabel)
    worksheet6.write(0,2,'Title', eformatlabelurl)
    worksheet7.write(0,0,'Call Number', eformatlabel)
    worksheet7.write(0,1,'Author', eformatlabel)
    worksheet7.write(0,2,'Title', eformatlabelurl)
    worksheet8.write(0,0,'Call Number', eformatlabel)
    worksheet8.write(0,1,'Author', eformatlabel)
    worksheet8.write(0,2,'Title', eformatlabelurl)
    worksheet9.write(0,0,'Call Number', eformatlabel)
    worksheet9.write(0,1,'Author', eformatlabel)
    worksheet9.write(0,2,'Title', eformatlabelurl)
    worksheet10.write(0,0,'Call Number', eformatlabel)
    worksheet10.write(0,1,'Author', eformatlabel)
    worksheet10.write(0,2,'Title', eformatlabelurl)
    worksheet11.write(0,0,'Call Number', eformatlabel)
    worksheet11.write(0,1,'Author', eformatlabel)
    worksheet11.write(0,2,'Title', eformatlabelurl)
    worksheet12.write(0,0,'Call Number', eformatlabel2)
    worksheet12.write(0,1,'Author', eformatlabel2)
    worksheet12.write(0,2,'Title', eformatlabelurl2)
    worksheet13.write(0,0,'Call Number', eformatlabel2)
    worksheet13.write(0,1,'Author', eformatlabel2)
    worksheet13.write(0,2,'Title', eformatlabelurl2)
    worksheet14.write(0,0,'Call Number', eformatlabel2)
    worksheet14.write(0,1,'Author', eformatlabel2)
    worksheet14.write(0,2,'Title', eformatlabelurl2)
    worksheet15.write(0,0,'Call Number', eformatlabel2)
    worksheet15.write(0,1,'Author', eformatlabel2)
    worksheet15.write(0,2,'Title', eformatlabelurl2)
    worksheet16.write(0,0,'Call Number', eformatlabel2)
    worksheet16.write(0,1,'Author', eformatlabel2)
    worksheet16.write(0,2,'Title', eformatlabelurl2)
    worksheet17.write(0,0,'Call Number', eformatlabel2)
    worksheet17.write(0,1,'Author', eformatlabel2)
    worksheet17.write(0,2,'Title', eformatlabelurl2)
    worksheet18.write(0,0,'Call Number', eformatlabel2)
    worksheet18.write(0,1,'Author', eformatlabel2)
    worksheet18.write(0,2,'Title', eformatlabelurl2)
    worksheet19.write(0,0,'Call Number', eformatlabel2)
    worksheet19.write(0,1,'Author', eformatlabel2)
    worksheet19.write(0,2,'Title', eformatlabelurl2)
    worksheet20.write(0,0,'Call Number', eformatlabel2)
    worksheet20.write(0,1,'Author', eformatlabel2)
    worksheet20.write(0,2,'Title', eformatlabelurl2)
    worksheet21.write(0,0,'Call Number', eformatlabel2)
    worksheet21.write(0,1,'Author', eformatlabel2)
    worksheet21.write(0,2,'Title', eformatlabelurl2)
    worksheet22.write(0,0,'Call Number', eformatlabel2)
    worksheet22.write(0,1,'Author', eformatlabel2)
    worksheet22.write(0,2,'Title', eformatlabelurl2)
    worksheet23.write(0,0,'Call Number', eformatlabel2)
    worksheet23.write(0,1,'Author', eformatlabel2)
    worksheet23.write(0,2,'Title', eformatlabelurl2)
    worksheet24.write(0,0,'Call Number', eformatlabel2)
    worksheet24.write(0,1,'Author', eformatlabel2)
    worksheet24.write(0,2,'Title', eformatlabelurl2)

    # Writing the report for staff to the Excel worksheet
    row0 = 1
    row1 = 1
    row2 = 1
    row3 = 1
    row4 = 1
    row5 = 1
    row6 = 1
    row7 = 1
    row8 = 1
    row9 = 1
    row10 = 1
    row11 = 1
    row12 = 1
    row13 = 1
    row14 = 1
    row15 = 1
    row16 = 1
    row17 = 1
    row18 = 1
    row19 = 1
    row20 = 1
    row21 = 1
    row22 = 1
    row23 = 1
    row24 = 1

    for rownum, row in enumerate(query_results):
        if row[4] == 101:
            worksheet.write(row0,0,row[0], eformat)
            worksheet.write_url(row0,2,row[1], eformaturl, string=row[2])
            worksheet.write(row0,1,row[3], eformat)
            row0 += 1
        elif row[4] == 102:
            worksheet1.write(row1,0,row[0], eformat)
            worksheet1.write_url(row1,2,row[1], eformaturl, string=row[2])
            worksheet1.write(row1,1,row[3], eformat)
            row1 += 1
        elif row[4] == 103:
            worksheet2.write(row2,0,row[0], eformat)
            worksheet2.write_url(row2,2,row[1], eformaturl, string=row[2])
            worksheet2.write(row2,1,row[3], eformat)
            row2 += 1
        elif row[4] == 124:
            worksheet3.write(row3,0,row[0], eformat)
            worksheet3.write_url(row3,2,row[1], eformaturl, string=row[2])
            worksheet3.write(row3,1,row[3], eformat)
            row3 += 1
        elif row[4] == 128:
            worksheet4.write(row4,0,row[0], eformat)
            worksheet4.write_url(row4,2,row[1], eformaturl, string=row[2])
            worksheet4.write(row4,1,row[3], eformat)
            row4 += 1
        elif row[4] == 109:
            worksheet5.write(row5,0,row[0], eformat)
            worksheet5.write_url(row5,2,row[1], eformaturl, string=row[2])
            worksheet5.write(row5,1,row[3], eformat)
            row5 += 1
        elif row[4] == 129:
            worksheet7.write(row7,0,row[0], eformat)
            worksheet7.write_url(row7,2,row[1], eformaturl, string=row[2])
            worksheet7.write(row7,1,row[3], eformat)
            row7 += 1 
        elif (row[4] == 107) or (row[4] == 108):
            worksheet8.write(row8,0,row[0], eformat)
            worksheet8.write_url(row8,2,row[1], eformaturl, string=row[2])
            worksheet8.write(row8,1,row[3], eformat)
            row8 += 1
        elif 19 <= row[5] <= 28:
            worksheet9.write(row9,0,row[0], eformat)
            worksheet9.write_url(row9,2,row[1], eformaturl, string=row[2])
            worksheet9.write(row9,1,row[3], eformat)
            row9 += 1
        elif 33 <= row[5] <= 34:
            worksheet10.write(row10,0,row[0], eformat)
            worksheet10.write_url(row10,2,row[1], eformaturl, string=row[2])
            worksheet10.write(row10,1,row[3], eformat)
            row10 += 1
        elif ((36 <= row[5] <= 37) or row[5] == 50):
            worksheet11.write(row11,0,row[0], eformat)
            worksheet11.write_url(row11,2,row[1], eformaturl, string=row[2])
            worksheet11.write(row11,1,row[3], eformat)
            row11 += 1
        elif (row[4] == 232 or row[4] == 237):
            worksheet12.write(row12,0,row[0], eformat2)
            worksheet12.write_url(row12,2,row[1], eformaturl2, string=row[2])
            worksheet12.write(row12,1,row[3], eformat2)
            row12 += 1
        elif row[4] == 230:
            worksheet13.write(row13,0,row[0], eformat2)
            worksheet13.write_url(row13,2,row[1], eformaturl2, string=row[2])
            worksheet13.write(row13,1,row[3], eformat2)
            row13 += 1
        elif row[4] == 231:
            worksheet14.write(row14,0,row[0], eformat2)
            worksheet14.write_url(row14,2,row[1], eformaturl2, string=row[2])
            worksheet14.write(row14,1,row[3], eformat2)
            row14 += 1
        elif row[4] == 228:
            worksheet15.write(row15,0,row[0], eformat2)
            worksheet15.write_url(row15,2,row[1], eformaturl2, string=row[2])
            worksheet15.write(row15,1,row[3], eformat2)
            row15 += 1
        elif row[4] == 229:
            worksheet16.write(row16,0,row[0], eformat2)
            worksheet16.write_url(row16,2,row[1], eformaturl2, string=row[2])
            worksheet16.write(row16,1,row[3], eformat2)
            row16 += 1
        elif ((250 <= row[4] <= 261) or row[4] == 238 or row[4] == 240):
            worksheet17.write(row17,0,row[0], eformat2)
            worksheet17.write_url(row17,2,row[1], eformaturl2, string=row[2])
            worksheet17.write(row17,1,row[3], eformat2)
            row17 += 1
        elif 262 <= row[4] <= 265:
            worksheet18.write(row18,0,row[0], eformat2)
            worksheet18.write_url(row18,2,row[1], eformaturl2, string=row[2])
            worksheet18.write(row18,1,row[3], eformat2)
            row18 += 1
        elif 163 <= row[5] <= 168:
            worksheet19.write(row19,0,row[0], eformat2)
            worksheet19.write_url(row19,2,row[1], eformaturl2, string=row[2])
            worksheet19.write(row19,1,row[3], eformat2)
            row19 += 1
        elif row[4] == 212:
            worksheet20.write(row20,0,row[0], eformat2)
            worksheet20.write_url(row20,2,row[1], eformaturl2, string=row[2])
            worksheet20.write(row20,1,row[3], eformat2)
            row20 += 1
        elif row[4] == 211:
            worksheet21.write(row21,0,row[0], eformat2)
            worksheet21.write_url(row21,2,row[1], eformaturl2, string=row[2])
            worksheet21.write(row21,1,row[3], eformat2)
            row21 += 1
        elif row[4] == 210:
            worksheet22.write(row22,0,row[0], eformat2)
            worksheet22.write_url(row22,2,row[1], eformaturl2, string=row[2])
            worksheet22.write(row22,1,row[3], eformat2)
            row22 += 1
        elif row[4] == 248 or row[4] == 244:
            worksheet23.write(row23,0,row[0], eformat2)
            worksheet23.write_url(row23,2,row[1], eformaturl2, string=row[2])
            worksheet23.write(row23,1,row[3], eformat2)
            row23 += 1
        elif row[4] == 226 or row[4] == 223 or row[4] == 224:
            worksheet24.write(row24,0,row[0], eformat2)
            worksheet24.write_url(row24,2,row[1], eformaturl2, string=row[2])
            worksheet24.write(row24,1,row[3], eformat2)
            row24 += 1
        elif ((1 <= row[4] <= 91) or row[4] == 100 or row[4] == 109 or (113 <= row[4] <= 119) or row[4] == 130 or row[4] == 139):
           worksheet6.write(row6,0,row[0], eformat)
           worksheet6.write_url(row6,2,row[1], eformaturl, string=row[2])
           worksheet6.write(row6,1,row[3], eformat)
           row6 += 1
    
    
    workbook.close()
    workbook2.close()
    
    ftp_file(excelfile)
    ftp_file(excelfile2)


def excelWriterBranches(query_results,excelfile):

    #Creating the Excel file for staff
    workbook = xlsxwriter.Workbook(excelfile,{'remove_timezone': True})
    worksheet = workbook.add_worksheet('Boudreau')
    worksheet1 = workbook.add_worksheet('Central')
    worksheet2 = workbook.add_worksheet('Collins')
    worksheet3 = workbook.add_worksheet('O''Connell')
    worksheet4 = workbook.add_worksheet('O''Neill')
    worksheet5 = workbook.add_worksheet('Valente')

    #Formatting our Excel worksheet
    worksheet.set_landscape()
    worksheet.hide_gridlines(0)

    #Formatting Cells
    eformat= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformaturl= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'font_color': 'blue', 'top': 1, 'bottom': 1, 'right': 1})
    eformatlabel= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'bold': True, 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformatlabelurl= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'bold': True, 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'right': 1})

    # Setting the column widths
    worksheet.set_column(0,0,25.71)
    worksheet.set_column(1,1,36.29)
    worksheet.set_column(2,2,80.43)
    worksheet1.set_column(0,0,25.71)
    worksheet1.set_column(1,1,36.29)
    worksheet1.set_column(2,2,80.43)
    worksheet2.set_column(0,0,25.71)
    worksheet2.set_column(1,1,36.29)
    worksheet2.set_column(2,2,80.43)
    worksheet3.set_column(0,0,25.71)
    worksheet3.set_column(1,1,36.29)
    worksheet3.set_column(2,2,80.43)
    worksheet4.set_column(0,0,25.71)
    worksheet4.set_column(1,1,36.29)
    worksheet4.set_column(2,2,80.43)
    worksheet5.set_column(0,0,25.71)
    worksheet5.set_column(1,1,36.29)
    worksheet5.set_column(2,2,80.43)

    #Inserting a header
    worksheet.set_header('Cam Branches New Titles')

    # Adding column labels
    worksheet.write(0,0,'Call Number', eformatlabel)
    worksheet.write(0,1,'Author', eformatlabel)
    worksheet.write(0,2,'Title', eformatlabelurl)
    worksheet1.write(0,0,'Call Number', eformatlabel)
    worksheet1.write(0,1,'Author', eformatlabel)
    worksheet1.write(0,2,'Title', eformatlabelurl)
    worksheet2.write(0,0,'Call Number', eformatlabel)
    worksheet2.write(0,1,'Author', eformatlabel)
    worksheet2.write(0,2,'Title', eformatlabelurl)
    worksheet3.write(0,0,'Call Number', eformatlabel)
    worksheet3.write(0,1,'Author', eformatlabel)
    worksheet3.write(0,2,'Title', eformatlabelurl)
    worksheet4.write(0,0,'Call Number', eformatlabel)
    worksheet4.write(0,1,'Author', eformatlabel)
    worksheet4.write(0,2,'Title', eformatlabelurl)
    worksheet5.write(0,0,'Call Number', eformatlabel)
    worksheet5.write(0,1,'Author', eformatlabel)
    worksheet5.write(0,2,'Title', eformatlabelurl)

    # Writing the report for staff to the Excel worksheet
    row0 = 1
    row1 = 1
    row2 = 1
    row3 = 1
    row4 = 1
    row5 = 1

    for rownum, row in enumerate(query_results):
        if row[6] == 'ca4':
            worksheet.write(row0,0,row[0], eformat)
            worksheet.write_url(row0,2,row[1], eformaturl, string=row[2])
            worksheet.write(row0,1,row[3], eformat)
            row0 += 1
        elif row[6] == 'ca5':
            worksheet1.write(row1,0,row[0], eformat)
            worksheet1.write_url(row1,2,row[1], eformaturl, string=row[2])
            worksheet1.write(row1,1,row[3], eformat)
            row1 += 1
        elif row[6] == 'ca6':
            worksheet2.write(row2,0,row[0], eformat)
            worksheet2.write_url(row2,2,row[1], eformaturl, string=row[2])
            worksheet2.write(row2,1,row[3], eformat)
            row2 += 1
        elif row[6] == 'ca7':
            worksheet3.write(row3,0,row[0], eformat)
            worksheet3.write_url(row3,2,row[1], eformaturl, string=row[2])
            worksheet3.write(row3,1,row[3], eformat)
            row3 += 1
        elif row[6] == 'ca8':
            worksheet4.write(row4,0,row[0], eformat)
            worksheet4.write_url(row4,2,row[1], eformaturl, string=row[2])
            worksheet4.write(row4,1,row[3], eformat)
            row4 += 1
        elif row[6] == 'ca9':
            worksheet5.write(row5,0,row[0], eformat)
            worksheet5.write_url(row5,2,row[1], eformaturl, string=row[2])
            worksheet5.write(row5,1,row[3], eformat)
            row5 += 1  
    
    workbook.close()
    return excelfile

#upload report to SIC directory and optionally remove older files
def ftp_file(local_file):

    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\app_SIC.ini')

    cnopts = pysftp.CnOpts()

    srv = pysftp.Connection(host = config['sic']['sic_host'], username = config['sic']['sic_user'], password= config['sic']['sic_pw'], cnopts=cnopts)

    local_file = local_file

    srv.cwd('/reports/Library-Specific Reports/Cambridge/New Titles/')
    srv.put(local_file)

    #remove old file

    for fname in srv.listdir_attr():
        fullpath = '/reports/Library-Specific Reports/Cambridge/New Titles/{}'.format(fname.filename)
        #time tracked in seconds, st_mtime is time last modified
        name = str(fname.filename)
        if (name != 'meta.json') and ((time.time() - fname.st_mtime) // (24 * 3600) >= 1095):
            srv.remove(fullpath)

    srv.close()
    os.remove(local_file)
    
def main():
	
    tempFile = runquery("cam new list.sql")
    excelWriter(tempFile)

def main_branches():
	
    tempFile = runquery("cam branches new list.sql")
    #Name of Excel File
    excelfile =  'CAMBranchesNewTitles{}.xlsx'.format(date.today())
    local_file = excelWriterBranches(tempFile,excelfile)
    ftp_file(local_file)

main()
main_branches()
