#!/usr/bin/env python3

#olin report waiting on accounting unit assignment

"""Create and email weekly purhcase alert

Based on code from Gem Stone-Logan
"""

import psycopg2
import xlsxwriter
import os
import pysftp
import configparser
import sys
import time
from datetime import date

#convert sql query results into formatted excel file
def excelWriter(query_results,excelfile):

    #Creating the Excel file for staff
    workbook = xlsxwriter.Workbook(excelfile,{'remove_timezone': True})
    worksheet_adf = workbook.add_worksheet('Adult Fic')
    worksheet_adnf = workbook.add_worksheet('Adult NF')
    worksheet_adlp = workbook.add_worksheet('Large Print')
    worksheet_adunknown = workbook.add_worksheet('Adult Unknown')
    worksheet_adav = workbook.add_worksheet('Adult AV')
    worksheet_j = workbook.add_worksheet('Juv')
    worksheet_ya = workbook.add_worksheet('YA')
    worksheet_other = workbook.add_worksheet('Other')


    #Formatting our Excel worksheet
    worksheet_adf.set_landscape()
    worksheet_adf.hide_gridlines(0)

    #Formatting Cells
    eformat= workbook.add_format({'text_wrap': True, 'valign': 'top'})
    eformatlabel= workbook.add_format({'text_wrap': True, 'valign': 'top', 'bold': True})
    link_format = workbook.add_format({'color': 'blue', 'underline': 1})

    # Setting the column widths
    worksheet_adf.set_column(0,0,14.14)
    worksheet_adf.set_column(1,1,42.43)
    worksheet_adf.set_column(2,2,26.57)
    worksheet_adf.set_column(3,3,10.14)
    worksheet_adf.set_column(4,4,13)
    worksheet_adf.set_column(5,5,9.14)
    worksheet_adf.set_column(6,6,12.71)
    worksheet_adf.set_column(7,7,8.71)
    worksheet_adf.set_column(8,8,12.43)
    worksheet_adf.set_column(9,9,12.71)
    worksheet_adf.set_column(10,10,9.57)
    worksheet_adf.set_column(11,11,22)
    worksheet_adf.set_column(12,12,8.57)
    worksheet_adf.set_column(13,13,12.43)
    worksheet_adf.set_column(14,14,17.14)
    worksheet_adf.set_column(15,15,13.57)
    worksheet_adf.set_column(16,16,45.71)
    worksheet_adnf.set_column(0,0,14.14)
    worksheet_adnf.set_column(1,1,42.43)
    worksheet_adnf.set_column(2,2,26.57)
    worksheet_adnf.set_column(3,3,10.14)
    worksheet_adnf.set_column(4,4,13)
    worksheet_adnf.set_column(5,5,9.14)
    worksheet_adnf.set_column(6,6,12.71)
    worksheet_adnf.set_column(7,7,8.71)
    worksheet_adnf.set_column(8,8,12.43)
    worksheet_adnf.set_column(9,9,12.71)
    worksheet_adnf.set_column(10,10,9.57)
    worksheet_adnf.set_column(11,11,22)
    worksheet_adnf.set_column(12,12,8.57)
    worksheet_adnf.set_column(13,13,12.43)
    worksheet_adnf.set_column(14,14,17.14)
    worksheet_adnf.set_column(15,15,13.57)
    worksheet_adnf.set_column(16,16,45.71)
    worksheet_adlp.set_column(0,0,14.14)
    worksheet_adlp.set_column(1,1,42.43)
    worksheet_adlp.set_column(2,2,26.57)
    worksheet_adlp.set_column(3,3,10.14)
    worksheet_adlp.set_column(4,4,13)
    worksheet_adlp.set_column(5,5,9.14)
    worksheet_adlp.set_column(6,6,12.71)
    worksheet_adlp.set_column(7,7,8.71)
    worksheet_adlp.set_column(8,8,12.43)
    worksheet_adlp.set_column(9,9,12.71)
    worksheet_adlp.set_column(10,10,9.57)
    worksheet_adlp.set_column(11,11,22)
    worksheet_adlp.set_column(12,12,8.57)
    worksheet_adlp.set_column(13,13,12.43)
    worksheet_adlp.set_column(14,14,17.14)
    worksheet_adlp.set_column(15,15,13.57)
    worksheet_adlp.set_column(16,16,45.71)
    worksheet_adunknown.set_column(0,0,14.14)
    worksheet_adunknown.set_column(1,1,42.43)
    worksheet_adunknown.set_column(2,2,26.57)
    worksheet_adunknown.set_column(3,3,10.14)
    worksheet_adunknown.set_column(4,4,13)
    worksheet_adunknown.set_column(5,5,9.14)
    worksheet_adunknown.set_column(6,6,12.71)
    worksheet_adunknown.set_column(7,7,8.71)
    worksheet_adunknown.set_column(8,8,12.43)
    worksheet_adunknown.set_column(9,9,12.71)
    worksheet_adunknown.set_column(10,10,9.57)
    worksheet_adunknown.set_column(11,11,22)
    worksheet_adunknown.set_column(12,12,8.57)
    worksheet_adunknown.set_column(13,13,12.43)
    worksheet_adunknown.set_column(14,14,17.14)
    worksheet_adunknown.set_column(15,15,13.57)
    worksheet_adunknown.set_column(16,16,45.71)
    worksheet_adav.set_column(0,0,14.14)
    worksheet_adav.set_column(1,1,42.43)
    worksheet_adav.set_column(2,2,26.57)
    worksheet_adav.set_column(3,3,10.14)
    worksheet_adav.set_column(4,4,13)
    worksheet_adav.set_column(5,5,9.14)
    worksheet_adav.set_column(6,6,12.71)
    worksheet_adav.set_column(7,7,8.71)
    worksheet_adav.set_column(8,8,12.43)
    worksheet_adav.set_column(9,9,12.71)
    worksheet_adav.set_column(10,10,9.57)
    worksheet_adav.set_column(11,11,22)
    worksheet_adav.set_column(12,12,8.57)
    worksheet_adav.set_column(13,13,12.43)
    worksheet_adav.set_column(14,14,17.14)
    worksheet_adav.set_column(15,15,13.57)
    worksheet_adav.set_column(16,16,45.71)
    worksheet_j.set_column(0,0,14.14)
    worksheet_j.set_column(1,1,42.43)
    worksheet_j.set_column(2,2,26.57)
    worksheet_j.set_column(3,3,10.14)
    worksheet_j.set_column(4,4,13)
    worksheet_j.set_column(5,5,9.14)
    worksheet_j.set_column(6,6,12.71)
    worksheet_j.set_column(7,7,8.71)
    worksheet_j.set_column(8,8,12.43)
    worksheet_j.set_column(9,9,12.71)
    worksheet_j.set_column(10,10,9.57)
    worksheet_j.set_column(11,11,22)
    worksheet_j.set_column(12,12,8.57)
    worksheet_j.set_column(13,13,12.43)
    worksheet_j.set_column(14,14,17.14)
    worksheet_j.set_column(15,15,13.57)
    worksheet_j.set_column(16,16,45.71)
    worksheet_ya.set_column(0,0,14.14)
    worksheet_ya.set_column(1,1,42.43)
    worksheet_ya.set_column(2,2,26.57)
    worksheet_ya.set_column(3,3,10.14)
    worksheet_ya.set_column(4,4,13)
    worksheet_ya.set_column(5,5,9.14)
    worksheet_ya.set_column(6,6,12.71)
    worksheet_ya.set_column(7,7,8.71)
    worksheet_ya.set_column(8,8,12.43)
    worksheet_ya.set_column(9,9,12.71)
    worksheet_ya.set_column(10,10,9.57)
    worksheet_ya.set_column(11,11,22)
    worksheet_ya.set_column(12,12,8.57)
    worksheet_ya.set_column(13,13,12.43)
    worksheet_ya.set_column(14,14,17.14)
    worksheet_ya.set_column(15,15,13.57)
    worksheet_ya.set_column(16,16,45.71)
    worksheet_other.set_column(0,0,14.14)
    worksheet_other.set_column(1,1,42.43)
    worksheet_other.set_column(2,2,26.57)
    worksheet_other.set_column(3,3,10.14)
    worksheet_other.set_column(4,4,13)
    worksheet_other.set_column(5,5,9.14)
    worksheet_other.set_column(6,6,12.71)
    worksheet_other.set_column(7,7,8.71)
    worksheet_other.set_column(8,8,12.43)
    worksheet_other.set_column(9,9,12.71)
    worksheet_other.set_column(10,10,9.57)
    worksheet_other.set_column(11,11,22)
    worksheet_other.set_column(12,12,8.57)
    worksheet_other.set_column(13,13,12.43)
    worksheet_other.set_column(14,14,17.14)
    worksheet_other.set_column(15,15,13.57)
    worksheet_other.set_column(16,16,45.71)

    #Inserting a header
    worksheet_adf.set_header('Purchase Alert')

    # Adding column labels
    worksheet_adf.write(0,0,'Record_number', eformatlabel)
    worksheet_adf.write(0,1,'Title', eformatlabel)
    worksheet_adf.write(0,2,'Author', eformatlabel)
    worksheet_adf.write(0,3,'PublicationYear', eformatlabel)
    worksheet_adf.write(0,4,'MatType', eformatlabel)
    worksheet_adf.write(0,5,'TotalItemCount', eformatlabel)
    worksheet_adf.write(0,6,'TotalAvailableItemCount', eformatlabel)
    worksheet_adf.write(0,7,'TotalHoldCount', eformatlabel)
    worksheet_adf.write(0,8,'TotalDemandRatio', eformatlabel)
    worksheet_adf.write(0,9,'LocalAvailableItemCount', eformatlabel)
    worksheet_adf.write(0,10,'LocalOrderCopies', eformatlabel)
    worksheet_adf.write(0,11,'LocalCopiesInProcess', eformatlabel)
    worksheet_adf.write(0,12,'LocalHoldCount', eformatlabel)
    worksheet_adf.write(0,13,'LocalDemandRatio', eformatlabel)
    worksheet_adf.write(0,14,'SuggestedPurchaseQty (3)', eformatlabel)
    worksheet_adf.write(0,15,'OrderLocations', eformatlabel)
    worksheet_adf.write(0,16,'IsbnUPC', eformatlabel)
    worksheet_adnf.write(0,0,'Record_number', eformatlabel)
    worksheet_adnf.write(0,1,'Title', eformatlabel)
    worksheet_adnf.write(0,2,'Author', eformatlabel)
    worksheet_adnf.write(0,3,'PublicationYear', eformatlabel)
    worksheet_adnf.write(0,4,'MatType', eformatlabel)
    worksheet_adnf.write(0,5,'TotalItemCount', eformatlabel)
    worksheet_adnf.write(0,6,'TotalAvailableItemCount', eformatlabel)
    worksheet_adnf.write(0,7,'TotalHoldCount', eformatlabel)
    worksheet_adnf.write(0,8,'TotalDemandRatio', eformatlabel)
    worksheet_adnf.write(0,9,'LocalAvailableItemCount', eformatlabel)
    worksheet_adnf.write(0,10,'LocalOrderCopies', eformatlabel)
    worksheet_adnf.write(0,11,'LocalCopiesInProcess', eformatlabel)
    worksheet_adnf.write(0,12,'LocalHoldCount', eformatlabel)
    worksheet_adnf.write(0,13,'LocalDemandRatio', eformatlabel)
    worksheet_adnf.write(0,14,'SuggestedPurchaseQty (3)', eformatlabel)
    worksheet_adnf.write(0,15,'OrderLocations', eformatlabel)
    worksheet_adnf.write(0,16,'IsbnUPC', eformatlabel)
    worksheet_adlp.write(0,0,'Record_number', eformatlabel)
    worksheet_adlp.write(0,1,'Title', eformatlabel)
    worksheet_adlp.write(0,2,'Author', eformatlabel)
    worksheet_adlp.write(0,3,'PublicationYear', eformatlabel)
    worksheet_adlp.write(0,4,'MatType', eformatlabel)
    worksheet_adlp.write(0,5,'TotalItemCount', eformatlabel)
    worksheet_adlp.write(0,6,'TotalAvailableItemCount', eformatlabel)
    worksheet_adlp.write(0,7,'TotalHoldCount', eformatlabel)
    worksheet_adlp.write(0,8,'TotalDemandRatio', eformatlabel)
    worksheet_adlp.write(0,9,'LocalAvailableItemCount', eformatlabel)
    worksheet_adlp.write(0,10,'LocalOrderCopies', eformatlabel)
    worksheet_adlp.write(0,11,'LocalCopiesInProcess', eformatlabel)
    worksheet_adlp.write(0,12,'LocalHoldCount', eformatlabel)
    worksheet_adlp.write(0,13,'LocalDemandRatio', eformatlabel)
    worksheet_adlp.write(0,14,'SuggestedPurchaseQty (3)', eformatlabel)
    worksheet_adlp.write(0,15,'OrderLocations', eformatlabel)
    worksheet_adlp.write(0,16,'IsbnUPC', eformatlabel)
    worksheet_adunknown.write(0,0,'Record_number', eformatlabel)
    worksheet_adunknown.write(0,1,'Title', eformatlabel)
    worksheet_adunknown.write(0,2,'Author', eformatlabel)
    worksheet_adunknown.write(0,3,'PublicationYear', eformatlabel)
    worksheet_adunknown.write(0,4,'MatType', eformatlabel)
    worksheet_adunknown.write(0,5,'TotalItemCount', eformatlabel)
    worksheet_adunknown.write(0,6,'TotalAvailableItemCount', eformatlabel)
    worksheet_adunknown.write(0,7,'TotalHoldCount', eformatlabel)
    worksheet_adunknown.write(0,8,'TotalDemandRatio', eformatlabel)
    worksheet_adunknown.write(0,9,'LocalAvailableItemCount', eformatlabel)
    worksheet_adunknown.write(0,10,'LocalOrderCopies', eformatlabel)
    worksheet_adunknown.write(0,11,'LocalCopiesInProcess', eformatlabel)
    worksheet_adunknown.write(0,12,'LocalHoldCount', eformatlabel)
    worksheet_adunknown.write(0,13,'LocalDemandRatio', eformatlabel)
    worksheet_adunknown.write(0,14,'SuggestedPurchaseQty (3)', eformatlabel)
    worksheet_adunknown.write(0,15,'OrderLocations', eformatlabel)
    worksheet_adunknown.write(0,16,'IsbnUPC', eformatlabel)
    worksheet_adav.write(0,0,'Record_number', eformatlabel)
    worksheet_adav.write(0,1,'Title', eformatlabel)
    worksheet_adav.write(0,2,'Author', eformatlabel)
    worksheet_adav.write(0,3,'PublicationYear', eformatlabel)
    worksheet_adav.write(0,4,'MatType', eformatlabel)
    worksheet_adav.write(0,5,'TotalItemCount', eformatlabel)
    worksheet_adav.write(0,6,'TotalAvailableItemCount', eformatlabel)
    worksheet_adav.write(0,7,'TotalHoldCount', eformatlabel)
    worksheet_adav.write(0,8,'TotalDemandRatio', eformatlabel)
    worksheet_adav.write(0,9,'LocalAvailableItemCount', eformatlabel)
    worksheet_adav.write(0,10,'LocalOrderCopies', eformatlabel)
    worksheet_adav.write(0,11,'LocalCopiesInProcess', eformatlabel)
    worksheet_adav.write(0,12,'LocalHoldCount', eformatlabel)
    worksheet_adav.write(0,13,'LocalDemandRatio', eformatlabel)
    worksheet_adav.write(0,14,'SuggestedPurchaseQty (3)', eformatlabel)
    worksheet_adav.write(0,15,'OrderLocations', eformatlabel)
    worksheet_adav.write(0,16,'IsbnUPC', eformatlabel)
    worksheet_j.write(0,0,'Record_number', eformatlabel)
    worksheet_j.write(0,1,'Title', eformatlabel)
    worksheet_j.write(0,2,'Author', eformatlabel)
    worksheet_j.write(0,3,'PublicationYear', eformatlabel)
    worksheet_j.write(0,4,'MatType', eformatlabel)
    worksheet_j.write(0,5,'TotalItemCount', eformatlabel)
    worksheet_j.write(0,6,'TotalAvailableItemCount', eformatlabel)
    worksheet_j.write(0,7,'TotalHoldCount', eformatlabel)
    worksheet_j.write(0,8,'TotalDemandRatio', eformatlabel)
    worksheet_j.write(0,9,'LocalAvailableItemCount', eformatlabel)
    worksheet_j.write(0,10,'LocalOrderCopies', eformatlabel)
    worksheet_j.write(0,11,'LocalCopiesInProcess', eformatlabel)
    worksheet_j.write(0,12,'LocalHoldCount', eformatlabel)
    worksheet_j.write(0,13,'LocalDemandRatio', eformatlabel)
    worksheet_j.write(0,14,'SuggestedPurchaseQty (3)', eformatlabel)
    worksheet_j.write(0,15,'OrderLocations', eformatlabel)
    worksheet_j.write(0,16,'IsbnUPC', eformatlabel)
    worksheet_ya.write(0,0,'Record_number', eformatlabel)
    worksheet_ya.write(0,1,'Title', eformatlabel)
    worksheet_ya.write(0,2,'Author', eformatlabel)
    worksheet_ya.write(0,3,'PublicationYear', eformatlabel)
    worksheet_ya.write(0,4,'MatType', eformatlabel)
    worksheet_ya.write(0,5,'TotalItemCount', eformatlabel)
    worksheet_ya.write(0,6,'TotalAvailableItemCount', eformatlabel)
    worksheet_ya.write(0,7,'TotalHoldCount', eformatlabel)
    worksheet_ya.write(0,8,'TotalDemandRatio', eformatlabel)
    worksheet_ya.write(0,9,'LocalAvailableItemCount', eformatlabel)
    worksheet_ya.write(0,10,'LocalOrderCopies', eformatlabel)
    worksheet_ya.write(0,11,'LocalCopiesInProcess', eformatlabel)
    worksheet_ya.write(0,12,'LocalHoldCount', eformatlabel)
    worksheet_ya.write(0,13,'LocalDemandRatio', eformatlabel)
    worksheet_ya.write(0,14,'SuggestedPurchaseQty (3)', eformatlabel)
    worksheet_ya.write(0,15,'OrderLocations', eformatlabel)
    worksheet_ya.write(0,16,'IsbnUPC', eformatlabel)
    worksheet_other.write(0,0,'Record_number', eformatlabel)
    worksheet_other.write(0,1,'Title', eformatlabel)
    worksheet_other.write(0,2,'Author', eformatlabel)
    worksheet_other.write(0,3,'PublicationYear', eformatlabel)
    worksheet_other.write(0,4,'MatType', eformatlabel)
    worksheet_other.write(0,5,'TotalItemCount', eformatlabel)
    worksheet_other.write(0,6,'TotalAvailableItemCount', eformatlabel)
    worksheet_other.write(0,7,'TotalHoldCount', eformatlabel)
    worksheet_other.write(0,8,'TotalDemandRatio', eformatlabel)
    worksheet_other.write(0,9,'LocalAvailableItemCount', eformatlabel)
    worksheet_other.write(0,10,'LocalOrderCopies', eformatlabel)
    worksheet_other.write(0,11,'LocalCopiesInProcess', eformatlabel)
    worksheet_other.write(0,12,'LocalHoldCount', eformatlabel)
    worksheet_other.write(0,13,'LocalDemandRatio', eformatlabel)
    worksheet_other.write(0,14,'SuggestedPurchaseQty (3)', eformatlabel)
    worksheet_other.write(0,15,'OrderLocations', eformatlabel)
    worksheet_other.write(0,16,'IsbnUPC', eformatlabel)

    row_adf = 1
    row_adnf = 1
    row_adlp = 1
    row_adunknown = 1
    row_adav = 1
    row_j = 1
    row_ya = 1
    row_other = 1
    # suggested_purchase_formula = '=IF(M2/(VALUE(MID($O$1,SEARCH("(",$O$1)+1,SEARCH(")",$O$1)-SEARCH("(",$O$1)-1)+0))-J2-K2-L2<0,0,ROUND(M2/(VALUE(MID($O$1,SEARCH("(",$O$1)+1,SEARCH(")",$O$1)-SEARCH("(",$O$1)-1)+0))-J2-K2-L2,1))'
    suggested_purchase_formula = '=if(M{}/(VALUE(MID($O$1,SEARCH("(",$O$1)+1,SEARCH(")",$O$1)-SEARCH("(",$O$1)-1)+0))-J{}-K{}-L{}<0,0,round(M{}/(VALUE(MID($O$1,SEARCH("(",$O$1)+1,SEARCH(")",$O$1)-SEARCH("(",$O$1)-1)+0))-J{}-K{}-L{},1))'

    # Writing the report for staff to the Excel worksheet
    for rownum, row in enumerate(query_results):
        if row[4] == 'LARGE PRINT':
            worksheet_adlp.write(row_adlp,0,row[0], eformat)
            worksheet_adlp.write_url(row_adlp,1,row[13], link_format, row[1])
            worksheet_adlp.write(row_adlp,2,row[2], eformat)
            worksheet_adlp.write(row_adlp,3,row[3], eformat)
            worksheet_adlp.write(row_adlp,4,row[4], eformat)
            worksheet_adlp.write(row_adlp,5,row[5], eformat)
            worksheet_adlp.write(row_adlp,6,row[6], eformat)
            worksheet_adlp.write(row_adlp,7,row[7], eformat)
            worksheet_adlp.write(row_adlp,8,row[8], eformat)
            worksheet_adlp.write(row_adlp,9,row[9], eformat)
            worksheet_adlp.write(row_adlp,10,row[10], eformat)
            worksheet_adlp.write(row_adlp,11,row[18], eformat)
            worksheet_adlp.write(row_adlp,12,row[11], eformat)
            worksheet_adlp.write(row_adlp,13,row[12], eformat)
            worksheet_adlp.write(row_adlp,14,suggested_purchase_formula.format(row_adlp+1,row_adlp+1,row_adlp+1,row_adlp+1,row_adlp+1,row_adlp+1,row_adlp+1,row_adlp+1), eformat)
            worksheet_adlp.write(row_adlp,15,row[14], eformat)
            worksheet_adlp.write(row_adlp,16,row[15], eformat)
            row_adlp += 1
        elif row[16] == 'ADULT' and row[17] == 'TRUE' and row[4] == 'BOOK':
            worksheet_adf.write(row_adf,0,row[0], eformat)
            worksheet_adf.write_url(row_adf,1,row[13], link_format, row[1])
            worksheet_adf.write(row_adf,2,row[2], eformat)
            worksheet_adf.write(row_adf,3,row[3], eformat)
            worksheet_adf.write(row_adf,4,row[4], eformat)
            worksheet_adf.write(row_adf,5,row[5], eformat)
            worksheet_adf.write(row_adf,6,row[6], eformat)
            worksheet_adf.write(row_adf,7,row[7], eformat)
            worksheet_adf.write(row_adf,8,row[8], eformat)
            worksheet_adf.write(row_adf,9,row[9], eformat)
            worksheet_adf.write(row_adf,10,row[10], eformat)
            worksheet_adf.write(row_adf,11,row[18], eformat)
            worksheet_adf.write(row_adf,12,row[11], eformat)
            worksheet_adf.write(row_adf,13,row[12], eformat)
            worksheet_adf.write(row_adf,14,suggested_purchase_formula.format(row_adf+1,row_adf+1,row_adf+1,row_adf+1,row_adf+1,row_adf+1,row_adf+1,row_adf+1), eformat)
            worksheet_adf.write(row_adf,15,row[14], eformat)
            worksheet_adf.write(row_adf,16,row[15], eformat)
            row_adf += 1
        elif row[16] == 'ADULT' and row[17] == 'FALSE' and row[4] in ['BOOK','MUSIC SCORE']:
            worksheet_adnf.write(row_adnf,0,row[0], eformat)
            worksheet_adnf.write_url(row_adnf,1,row[13], link_format, row[1])
            worksheet_adnf.write(row_adnf,2,row[2], eformat)
            worksheet_adnf.write(row_adnf,3,row[3], eformat)
            worksheet_adnf.write(row_adnf,4,row[4], eformat)
            worksheet_adnf.write(row_adnf,5,row[5], eformat)
            worksheet_adnf.write(row_adnf,6,row[6], eformat)
            worksheet_adnf.write(row_adnf,7,row[7], eformat)
            worksheet_adnf.write(row_adnf,8,row[8], eformat)
            worksheet_adnf.write(row_adnf,9,row[9], eformat)
            worksheet_adnf.write(row_adnf,10,row[10], eformat)
            worksheet_adnf.write(row_adnf,11,row[18], eformat)            
            worksheet_adnf.write(row_adnf,12,row[11], eformat)
            worksheet_adnf.write(row_adnf,13,row[12], eformat)
            worksheet_adnf.write(row_adnf,14,suggested_purchase_formula.format(row_adnf+1,row_adnf+1,row_adnf+1,row_adnf+1,row_adnf+1,row_adnf+1,row_adnf+1,row_adnf+1), eformat)
            worksheet_adnf.write(row_adnf,15,row[14], eformat)
            worksheet_adnf.write(row_adnf,16,row[15], eformat)
            row_adnf += 1
        elif row[16] == 'ADULT' and row[17] == 'UNKNOWN' and row[4] in ['BOOK','MUSIC SCORE']:
            worksheet_adunknown.write(row_adunknown,0,row[0], eformat)
            worksheet_adunknown.write_url(row_adunknown,1,row[13], link_format, row[1])
            worksheet_adunknown.write(row_adunknown,2,row[2], eformat)
            worksheet_adunknown.write(row_adunknown,3,row[3], eformat)
            worksheet_adunknown.write(row_adunknown,4,row[4], eformat)
            worksheet_adunknown.write(row_adunknown,5,row[5], eformat)
            worksheet_adunknown.write(row_adunknown,6,row[6], eformat)
            worksheet_adunknown.write(row_adunknown,7,row[7], eformat)
            worksheet_adunknown.write(row_adunknown,8,row[8], eformat)
            worksheet_adunknown.write(row_adunknown,9,row[9], eformat)
            worksheet_adunknown.write(row_adunknown,10,row[10], eformat)
            worksheet_adunknown.write(row_adunknown,11,row[18], eformat)
            worksheet_adunknown.write(row_adunknown,12,row[11], eformat)
            worksheet_adunknown.write(row_adunknown,13,row[12], eformat)
            worksheet_adunknown.write(row_adunknown,14,suggested_purchase_formula.format(row_adunknown+1,row_adunknown+1,row_adunknown+1,row_adunknown+1,row_adunknown+1,row_adunknown+1,row_adunknown+1,row_adunknown+1), eformat)
            worksheet_adunknown.write(row_adunknown,15,row[14], eformat)
            worksheet_adunknown.write(row_adunknown,16,row[15], eformat)
            row_adunknown += 1
        elif row[16] == 'JUV':
            worksheet_j.write(row_j,0,row[0], eformat)
            worksheet_j.write_url(row_j,1,row[13], link_format, row[1])
            worksheet_j.write(row_j,2,row[2], eformat)
            worksheet_j.write(row_j,3,row[3], eformat)
            worksheet_j.write(row_j,4,row[4], eformat)
            worksheet_j.write(row_j,5,row[5], eformat)
            worksheet_j.write(row_j,6,row[6], eformat)
            worksheet_j.write(row_j,7,row[7], eformat)
            worksheet_j.write(row_j,8,row[8], eformat)
            worksheet_j.write(row_j,9,row[9], eformat)
            worksheet_j.write(row_j,10,row[10], eformat)
            worksheet_j.write(row_j,11,row[18], eformat)
            worksheet_j.write(row_j,12,row[11], eformat)
            worksheet_j.write(row_j,13,row[12], eformat)
            worksheet_j.write(row_j,14,suggested_purchase_formula.format(row_j+1,row_j+1,row_j+1,row_j+1,row_j+1,row_j+1,row_j+1,row_j+1), eformat)
            worksheet_j.write(row_j,15,row[14], eformat)
            worksheet_j.write(row_j,16,row[15], eformat)
            row_j += 1
        elif row[16] == 'YA':
            worksheet_ya.write(row_ya,0,row[0], eformat)
            worksheet_ya.write_url(row_ya,1,row[13], link_format, row[1])
            worksheet_ya.write(row_ya,2,row[2], eformat)
            worksheet_ya.write(row_ya,3,row[3], eformat)
            worksheet_ya.write(row_ya,4,row[4], eformat)
            worksheet_ya.write(row_ya,5,row[5], eformat)
            worksheet_ya.write(row_ya,6,row[6], eformat)
            worksheet_ya.write(row_ya,7,row[7], eformat)
            worksheet_ya.write(row_ya,8,row[8], eformat)
            worksheet_ya.write(row_ya,9,row[9], eformat)
            worksheet_ya.write(row_ya,10,row[10], eformat)
            worksheet_ya.write(row_ya,11,row[18], eformat)
            worksheet_ya.write(row_ya,12,row[11], eformat)
            worksheet_ya.write(row_ya,13,row[12], eformat)
            worksheet_ya.write(row_ya,14,suggested_purchase_formula.format(row_ya+1,row_ya+1,row_ya+1,row_ya+1,row_ya+1,row_ya+1,row_ya+1,row_ya+1), eformat)
            worksheet_ya.write(row_ya,15,row[14], eformat)
            worksheet_ya.write(row_ya,16,row[15], eformat)
            row_ya += 1
        elif row[4] == '3-D OBJECT' or row[4] == 'BLU-RAY' or row[4] == 'CONSOLE GAME' or row[4] == 'DVD OR VCD' or row[4] == 'MUSIC CD' or row[4] == 'PLAYAWAY AUDIOBOOK' or row[4] == 'SPOKEN CD':
            worksheet_adav.write(row_adav,0,row[0], eformat)
            worksheet_adav.write_url(row_adav,1,row[13], link_format, row[1])
            worksheet_adav.write(row_adav,2,row[2], eformat)
            worksheet_adav.write(row_adav,3,row[3], eformat)
            worksheet_adav.write(row_adav,4,row[4], eformat)
            worksheet_adav.write(row_adav,5,row[5], eformat)
            worksheet_adav.write(row_adav,6,row[6], eformat)
            worksheet_adav.write(row_adav,7,row[7], eformat)
            worksheet_adav.write(row_adav,8,row[8], eformat)
            worksheet_adav.write(row_adav,9,row[9], eformat)
            worksheet_adav.write(row_adav,10,row[10], eformat)
            worksheet_adav.write(row_adav,11,row[18], eformat)
            worksheet_adav.write(row_adav,12,row[11], eformat)
            worksheet_adav.write(row_adav,13,row[12], eformat)
            worksheet_adav.write(row_adav,14,suggested_purchase_formula.format(row_adav+1,row_adav+1,row_adav+1,row_adav+1,row_adav+1,row_adav+1,row_adav+1,row_adav+1), eformat)
            worksheet_adav.write(row_adav,15,row[14], eformat)
            worksheet_adav.write(row_adav,16,row[15], eformat)
            row_adav += 1
        else:
            worksheet_other.write(row_other,0,row[0], eformat)
            worksheet_other.write_url(row_other,1,row[13], link_format, row[1])
            worksheet_other.write(row_other,2,row[2], eformat)
            worksheet_other.write(row_other,3,row[3], eformat)
            worksheet_other.write(row_other,4,row[4], eformat)
            worksheet_other.write(row_other,5,row[5], eformat)
            worksheet_other.write(row_other,6,row[6], eformat)
            worksheet_other.write(row_other,7,row[7], eformat)
            worksheet_other.write(row_other,8,row[8], eformat)
            worksheet_other.write(row_other,9,row[9], eformat)
            worksheet_other.write(row_other,10,row[10], eformat)
            worksheet_other.write(row_other,11,row[18], eformat)
            worksheet_other.write(row_other,12,row[11], eformat)
            worksheet_other.write(row_other,13,row[12], eformat)
            worksheet_other.write(row_other,14,suggested_purchase_formula.format(row_other+1,row_other+1,row_other+1,row_other+1,row_other+1,row_other+1,row_other+1,row_other+1), eformat)
            worksheet_other.write(row_other,15,row[14], eformat)
            worksheet_other.write(row_other,16,row[15], eformat)
            row_other += 1
    
    workbook.close()
    
    return excelfile

#connect to Sierra-db and store results of an sql query
def runquery(library_code,acq_unit):

    # import configuration file containing our connection string
    # app.ini looks like the following
    #[db]
    #connection_string = dbname='iii' user='PUT_USERNAME_HERE' host='sierra-db.library-name.org' password='PUT_PASSWORD_HERE' port=1032

    query = """\
    WITH orders AS (
      SELECT
        COUNT(oc.order_record_id) FILTER(WHERE o.order_status_code = 'o') AS order_count,
        SUM(oc.copies) FILTER (WHERE o.order_status_code = 'o') AS order_copies,
        SUM(oc.copies) FILTER(WHERE o.order_status_code = 'a' AND o.received_date_gmt::DATE >= CURRENT_DATE - INTERVAL '14 days') AS processing_copies,
        STRING_AGG(DISTINCT(oc.location_code), ',') AS order_locations,
        bro.bib_record_id AS bib_id
        
    	FROM sierra_view.order_record o
    	JOIN sierra_view.order_record_cmf oc
    	  ON o.id = oc.order_record_id
    	JOIN sierra_view.bib_record_order_record_link bro
    	  ON o.id=bro.order_record_id
        
    	WHERE o.order_status_code IN ('o','a')
    	  AND o.accounting_unit_code_num = '""" + acq_unit +"""'
    	  AND oc.location_code ~ '^""" + library_code +"""'	
    	  --location will take the form ^oln, which in this example looks for all locations starting with the string oln.
       GROUP BY bro.bib_record_id
    ),

    hold_data AS(
    SELECT 
    	b.id AS bib_id, 
    	COUNT(DISTINCT h.id) AS hold_count,
    	o.order_locations AS order_locations,
    	COUNT(DISTINCT h.id) FILTER(WHERE h.pickup_location_code ~ '^""" + library_code +"""') AS local_holds,
    	COUNT(DISTINCT i.id) AS item_count,
    	COUNT(DISTINCT ia.id) AS avail_item_count, 
    	COUNT(DISTINCT ia.id) FILTER(WHERE ia.location_code ~ '^""" + library_code +"""' AND rmia.creation_date_gmt::DATE >= CURRENT_DATE - INTERVAL '14 days') AS in_process_item_count,
    	COUNT(DISTINCT ia.id) FILTER(WHERE ia.location_code ~ '^""" + library_code +"""') AS local_avail_item_count,
    	MAX(o.order_count) AS order_count,
    	CASE
          WHEN MAX(o.order_copies) IS NULL THEN 0
          ELSE MAX(o.order_copies)
       END AS order_copies,
       CASE
        	WHEN MAX(o.processing_copies) IS NULL THEN 0
        	ELSE MAX(o.processing_copies)
       END AS processing_copies,
    	MODE() WITHIN GROUP (ORDER BY SUBSTRING(i.location_code,4,1)) AS age_level

    FROM sierra_view.bib_record b
    LEFT JOIN sierra_view.bib_record_item_record_link bri
    	ON b.id = bri.bib_record_id
    LEFT JOIN sierra_view.hold h
    	ON (h.record_id=b.id OR h.record_id=bri.item_record_id)
    LEFT JOIN sierra_view.item_record i
    	ON bri.item_record_id = i.id
    LEFT JOIN sierra_view.item_record ia
    	ON ia.id=bri.item_record_id
    	AND ia.item_status_code IN ('-','t','p','!','u')
    	AND (
    	  (ia.location_code !~ '^""" + library_code +"""' AND ia.itype_code_num NOT IN ('5','21','109','133','160','183','239','240','241','244','248','249'))
    	  OR ia.location_code ~ '^""" + library_code +"""'
    	  )
    LEFT JOIN sierra_view.record_metadata rmia
		ON ia.id = rmia.id
    LEFT JOIN orders o
    	ON b.id = o.bib_id

    WHERE h.status='0'

    GROUP BY 1, 3
    HAVING COUNT(DISTINCT h.id)>0
    )

    /* This is the report that shows useful things. */
    SELECT * FROM (
    SELECT
    	id2reckey(hd.bib_id)||'a' AS RecordNumber,
    	brp.best_title AS Title, 
    	brp.best_author AS Author, 
    	brp.publish_year AS PublicationYear,
    	bc.name AS MatType,
    	hd.item_count AS TotalItemCount, 
    	MAX(hd.avail_item_count) AS AvailableItemCount,
    	hd.hold_count AS TotalHoldCount,
    	CASE
          WHEN MAX(hd.avail_item_count) + MAX(hd.order_copies)=0 THEN hd.hold_count
          ELSE ROUND(CAST((hd.hold_count) AS NUMERIC (12, 2))/CAST((MAX(hd.avail_item_count) + MAX(hd.order_copies)) AS NUMERIC(12,2)),2)
       END AS TotalRatio,
    	MAX(hd.local_avail_item_count) AS LocalAvailableItemCount,
    	MAX(hd.order_copies) AS LocalOrderCopies,
    	hd.local_holds AS LocalHoldCount,
       CASE
           WHEN MAX(hd.local_avail_item_count) + MAX(hd.order_copies)=0 THEN hd.local_holds
           ELSE ROUND(CAST((hd.local_holds) AS NUMERIC (12, 2))/CAST((MAX(hd.local_avail_item_count) + MAX(hd.order_copies)) AS NUMERIC(12,2)),2)
       END AS LocalRatio,
	    'https://catalog.minlib.net/Record/'||id2reckey(hd.bib_id) AS URL,
    	hd.order_locations AS OrderLocations,
       (SELECT
		  COALESCE(STRING_AGG(REGEXP_REPLACE(REPLACE(REGEXP_REPLACE(v.field_content,'(\|a|:)','','g'),'|q',' '),'(\|c|\|2|\|d).*?(\||$)',''),', '),'') AS isbns
		
		FROM sierra_view.varfield v
		
		WHERE brp.bib_record_id = v.record_id
		  AND v.marc_tag IN ('020','024')
	   )AS isbns,
	   CASE
		  WHEN hd.age_level = 'j' THEN 'JUV'
		  WHEN hd.age_level = 'y' THEN 'YA'
		  WHEN hd.age_level IS NULL THEN 'UNKNOWN'
		  ELSE 'ADULT'
	   END AS age_level,
	   MODE() WITHIN GROUP (ORDER BY CASE
		 WHEN d.index_entry ~ '((\yfiction)|(pictorial works)|(tales)|(^\y(?!\w*biography)\w*(comic books strips etc))|(^\y(?!\w*biography)\w*(graphic novels))|(\ydrama)|((?<!hi)stories))(( [a-z]+)?)(( translations into [a-z]+)?)$'
			AND brp.material_code NOT IN ('7','8','b','e','j','k','m','n')
			AND NOT (ml.bib_level_code = 'm'
			AND ml.record_type_code = 'a'
			AND f.p33 IN ('0','e','i','p','s','','c')) THEN 'TRUE'
		 WHEN d.index_entry IS NULL THEN 'UNKNOWN'
		 ELSE 'FALSE'
	   END) AS is_fiction,
	   CASE
			WHEN MAX(hd.processing_copies) > 0 AND MAX(hd.in_process_item_count) < MAX(hd.processing_copies) THEN MAX(hd.processing_copies) - MAX(hd.in_process_item_count)
			ELSE 0
	   END AS LocalCopiesInProcess	

    FROM hold_data hd
    JOIN sierra_view.bib_record_property brp
    	ON hd.bib_id = brp.bib_record_id
    JOIN sierra_view.user_defined_bcode2_myuser bc
    	ON brp.material_code = bc.code
    LEFT JOIN sierra_view.phrase_entry d
    	ON hd.bib_id = d.record_id AND d.index_tag = 'd' AND d.is_permuted = FALSE
    LEFT JOIN sierra_view.leader_field ml
    	ON hd.bib_id = ml.record_id
    LEFT JOIN sierra_view.control_field f
    	ON hd.bib_id = f.record_id

    GROUP BY 1, 2, 3, 4, 5, 6, 8, 12, 14, 15, 16, 17
    HAVING hd.local_holds > 0
    )a

    ORDER BY 5, 
	CASE
		WHEN CAST(a.LocalHoldCount AS NUMERIC(12, 2))/3.0 - a.LocalAvailableItemCount - a.LocalOrderCopies - a.LocalCopiesInProcess < 0 THEN 0
		ELSE CAST(a.LocalHoldCount AS NUMERIC(12, 2))/3.0 - a.LocalAvailableItemCount - a.LocalOrderCopies - a.LocalCopiesInProcess
	END DESC,
	a.LocalRatio DESC
    """
    
    config = configparser.ConfigParser()
    config.read('app_SIC.ini')
      
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

#upload report to SIC directory and optionally remove older files
def ftp_file(local_file,library):

    config = configparser.ConfigParser()
    config.read('app_SIC.ini')

    cnopts = pysftp.CnOpts()

    srv = pysftp.Connection(host = config['sic']['sic_host'], username = config['sic']['sic_user'], password= config['sic']['sic_pw'], cnopts=cnopts)

    local_file = local_file

    srv.cwd('/reports/Library-Specific Reports/'+library+'/Purchase Alert/')
    srv.put(local_file)

    #remove old file

    for fname in srv.listdir_attr():
        fullpath = '/reports/Library-Specific Reports/'+library+'/Purchase Alert/{}'.format(fname.filename)
        #time tracked in seconds, st_mtime is time last modified
        name = str(fname.filename)
        if (name != 'meta.json') and  ((time.time() - fname.st_mtime) // (24 * 3600) >= 90):
            srv.remove(fullpath)

    srv.close()
    os.remove(local_file)

def main(library,library_code,acq_unit):
    
    tempFile = runquery(library_code,acq_unit)
    #Name of Excel File
    if library_code == 'co':
        excelfile = 'CONALLPurchaseAlertNew{}.xlsx'.format(date.today())
    else:
        excelfile =  library_code.upper()+'PurchaseAlertNew{}.xlsx'.format(date.today())
    local_file = excelWriter(tempFile,excelfile)
    ftp_file(local_file,library)

main('Acton','act','1')
main('Acton','ac2','1')
main('Arlington','arl','2')
main('Arlington','ar2','2')
main('Ashland','ash','3')
main('Bedford','bed','4')
main('Belmont','blm','5')
main('Brookline','brk','6')
main('Brookline','br2','6')
main('Brookline','br3','6')
main('Cambridge','cam','7')
main('Cambridge','ca3','7')
main('Cambridge','ca4','7')
main('Cambridge','ca5','7')
main('Cambridge','ca6','7')
main('Cambridge','ca7','7')
main('Cambridge','ca8','7')
main('Cambridge','ca9','7')
main('Concord','con','8')
main('Concord','co2','8')
main('Concord','co','8')
main('Dedham','ddm','9')
main('Dedham','dd2','9')
main('Dean','dea','10')
main('Dover','dov','11')
main('Framingham Public','fpl','12')
main('Framingham Public','fp2','12')
main('Framingham State','fst','14')
main('Franklin','frk','13')
main('Holliston','hol','15')
main('Lasell','las','16')
main('Lexington','lex','17')
main('Lincoln','lin','18')
main('Maynard','may','19')
main('Medfield','mld','23')
main('Medford','med','21')
main('Medway','mwy','25')
main('Millis','mil','22')
main('Natick','nat','26')
main('Natick','na2','26')
main('Needham','nee','28')
main('Newton','ntn','30')
main('Norwood','nor','29')
main('Olin','oln','24')
main('Regis','reg','43')
main('Sherborn','shr','27')
main('Somerville','som','31')
main('Somerville','so2','31')
main('Somerville','so3','31')
main('Stow','sto','32')
main('Sudbury','sud','33')
main('Waltham','wlm','37')
main('Watertown','wat','34')
main('Wayland','wyl','41')
main('Wellesley','wel','35')
main('Wellesley','we2','35')
main('Wellesley','we3','35')
main('Weston','wsn','39')
main('Westwood','wwd','40')
main('Westwood','ww2','40')
main('Winchester','win','36')
main('Woburn','wob','38')
