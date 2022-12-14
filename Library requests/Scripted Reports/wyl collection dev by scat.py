#!/usr/bin/env python3

"""
Jeremy Goldstein
Minuteman Library Network

Generates custom collection development report
Listing out the turnover rate (based on last year checkouts) by Scat Code

Resulting spreadsheet is color coded for areas to weed, expand or monitor for future expansion
"""

import psycopg2
import xlsxwriter
import os
import configparser
import sys
import time
from datetime import date

#connect to Sierra-db and store results of an sql query
def runquery():

    # import configuration file containing our connection string
    # app.ini looks like the following
    #[db]
    #connection_string = dbname='iii' user='PUT_USERNAME_HERE' host='sierra-db.library-name.org' password='PUT_PASSWORD_HERE' port=1032

    config = configparser.ConfigParser()
    config.read('Y:\\SQL Reports\\creds\\app.ini')
    
    query = """\
    SELECT
    /*CASE
        WHEN icode1 = 1 THEN 'Adult Fiction'
        WHEN icode1 = 2 THEN 'Adult Mystery'
        WHEN icode1 = 3 THEN 'Adult Science Fiction'
        WHEN icode1 = 4 THEN 'LG PT'
        WHEN icode1 = 10 THEN 'Adult NF 100''s'
        WHEN icode1 = 11 THEN 'Adult NF 120''s'
        WHEN icode1 = 13 THEN 'Adult NF 130''s'
        WHEN icode1 = 14 THEN 'Adult NF 140''s'
        WHEN icode1 = 15 THEN 'Adult NF 150''s'
        WHEN icode1 = 16 THEN 'Adult NF 160''s'
        WHEN icode1 = 17 THEN 'Adult NF 170''s'
        WHEN icode1 = 18 THEN 'Adult NF 180''s'
        WHEN icode1 = 19 THEN 'Adult NF 190''s'
        WHEN icode1 = 20 THEN 'Adult NF 200''s'
        WHEN icode1 = 21 THEN 'Adult NF 210''s'
        WHEN icode1 = 22 THEN 'Adult NF 220''s'
        WHEN icode1 = 23 THEN 'Adult NF 230''s'
        WHEN icode1 = 24 THEN 'Adult NF 240''s'
        WHEN icode1 = 25 THEN 'Adult NF 250''s'
        WHEN icode1 = 26 THEN 'Adult NF 260''s'
        WHEN icode1 = 27 THEN 'Adult NF 270''s'
        WHEN icode1 = 28 THEN 'Adult NF 280''s'
        WHEN icode1 = 29 THEN 'Adult NF 290''s'
        WHEN icode1 = 30 THEN 'Adult NF 300''s'
        WHEN icode1 = 31 THEN 'Adult NF 310''s'
        WHEN icode1 = 32 THEN 'Adult NF 320''s'
        WHEN icode1 = 33 THEN 'Adult NF 330''s'
        WHEN icode1 = 34 THEN 'Adult NF 340''s'
        WHEN icode1 = 35 THEN 'Adult NF 350''s'
        WHEN icode1 = 36 THEN 'Adult NF 360''s'
        WHEN icode1 = 37 THEN 'Adult NF 370''s'
        WHEN icode1 = 38 THEN 'Adult NF 380''s'
        WHEN icode1 = 39 THEN 'Adult NF 390''s'
        WHEN icode1 = 40 THEN 'Adult NF 400''s'
        WHEN icode1 = 41 THEN 'Adult NF 410''s'
        WHEN icode1 = 42 THEN 'Adult NF 420''s'
        WHEN icode1 = 43 THEN 'Adult ESOL'
        WHEN icode1 = 44 THEN 'Adult NF 440''s'
        WHEN icode1 = 45 THEN 'Adult NF 450''s'
        WHEN icode1 = 46 THEN 'Adult NF 460''s'
        WHEN icode1 = 47 THEN 'Adult NF 470''s'
        WHEN icode1 = 48 THEN 'Adult NF 480''s'
        WHEN icode1 = 49 THEN 'Adult NF 490''s'
        WHEN icode1 = 50 THEN 'Adult NF 500''s'
        WHEN icode1 = 51 THEN 'Adult NF 510''s'
        WHEN icode1 = 52 THEN 'Adult NF 520''s'
        WHEN icode1 = 53 THEN 'Adult NF 530''s'
        WHEN icode1 = 54 THEN 'Adult NF 540''s'
        WHEN icode1 = 55 THEN 'Adult NF 550''s'
        WHEN icode1 = 56 THEN 'Adult NF 560''s'
        WHEN icode1 = 57 THEN 'Adult NF 570''s'
        WHEN icode1 = 58 THEN 'Adult NF 580''s'
        WHEN icode1 = 59 THEN 'Adult NF 590''s'
        WHEN icode1 = 60 THEN 'Adult NF 600''s'
        WHEN icode1 = 61 THEN 'Adult NF 610''s'
        WHEN icode1 = 62 THEN 'Adult NF 620''s'
        WHEN icode1 = 63 THEN 'Adult NF 630''s'
        WHEN icode1 = 64 THEN 'Adult NF 640''s'
        WHEN icode1 = 65 THEN 'Adult NF 650''s'
        WHEN icode1 = 66 THEN 'Adult NF 660''s'
        WHEN icode1 = 67 THEN 'Adult NF 670''s'
        WHEN icode1 = 68 THEN 'Adult NF 680''s'
        WHEN icode1 = 69 THEN 'Adult NF 690''s'
        WHEN icode1 = 70 THEN 'Adult NF 700''s'
        WHEN icode1 = 71 THEN 'Adult NF 710''s'
        WHEN icode1 = 72 THEN 'Adult NF 720''s'
        WHEN icode1 = 73 THEN 'Adult NF 730''s'
        WHEN icode1 = 74 THEN 'Adult NF 740''s'
        WHEN icode1 = 75 THEN 'Adult NF 750''s'
        WHEN icode1 = 76 THEN 'Adult NF 760''s'
        WHEN icode1 = 77 THEN 'Adult NF 770''s'
        WHEN icode1 = 78 THEN 'Adult NF 780''s'
        WHEN icode1 = 79 THEN 'Adult NF 790''s'
        WHEN icode1 = 80 THEN 'Adult NF 800''s'
        WHEN icode1 = 81 THEN 'Adult NF 810''s'
        WHEN icode1 = 82 THEN 'Adult NF 820''s'
        WHEN icode1 = 83 THEN 'Adult NF 830''s'
        WHEN icode1 = 84 THEN 'Adult NF 840''s'
        WHEN icode1 = 85 THEN 'Adult NF 850''s'
        WHEN icode1 = 86 THEN 'Adult NF 860''s'
        WHEN icode1 = 87 THEN 'Adult NF 870''s'
        WHEN icode1 = 88 THEN 'Adult NF 880''s'
        WHEN icode1 = 89 THEN 'Adult NF 890''s'
        WHEN icode1 = 90 THEN 'Adult NF 900''s'
        WHEN icode1 = 91 THEN 'Adult Travel and Adult NF 910''s'
        WHEN icode1 = 92 THEN 'Adult Biography and Adult NF 920''s'
        WHEN icode1 = 93 THEN 'Adult NF 930''s'
        WHEN icode1 = 94 THEN 'Adult NF 940''s'
        WHEN icode1 = 95 THEN 'Adult NF 950''s'
        WHEN icode1 = 96 THEN 'Adult NF 960''s'
        WHEN icode1 = 97 THEN 'Adult NF 970''s'
        WHEN icode1 = 98 THEN 'Adult NF 980''s'
        WHEN icode1 = 99 THEN 'Adult NF 990''s'
        WHEN icode1 = 100 THEN 'Adult NF 000''s'
        WHEN icode1 = 101 THEN 'Adult Periodicals'
        WHEN icode1 = 102 THEN 'Adult NF Computers'
        WHEN icode1 = 135 THEN 'Adult DVD'
        WHEN icode1 = 140 THEN 'Adult DVD NF'
        WHEN icode1 = 155 THEN 'Adult Book on CDs'
        WHEN icode1 = 159 THEN 'Adult DVD Series'
        WHEN icode1 = 161 THEN 'YA Fic (and Graphic Novels)'
        WHEN icode1 = 162 THEN 'YA NF'
        WHEN icode1 = 163 THEN 'Teen Fiction'
        WHEN icode1 = 164 THEN 'Teen NF'
        WHEN icode1 = 199 THEN 'CR Reference'
        WHEN icode1 = 201 THEN 'CR Advanced Picture Books (and 1-3 CR Fiction and CR Fiction and CR Graphic Novels)'
        WHEN icode1 = 206 THEN 'CR Picture Books (and Boardbooks and Holiday Books)'
        WHEN icode1 = 207 THEN 'CR (and YA) Media Player'
        WHEN icode1 = 208 THEN 'CR (and YA) Video Games (Wii, XBOX 360, PS3, DS)'
        WHEN icode1 = 209 THEN 'CR Easy Readers'
        WHEN icode1 = 210 THEN 'CR NF 000''s'
        WHEN icode1 = 211 THEN 'CR NF 100''s'
        WHEN icode1 = 212 THEN 'CR NF 200''s'
        WHEN icode1 = 213 THEN 'CR NF 300''s'
        WHEN icode1 = 214 THEN 'CR NF 400''s'
        WHEN icode1 = 215 THEN 'CR NF 500''s'
        WHEN icode1 = 216 THEN 'CR NF 600''s'
        WHEN icode1 = 217 THEN 'CR NF 700''s'
        WHEN icode1 = 218 THEN 'CR NF 800''s'
        WHEN icode1 = 219 THEN 'CR NF 900''s'
        WHEN icode1 = 220 THEN 'CR Biography'
        WHEN icode1 = 221 THEN 'Adult Media Player'
        WHEN icode1 = 227 THEN 'Adult CD Music'
        WHEN icode1 = 230 THEN 'Museum Passes'
        WHEN icode1 = 234 THEN 'Adult VHS Video'
        WHEN icode1 = 239 THEN 'Adult Reference'
        ELSE icode1::VARCHAR
    END*/icode1::VARCHAR AS "Scat",
    COUNT (item_record.id) AS "Item total",
    round(cast(count(item_record.id) as numeric (12,2)) / (select cast(count (item_record.id) as numeric (12,2))from sierra_view.item_record JOIN sierra_view.record_metadata ON item_record.id = record_metadata.id AND record_metadata.creation_date_gmt::DATE < '2022-07-01' where location_code LIKE 'wyl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd')), 6) as relative_item_total,
    /*
	 SUM(checkout_total) + SUM(renewal_total) AS "Total_Circulation",
    round(cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) / (SELECT cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_record where location_code LIKE 'wyl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd')), 6) as relative_circ,
    round(cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2))/cast(count (id) as numeric (12,2)), 2) as turnover
    */
	 SUM(last_year_to_date_checkout_total) AS "Total_Circulation",
    round(cast(SUM(last_year_to_date_checkout_total) as numeric (12,2)) / (SELECT cast(SUM(last_year_to_date_checkout_total) as numeric (12,2)) from sierra_view.item_record JOIN sierra_view.record_metadata ON item_record.id = record_metadata.id AND record_metadata.creation_date_gmt::DATE < '2022-07-01' where location_code LIKE 'wyl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd')), 6) as relative_circ,
    round(cast(SUM(last_year_to_date_checkout_total) as numeric (12,2))/cast(count (item_record.id) as numeric (12,2)), 2) as turnover
    FROM
    sierra_view.item_record
    JOIN
    sierra_view.record_metadata
    ON
    item_record.id = record_metadata.id AND record_metadata.creation_date_gmt::DATE < '2022-07-01'
    WHERE location_code LIKE 'wyl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd')
    GROUP BY icode1
    ORDER BY icode1
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
    
    return rows

#convert sql query results into formatted excel file
def excelWriter(query_results):
    #Name of Excel File
    excelfile =  'WYLCollectionDev.xlsx'.format(date.today())

    #Creating the Excel file for staff
    workbook = xlsxwriter.Workbook(excelfile,{'remove_timezone': True})
    
    worksheet = workbook.add_worksheet('New Titles')

    #Formatting our Excel worksheet
    worksheet.set_landscape()
    worksheet.hide_gridlines(0)

    #Formatting Cells
    eformat= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformatpercent= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    eformatgreen= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'bg_color': '#C6EFCE'})
    eformatred= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'bg_color': '#FFC7CE'})
    eformatblue= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'bg_color': '#F5F4B5'})
    eformatpercentgreen= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'bg_color': '#C6EFCE'})
    eformatpercentred= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'bg_color': '#FFC7CE'})
    eformatpercentblue= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1, 'bg_color': '#F5F4B5'})
    eformatlabel= workbook.add_format({'text_wrap': True, 'valign': 'bottom', 'bold': True, 'font_name': 'Arial', 'font_size': '10', 'text_wrap': True, 'top': 1, 'bottom': 1})
    
    eformatpercent.set_num_format(0x0a)
    eformatpercentgreen.set_num_format(0x0a)
    eformatpercentred.set_num_format(0x0a)
    eformatpercentblue.set_num_format(0x0a)
    
    
    # Setting the column widths
    worksheet.set_column(0,0,48)
    worksheet.set_column(1,1,10.29)
    worksheet.set_column(2,2,10)
    worksheet.set_column(3,3,10.14)
    worksheet.set_column(4,4,10)
    worksheet.set_column(5,5,8.86)

    #Inserting a header
    worksheet.set_header('WYL Collection Dev Report')

    # Adding column labels
    worksheet.write(0,0,'Scat', eformatlabel)
    worksheet.write(0,1,'Item Total', eformatlabel)
    worksheet.write(0,2,'Relative Item Total', eformatlabel)
    worksheet.write(0,3,'Circulation Total', eformatlabel)
    worksheet.write(0,4,'Relative Circulation', eformatlabel)
    worksheet.write(0,5,'Turnover', eformatlabel)

    # Writing the report for staff to the Excel worksheet
    #row0 = 1

    for rownum, row in enumerate(query_results):
        if row[5] >= 3.5:#row[4] - row[2]) > 3.4:
            worksheet.write(rownum+1,0,row[0], eformatgreen)
            worksheet.write(rownum+1,1,row[1], eformatgreen)
            worksheet.write(rownum+1,2,row[2], eformatpercentgreen)
            worksheet.write(rownum+1,3,row[3], eformatgreen)
            worksheet.write(rownum+1,4,row[4], eformatpercentgreen)
            worksheet.write(rownum+1,5,row[5], eformatgreen)
        elif 1 <= row[5] < 3.5:#row[4] - row[2]) > 3.4:
            worksheet.write(rownum+1,0,row[0], eformatblue)
            worksheet.write(rownum+1,1,row[1], eformatblue)
            worksheet.write(rownum+1,2,row[2], eformatpercentblue)
            worksheet.write(rownum+1,3,row[3], eformatblue)
            worksheet.write(rownum+1,4,row[4], eformatpercentblue)
            worksheet.write(rownum+1,5,row[5], eformatblue)
        elif row[5] <= .5:#(row[2] - row[4]) >= .5:
            worksheet.write(rownum+1,0,row[0], eformatred)
            worksheet.write(rownum+1,1,row[1], eformatred)
            worksheet.write(rownum+1,2,row[2], eformatpercentred)
            worksheet.write(rownum+1,3,row[3], eformatred)
            worksheet.write(rownum+1,4,row[4], eformatpercentred)
            worksheet.write(rownum+1,5,row[5], eformatred)
        else:	
            worksheet.write(rownum+1,0,row[0], eformat)
            worksheet.write(rownum+1,1,row[1], eformat)
            worksheet.write(rownum+1,2,row[2], eformatpercent)
            worksheet.write(rownum+1,3,row[3], eformat)
            worksheet.write(rownum+1,4,row[4], eformatpercent)
            worksheet.write(rownum+1,5,row[5], eformat)
        
        #row0 += 1    
    
    workbook.close()

    
def main():
	
    tempFile = runquery()
    excelWriter(tempFile)

main()
