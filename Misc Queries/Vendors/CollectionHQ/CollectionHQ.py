"""
Jeremy Goldstein
Minuteman Library Network

Gather daily collection data for LibraryIQ and FTP results as csv files
"""

import psycopg2
import csv
import configparser
from ftplib import FTP
import os
from datetime import datetime
from datetime import date

#generate populate csv file with results of a sql query
def csvWriter(query_results,headers,csvfile):

    with open(csvfile,'w', encoding='utf-8', newline='') as tempFile:
        myFile = csv.writer(tempFile, delimiter='|')
        myFile.writerow(headers)
        myFile.writerows(query_results)
    tempFile.close()
    
    return csvfile

#connect to Sierra-db and store results of an sql query
def runquery(query,csv_file):

    # import configuration file containing our connection string
    # app.ini looks like the following
    #[db]
    #connection_string = dbname='iii' user='PUT_USERNAME_HERE' host='sierra-db.library-name.org' password='PUT_PASSWORD_HERE' port=1032

    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\collectionhq.ini')
      
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
    headers = [i[0] for i in cursor.description]
    rows = cursor.fetchall()
    conn.close()
    
    end_file = csvWriter(rows, headers, csv_file)
    
    return end_file

def ftp_file(file):
    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\collectionhq.ini')

    ftp = FTP(config['collectionhq']['host'])
    ftp.login(user=config['collectionhq']['user'], passwd = config['collectionhq']['pw'])
    fp = open(file, 'rb')
    ftp.storbinary('STOR %s' % os.path.basename(file), fp)
    fp.close()
    ftp.quit()

def main():
    bibs_query = """\
    SELECT
      rm.record_type_code||rm.record_num AS bib_record_num,
      rm.creation_date_gmt::DATE AS creation_date,
      rm.record_last_updated_gmt::DATE AS record_last_updated,
      STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),',') FILTER(WHERE num.marc_tag = '020') AS isbn,
      STRING_AGG(num.content,',') FILTER(WHERE num.marc_tag = '022') AS issn,
      STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),',') FILTER(WHERE num.marc_tag = '024') AS upc,
      b.best_author AS author,
      b.best_title AS title,
      TRIM(TRAILING ',' FROM pub.content) AS publisher,
      b.publish_year,
      STRING_AGG(sub.index_entry,','ORDER BY sub.occurrence, sub.id) AS subject,
      mp.name AS format
  
    FROM sierra_view.bib_record_property b
    JOIN sierra_view.bib_record_location bl
      ON b.bib_record_id = bl.bib_record_id AND bl.location_code ~ '^na[^2]'
    JOIN sierra_view.record_metadata rm
      ON b.bib_record_id = rm.id
    LEFT JOIN sierra_view.subfield num
      ON b.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'
    LEFT JOIN sierra_view.subfield pub
      ON b.bib_record_id = pub.record_id AND pub.marc_tag IN ('260','264') AND pub.tag = 'b'
    LEFT JOIN sierra_view.phrase_entry sub
      ON b.bib_record_id = sub.record_id AND sub.varfield_type_code = 'd'
    JOIN sierra_view.material_property_myuser mp
      ON b.material_code = mp.code

    GROUP BY 1,2,3,7,8,9,10,12
    """

    items_query = """\
    SELECT
      rmb.record_type_code||rmb.record_num AS bib_record_num,
      rmi.record_type_code||rmi.record_num AS item_record_num,
      rmi.creation_date_gmt::DATE AS creation_date,
      rmi.record_last_updated_gmt::DATE AS record_last_updated,
      ip.barcode,
      i.location_code,
      CASE
        WHEN (i.checkout_statistic_group_code_num BETWEEN '530' AND '539') OR (i.checkout_statistic_group_code_num BETWEEN '551' AND '561') OR i.checkout_statistic_group_code_num = '0' THEN i.checkout_statistic_group_code_num::VARCHAR
        ELSE 'Not Morse Checkout'
      END AS checkout_statistic_group,
      CASE
        WHEN (i.checkin_statistics_group_code_num BETWEEN '530' AND '539') OR (i.checkin_statistics_group_code_num BETWEEN '551' AND '561') OR i.checkin_statistics_group_code_num = '0' THEN i.checkin_statistics_group_code_num::VARCHAR
        ELSE 'Not Morse Checkin'
      END AS checkin_statistic_group,
      o.checkout_gmt::DATE AS checkout_date,
      o.due_gmt::DATE AS due_date,
      CASE
        WHEN o.ptype IN ('26','42','43','126','200','201','202','203','204','205','206','207','326') THEN pt.name 
    	WHEN o.ptype IS NULL THEN NULL
	    ELSE 'Other'
      END AS patron_type,
      i.last_checkout_gmt::DATE AS last_checkout_date,
      i.last_checkin_gmt::DATE AS last_checking_date,
      i.checkout_total,
      i.renewal_total,
      it.name AS item_type,
      CASE
        WHEN o.id IS NOT NULL THEN 'CHECKED OUT'
        ELSE status.name
      END AS status,
      i.price::MONEY AS price,
      ip.call_number,
      STRING_AGG(TRIM(note.field_content), ';') AS notes,
      i.icode1 AS collection_code
 
    FROM sierra_view.item_record i
    JOIN sierra_view.item_record_property ip
      ON i.id = ip.item_record_id AND i.location_code ~ '^na[^2]'
    JOIN sierra_view.bib_record_item_record_link l
      ON i.id = l.item_record_id
    JOIN sierra_view.record_metadata rmb
      ON l.bib_record_id = rmb.id
    JOIN sierra_view.record_metadata rmi
      ON i.id = rmi.id
    LEFT JOIN sierra_view.checkout o
      ON i.id = o.item_record_id
    LEFT JOIN sierra_view.ptype_property_myuser pt
      ON o.ptype = pt.value
    JOIN sierra_view.itype_property_myuser it
      ON i.itype_code_num = it.code
    JOIN sierra_view.item_status_property_myuser status
      ON i.item_status_code = status.code
    LEFT JOIN sierra_view.varfield note
      ON i.id = note.record_id AND note.varfield_type_code = 'x'
  
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,21
    """

    circ_query = """\
    SELECT
      ip.barcode,
      CASE
        WHEN (t.stat_group_code_num BETWEEN '530' AND '539') OR (t.stat_group_code_num BETWEEN '551' AND '561') OR t.stat_group_code_num = '0' THEN t.stat_group_code_num::VARCHAR
        ELSE 'Not Morse Transaction'
      END AS transaction_stat_group,
      CASE
        WHEN t.item_location_code ~ '^na[^2]' THEN t.item_location_code
        WHEN t.item_location_code = '' THEN NULL
        ELSE 'Not Morse Item'
      END AS item_location,
      CASE
        WHEN o.id IS NOT NULL THEN 'CHECKED OUT'
        ELSE status.name
      END AS item_status,
      t.transaction_gmt::DATE AS transaction_date,
      CASE
        WHEN t.op_code = 'o' THEN 'CHECKOUT'
        WHEN t.op_code = 'i' THEN 'CHECKIN'
        WHEN t.op_code = 'f' THEN 'FILLED HOLD'
        WHEN t.op_code = 'r' THEN 'RENEWAL'
        WHEN t.op_code = 'u' THEN 'INTERNAL USE COUNT'
      END AS transaction_type,
      rmi.record_type_code||rmi.record_num AS item_record_num,
      rmb.record_type_code||rmb.record_num AS bib_record_num,
      pt.name AS patron_type
  
    FROM sierra_view.circ_trans t
    LEFT JOIN sierra_view.item_record i
      ON t.item_record_id = i.id AND i.location_code ~ '^na[^2]'
    LEFT JOIN sierra_view.item_record_property ip
      ON i.id = ip.item_record_id
    JOIN sierra_view.statistic_group_myuser sg
      ON t.stat_group_code_num = sg.code AND t.op_code !~ '^(n|h)'
    JOIN sierra_view.ptype_property_myuser pt
      ON t.ptype_code = pt.value::VARCHAR
    LEFT JOIN sierra_view.item_status_property_myuser status
      ON i.item_status_code = status.code
    LEFT JOIN sierra_view.checkout o
      ON i.id = o.item_record_id
    LEFT JOIN sierra_view.record_metadata rmi
      ON t.item_record_id = rmi.id
    LEFT JOIN sierra_view.record_metadata rmb
      ON t.bib_record_id = rmb.id

    WHERE (t.stat_group_code_num BETWEEN '530' AND '539') OR (t.stat_group_code_num BETWEEN '551' AND '561') OR i.location_code ~ '^na[^2]'
        AND t.transaction_gmt::DATE >= CURRENT_DATE - INTERVAL '1 WEEK'
    ORDER BY 5
    """

    #circ file produced weekly
    circ_file = 'Transactions_{}.csv'.format(date.today().strftime('%Y%m%d'))
    circ_csv = runquery(circ_query,circ_file)
    ftp_file(circ_csv)
    #run if first Tuesday of the month
    today = datetime.today()
    if today.weekday() == 1 and today.day <= 7:
        bibs_file = 'Bibs_{}.csv'.format(date.today().strftime('%Y%m%d'))
        items_file = 'Items_{}.csv'.format(date.today().strftime('%Y%m%d'))
        bibs_csv = runquery(bibs_query,bibs_file)
        items_csv = runquery(items_query,items_file)
        #ftp_file(bibs_csv)
        #ftp_file(items_csv)
      
main()
