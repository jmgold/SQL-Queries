#Jeremy Goldstein
#Minuteman Library Network
#Script to automate creation of minimal MARC records to be used for IPage's holdings feature
#For example purposes, this is the iteration used for our Winchester (WIN) library

import psycopg2
import re
import pymarc
import configparser
import os
from ftplib import FTP
from datetime import date

#define a function
def marcwriter(file):

  #remove prior file
  for fname in os.listdir("."):
    if os.path.isfile(fname) and fname.startswith("win_holdings"):
      os.remove(fname)
  
  #create an output file for the created MARC records (wb means 'write binary')  
  outputfile = open('win_holdings{}.mrc'.format(date.today()), 'wb')
  
  #iterate through each row of the file
  for rownum, row in enumerate(file):
    
    #declare PyMARC record object
    item_load = pymarc.Record(to_unicode=True, force_utf8=True)
  
    #define data fields in CSV file
    ocn = row[1]
    isbn = row[2].split('|')
    upc = row[3].split('|')
    
    #Clean up OCLC numbers with regular expression
    ocn = re.sub("[^0-9]", "", ocn)
  
    #write data to field variables   
    field_001 = pymarc.Field(tag='001', data=ocn)
    item_load.add_ordered_field(field_001)
    for i in isbn:
        if i == '':
            break
        field_020 = pymarc.Field(
          tag='020', 
          indicators = [' ',' '],
          subfields = ['a', i]
          )
        item_load.add_ordered_field(field_020)
    
    for j in upc:
        if j == '':
            break
        field_024 = pymarc.Field(
          tag='024', 
          indicators = ['3',' '],
          subfields = ['a', j]
          )
        item_load.add_ordered_field(field_024)
    
    
    #Create output file
    outputfile.write(item_load.as_marc())

  #close the output file
  outputfile.close()


def runquery():
    
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

    #Opening a session and querying the database for weekly new items
    cursor = conn.cursor()
    cursor.execute(open("WIN Ingram MARC maker.sql","r").read())
    #For now, just storing the data in a variable. We'll use it later.
    rows = cursor.fetchall()
    conn.close()

    return rows
    

tempFile = runquery()
marcwriter(tempFile)

ftp = FTP("")
ftp.login(user="", passwd = "")
fp = open('win_holdings{}.mrc'.format(date.today()), 'rb')
ftp.storbinary('STOR %s' % os.path.basename('win_holdings{}.mrc'.format(date.today())), fp)
fp.close()
ftp.quit()

