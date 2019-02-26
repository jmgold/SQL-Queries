#!/usr/bin/env python3

"""Create and email a list of new items

Jeremy Goldstein
Minuteman Library Network

Example for Automating booklist curation with SQL presentation given at IUG2019
"""

import psycopg2
import csv
from datetime import date

#Name of Excel File

csvFile =  'NewBookList.csv'.format(date.today())

#Connecting to Sierra PostgreSQL database
#Add in the credentials for your database
conn = psycopg2.connect("dbname='' user='' host='' port='1032' password='' sslmode='require'")

#Opening a session and querying the database for weekly new items
cursor = conn.cursor()
cursor.execute(open("new books list.sql","r").read())
#For now, just storing the data in a variable. We'll use it later.
rows = cursor.fetchall()
conn.close()

with open(csvFile,'w', encoding='utf-8') as tempFile:
     myFile = csv.writer(tempFile, delimiter='|')
     myFile.writerows(rows)
tempFile.close()
