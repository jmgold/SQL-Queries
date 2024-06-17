#!/usr/bin/env python3

#work on sftp

"""
   Create and ftp weekly files to orange Boy
   for Savannah platform used by newton

"""

import psycopg2
import csv
import os
import pysftp
import configparser
import sys
import time
import datetime
from datetime import date

#convert sql query results into formatted excel file
def csvWriter(query_results,csvfile):

    with open(csvfile,'w', encoding='utf-8', newline='') as tempFile:
        myFile = csv.writer(tempFile, delimiter='|')
        myFile.writerows(query_results)
    tempFile.close()
    
    return csvfile

#connect to Sierra-db and store results of an sql query
def runquery(query):

    # import configuration file containing our connection string
    # app.ini looks like the following
    #[db]
    #connection_string = dbname='iii' user='PUT_USERNAME_HERE' host='sierra-db.library-name.org' password='PUT_PASSWORD_HERE' port=1032

    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\app.ini')
      
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

#upload report to SIC directory and optionally remove older files
def ftp_file(local_file):

    username = ''
    host = ''
    #path for private key file .pem
    path = ''
    
    cnopts = pysftp.CnOpts()
    cnopts.hostkeys = None 

    local_file = local_file

    with pysftp.Connection(host, username=username, private_key=path, cnopts=cnopts) as sftp:
        sftp.put(local_file) # target dirctory path is optional
        sftp.close()
    os.remove(local_file)

def main(query):
	
    tempFile = runquery("ntn"+query+".sql")
    #Name of CSV File
    csvfile =  'NEWTON_'+query+'_{}.csv'.format(date.today().strftime('%m-%d-%Y'))
    local_file = csvWriter(tempFile,csvfile)
    ftp_file(local_file)

main('circulation')
main('patron')

