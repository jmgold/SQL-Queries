"""
Jeremy Goldstein
Minuteman Library Network

Gather daily collection data for LibraryIQ and FTP results as csv files
"""

import psycopg2
import csv
import configparser
import pysftp
import os
from datetime import datetime
from datetime import date

#generate populate csv file with results of a sql query
def csvWriter(query_results,headers,csvfile):

    with open(csvfile,'w', encoding='utf-8', newline='') as tempFile:
        myFile = csv.writer(tempFile, delimiter=',')
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
    config.read('C:\\SQL Reports\\creds\\libraryiq.ini')
      
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

def runlargequery(csv_file):
    offset = 0
    large_items_query = """\
    SELECT
    rmi.record_type_code||rmi.record_num AS "ItemNum",
    ip.barcode,
    rmb.record_type_code||rmb.record_num AS "BibNum",
    STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),';') FILTER(WHERE num.marc_tag = '020') AS isbn,
    STRING_AGG(num.content,';') FILTER(WHERE num.marc_tag = '022') issn,
    STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),';') FILTER(WHERE num.marc_tag = '024') AS upc,
    i.icode1,
    i.itype_code_num AS itype,
    it.name AS "ItypeName",
    mp.name AS "MaterialType",
    SUBSTRING(i.location_code,1,3) AS "BranchId",
    TRIM(LEADING '|a' FROM TRIM(ip.call_number))||COALESCE(' '||v.field_content,'') AS "CallNumber",
    i.location_code,
    loc.name AS location_name,
    TO_CHAR(rmi.creation_date_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CREATED",
    CASE
      WHEN o.id IS NULL THEN isp.name
      WHEN o.id IS NOT NULL AND isp.code != '-' THEN isp.name
      ELSE 'CHECKED OUT'
    END AS status,
    TO_CHAR(i.last_checkout_gmt,'YYYY-MM-DD HH24:MI:SS') AS "LOutDate",
    TO_CHAR(o.checkout_gmt,'YYYY-MM-DD HH24:MI:SS') AS "OutDate",
    TO_CHAR(i.last_checkin_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CheckInDate",
    TO_CHAR(o.due_gmt,'YYYY-MM-DD HH24:MI:SS') AS "DueDate",
    i.year_to_date_checkout_total AS "YTDCIRC",
    i.last_year_to_date_checkout_total AS "LYRCIRC",
    i.checkout_total AS "TOT_CHKOUT",
    i.renewal_total AS "TOT_RENEW"
  
    FROM sierra_view.item_record i
    JOIN sierra_view.record_metadata rmi
      ON i.id = rmi.id
      --Pull full file on Fridays, delta file other days
	     AND rmi.record_last_updated_gmt::DATE <= CURRENT_DATE
	  JOIN sierra_view.item_record_property ip
      ON i.id = ip.item_record_id
    JOIN sierra_view.bib_record_item_record_link l
      ON i.id = l.item_record_id
    JOIN sierra_view.record_metadata rmb
      ON l.bib_record_id = rmb.id
    JOIN sierra_view.bib_record_property bp
      ON l.bib_record_id = bp.bib_record_id
    JOIN sierra_view.itype_property_myuser it
      ON i.itype_code_num = it.code
    JOIN sierra_view.location_myuser loc
      ON i.location_code = loc.code
    JOIN sierra_view.material_property_myuser mp
      ON bp.material_code = mp.code
    JOIN sierra_view.item_status_property_myuser isp
      ON i.item_status_code = isp.code
    LEFT JOIN sierra_view.subfield num
      ON bp.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'
    LEFT JOIN sierra_view.checkout o
      ON i.id = o.item_record_id
    LEFT JOIN sierra_view.varfield v
      ON i.id = v.record_id AND v.varfield_type_code = 'v'

    WHERE SUBSTRING(i.location_code,1,3) NOT IN ('trn','hpl','int','knp','','zzz','cmc')
    GROUP BY 1,2,3,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
    
    LIMIT 250000
    OFFSET {}""".format(offset)

    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\libraryiq.ini')
      
    try:
	    # variable connection string should be defined in the imported config file
        conn = psycopg2.connect( config['db']['connection_string'] )
    except:
        print("unable to connect to the database")
        clear_connection()
        return
        
    #Opening a session and querying the database for weekly new items
    cursor = conn.cursor()
    cursor.execute(large_items_query)
    #For now, just storing the data in a variable. We'll use it later.
    
    headers = [i[0] for i in cursor.description]
    rows = cursor.fetchall()
    end_file = csvWriter(rows, headers, csv_file)
    
    while offset < 6000000:
        offset += 250000
        large_items_query = """\
        SELECT
        rmi.record_type_code||rmi.record_num AS "ItemNum",
        ip.barcode,
        rmb.record_type_code||rmb.record_num AS "BibNum",
        STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),';') FILTER(WHERE num.marc_tag = '020') AS isbn,
        STRING_AGG(num.content,';') FILTER(WHERE num.marc_tag = '022') issn,
        STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),';') FILTER(WHERE num.marc_tag = '024') AS upc,
        i.icode1,
        i.itype_code_num AS itype,
        it.name AS "ItypeName",
        mp.name AS "MaterialType",
        SUBSTRING(i.location_code,1,3) AS "BranchId",
        TRIM(LEADING '|a' FROM TRIM(ip.call_number))||COALESCE(' '||v.field_content,'') AS "CallNumber",
        i.location_code,
        loc.name AS location_name,
        TO_CHAR(rmi.creation_date_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CREATED",
        CASE
          WHEN o.id IS NULL THEN isp.name
          WHEN o.id IS NOT NULL AND isp.code != '-' THEN isp.name
          ELSE 'CHECKED OUT'
        END AS status,
        TO_CHAR(i.last_checkout_gmt,'YYYY-MM-DD HH24:MI:SS') AS "LOutDate",
        TO_CHAR(o.checkout_gmt,'YYYY-MM-DD HH24:MI:SS') AS "OutDate",
        TO_CHAR(i.last_checkin_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CheckInDate",
        TO_CHAR(o.due_gmt,'YYYY-MM-DD HH24:MI:SS') AS "DueDate",
        i.year_to_date_checkout_total AS "YTDCIRC",
        i.last_year_to_date_checkout_total AS "LYRCIRC",
        i.checkout_total AS "TOT_CHKOUT",
        i.renewal_total AS "TOT_RENEW"
  
        FROM sierra_view.item_record i
        JOIN sierra_view.record_metadata rmi
          ON i.id = rmi.id
          --Pull full file on Fridays, delta file other days
	         AND rmi.record_last_updated_gmt::DATE <= CURRENT_DATE
	      JOIN sierra_view.item_record_property ip
          ON i.id = ip.item_record_id
        JOIN sierra_view.bib_record_item_record_link l
          ON i.id = l.item_record_id
        JOIN sierra_view.record_metadata rmb
          ON l.bib_record_id = rmb.id
        JOIN sierra_view.bib_record_property bp
          ON l.bib_record_id = bp.bib_record_id
        JOIN sierra_view.itype_property_myuser it
          ON i.itype_code_num = it.code
        JOIN sierra_view.location_myuser loc
          ON i.location_code = loc.code
        JOIN sierra_view.material_property_myuser mp
          ON bp.material_code = mp.code
        JOIN sierra_view.item_status_property_myuser isp
          ON i.item_status_code = isp.code
        LEFT JOIN sierra_view.subfield num
          ON bp.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'
        LEFT JOIN sierra_view.checkout o
          ON i.id = o.item_record_id
        LEFT JOIN sierra_view.varfield v
          ON i.id = v.record_id AND v.varfield_type_code = 'v'

        WHERE SUBSTRING(i.location_code,1,3) NOT IN ('trn','hpl','int','knp','','zzz','cmc')
        GROUP BY 1,2,3,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
    
        LIMIT 250000
        OFFSET {}""".format(offset)
        cursor.execute(large_items_query)
        rows = cursor.fetchall()
        with open(end_file,'a', encoding='utf-8', newline='') as tempFile:
            myFile = csv.writer(tempFile, delimiter=',')
            myFile.writerows(rows)
            tempFile.close()
            
    conn.close()
    return end_file

def ftp_file(file1):
    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\libraryiq.ini')

    cnopts = pysftp.CnOpts()
    cnopts.hostkeys = None 


    srv = pysftp.Connection(host=config['libraryiq']['host'], username=config['libraryiq']['user'], password = config['libraryiq']['pw'], cnopts=cnopts)
    
    srv.cwd('/upload')
    srv.put(file1)
    srv.close()
    os.remove(file1)

def main():
    bibs_query = """\
    SELECT
    rm.record_type_code||rm.record_num AS "BibNum",
    STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),';' ORDER BY num.occ_num) FILTER(WHERE num.marc_tag = '020') AS isbn,
    STRING_AGG(num.content,';' ORDER BY num.occ_num) FILTER(WHERE num.marc_tag = '022') issn,
    STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),';' ORDER BY num.occ_num) FILTER(WHERE num.marc_tag = '024') AS upc,
    mp.name AS "MaterialType",
    b.best_title,
    b.best_author,
    b.publish_year,
    TRIM(TRAILING ',' FROM pub.content) AS publisher
  
    FROM sierra_view.bib_record_property b
    JOIN sierra_view.record_metadata rm
      ON b.bib_record_id = rm.id
    LEFT JOIN sierra_view.subfield pub
      ON b.bib_record_id = pub.record_id AND pub.marc_tag IN ('260','264') AND pub.tag = 'b'
    LEFT JOIN sierra_view.subfield num
      ON b.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'
    JOIN sierra_view.material_property_myuser mp
      ON b.material_code = mp.code

    --Pull full data on Fridays, delta files other days
    WHERE
    CASE
      WHEN EXTRACT(DOW FROM CURRENT_DATE) = 5 THEN rm.record_last_updated_gmt::DATE <= CURRENT_DATE
      ELSE rm.record_last_updated_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'
    END

    GROUP BY 1,5,6,7,8,9
    """

    items_query = """\
    SELECT
    rmi.record_type_code||rmi.record_num AS "ItemNum",
    ip.barcode,
    rmb.record_type_code||rmb.record_num AS "BibNum",
    STRING_AGG(SUBSTRING(num.content FROM '[0-9xX]+'),';') FILTER(WHERE num.marc_tag = '020') AS isbn,
    STRING_AGG(num.content,';') FILTER(WHERE num.marc_tag = '022') issn,
    STRING_AGG(SUBSTRING(num.content FROM '[0-9]+'),';') FILTER(WHERE num.marc_tag = '024') AS upc,
    i.icode1,
    i.itype_code_num AS itype,
    it.name AS "ItypeName",
    mp.name AS "MaterialType",
    SUBSTRING(i.location_code,1,3) AS "BranchId",
    TRIM(LEADING '|a' FROM TRIM(ip.call_number))||COALESCE(' '||v.field_content,'') AS "CallNumber",
    i.location_code,
    loc.name AS location_name,
    TO_CHAR(rmi.creation_date_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CREATED",
    CASE
      WHEN o.id IS NULL THEN isp.name
      WHEN o.id IS NOT NULL AND isp.code != '-' THEN isp.name
      ELSE 'CHECKED OUT'
    END AS status,
    TO_CHAR(i.last_checkout_gmt,'YYYY-MM-DD HH24:MI:SS') AS "LOutDate",
    TO_CHAR(o.checkout_gmt,'YYYY-MM-DD HH24:MI:SS') AS "OutDate",
    TO_CHAR(i.last_checkin_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CheckInDate",
    TO_CHAR(o.due_gmt,'YYYY-MM-DD HH24:MI:SS') AS "DueDate",
    i.year_to_date_checkout_total AS "YTDCIRC",
    i.last_year_to_date_checkout_total AS "LYRCIRC",
    i.checkout_total AS "TOT_CHKOUT",
    i.renewal_total AS "TOT_RENEW"
  
    FROM sierra_view.item_record i
    JOIN sierra_view.record_metadata rmi
      ON i.id = rmi.id
      --Pull full file on Fridays, delta file other days
	     AND rmi.record_last_updated_gmt::DATE > CURRENT_DATE - INTERVAL '4 days'
	  JOIN sierra_view.item_record_property ip
      ON i.id = ip.item_record_id
    JOIN sierra_view.bib_record_item_record_link l
      ON i.id = l.item_record_id
    JOIN sierra_view.record_metadata rmb
      ON l.bib_record_id = rmb.id
    JOIN sierra_view.bib_record_property bp
      ON l.bib_record_id = bp.bib_record_id
    JOIN sierra_view.itype_property_myuser it
      ON i.itype_code_num = it.code
    JOIN sierra_view.location_myuser loc
      ON i.location_code = loc.code
    JOIN sierra_view.material_property_myuser mp
      ON bp.material_code = mp.code
    JOIN sierra_view.item_status_property_myuser isp
      ON i.item_status_code = isp.code
    LEFT JOIN sierra_view.subfield num
      ON bp.bib_record_id = num.record_id AND num.marc_tag IN ('020','022','024') AND num.tag = 'a'
    LEFT JOIN sierra_view.checkout o
      ON i.id = o.item_record_id
    LEFT JOIN sierra_view.varfield v
      ON i.id = v.record_id AND v.varfield_type_code = 'v'

    WHERE SUBSTRING(i.location_code,1,3) NOT IN ('trn','hpl','int','knp','','zzz','cmc')

    GROUP BY 1,2,3,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
    """
    
    holds_query = """\
    SELECT
    DISTINCT rm.record_type_code||rm.record_num AS "BibNum",
    SUBSTRING(h.pickup_location_code,1,3) AS "BranchID",
    COUNT(DISTINCT h.id) AS "Number of requests"
  
    FROM sierra_view.hold h
    JOIN sierra_view.bib_record_item_record_link l
      ON h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
    JOIN sierra_view.record_metadata rm
      ON l.bib_record_id = rm.id

    WHERE h.expires_gmt::DATE > CURRENT_DATE
    GROUP BY 1,2
    """
    
    patrons_query = """\
    SELECT
    rmp.record_type_code||rmp.record_num AS PatronNum,
    TO_CHAR(p.expiration_date_gmt,'YYYY-MM-DD HH24:MI:SS') AS "ExpireDate",
    p.ptype_code AS "PatronType",
    pt.name AS "PatronTypeName",
    l.code AS "PatronBranch",
    --missing YTDYearCount and PreviousYearCount
    p.checkout_total + p.renewal_total AS "TotalCheckout",
    TO_CHAR(p.activity_gmt,'YYYY-MM-DD HH24:MI:SS') AS "ActivityDate",
    TO_CHAR(
      (SELECT
      MAX(rh.checkout_gmt)
	   FROM sierra_view.reading_history rh 
	   WHERE rh.patron_record_metadata_id=rmp.id)
    ,'YYYY-MM-DD HH24:MI:SS') AS "LastCheckout",
    TO_CHAR(rmp.creation_date_gmt,'YYYY-MM-DD HH24:MI:SS') AS "CreateDate",
    a.addr1 AS "AddressLn1",
    a.addr2 AS "AddressLn2",
    COALESCE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(a.city),'\d','','g'),'\s(ma|MA)$','','i'),'') AS "AddressCity",
    COALESCE(CASE
      WHEN a.region = '' AND (LOWER(a.city) ~ '\sma$' OR p.pcode3 BETWEEN '1' AND '200') THEN 'MA'
	   ELSE a.region
    END,'') AS "AddressState",
    a.postal_code AS "AddressZip"

    FROM sierra_view.patron_record p
    JOIN sierra_view.ptype_property_myuser pt
      ON p.ptype_code = pt.value
    LEFT JOIN sierra_view.location_myuser l
      ON UPPER(REGEXP_REPLACE(REGEXP_REPLACE(pt.name,'Fram State|Fram. State','Framingham STATE'),' (eCard|Exempt|Faculty|Student|Teacher|Homebound|CrossReg Student)','')) = REGEXP_REPLACE(l.name,' (COLLEGE|UNIVERSITY)','')
    JOIN sierra_view.record_metadata rmp
      ON p.id = rmp.id
    JOIN sierra_view.patron_record_address a
      ON p.id = a.patron_record_id AND a.patron_record_address_type_id = 1

    --Pull full file on Fridays, delta file other days
    WHERE 
    CASE
      WHEN EXTRACT(DOW FROM CURRENT_DATE) = 5 THEN rmp.record_last_updated_gmt::DATE <= CURRENT_DATE
      ELSE rmp.record_last_updated_gmt::DATE = CURRENT_DATE - INTERVAL '1 day'
    END
    """

    circ_query = """\
    SELECT
    rmi.record_type_code||rmi.record_num AS "ItemNum",
    ip.barcode AS "Barcode",
    rmb.record_type_code||rmb.record_num AS "BibNum",
    rmp.record_type_code||rmp.record_num AS "PatronNum",
    TO_CHAR(t.transaction_gmt, 'YYYY-MM-DD HH24:MI:SS') AS "CheckoutDate",
    SUBSTRING(sg.location_code,1,3) AS "BranchCodeNum",
    CASE
      WHEN t.op_code = 'r' THEN 'RENEWAL'
      WHEN t.op_code = 'o' THEN 'CHECKOUT'
      WHEN t.op_code = 'u' THEN 'USE COUNT'
    END AS "TransactionType",
    t.due_date_gmt::DATE AS "DueDate",
    i.last_checkin_gmt::DATE AS "CheckInDate",
    CASE
      WHEN rmi.campus_code = 'ncip' THEN TRUE
      ELSE FALSE
    END AS "IsVirtual"
  
    FROM sierra_view.circ_trans t
    JOIN sierra_view.item_record i
      ON t.item_record_id = i.id
    JOIN sierra_view.record_metadata rmi
      ON i.id = rmi.id
    JOIN sierra_view.item_record_property ip
      ON i.id = ip.item_record_id
    JOIN sierra_view.record_metadata rmb
      ON t.bib_record_id = rmb.id
    LEFT JOIN sierra_view.record_metadata rmp
      ON t.patron_record_id = rmp.id
    JOIN sierra_view.statistic_group_myuser sg
      ON t.stat_group_code_num = sg.code

    WHERE
      t.op_code IN ('o','r','u')
      AND t.transaction_gmt::DATE > CURRENT_DATE - INTERVAL '4 days'
    """
    
    fulfilled_holds_query = """\
    SELECT
    rm.record_type_code||rm.record_num AS "bibliographicRecordID",
    t.id AS "holdID",
    /*stat_group defines login where the transaction occured
    how outreach or mobile device transactions are recorded will depend on customer setup*/
    SUBSTRING(sg.location_code,1,3) AS "requestedLocation",
    t.transaction_gmt AS "fulfilledDate",
    CURRENT_DATE AS "reportDate"

    FROM sierra_view.circ_trans t
    JOIN sierra_view.record_metadata rm
      ON t.bib_record_id = rm.id
    JOIN sierra_view.statistic_group_myuser sg
      ON t.stat_group_code_num = sg.code
    JOIN sierra_view.bib_record_property bp
      ON rm.id = bp.bib_record_id
      AND bp.material_code NOT IN ('b','y','s','h','w','l')

    WHERE 
      /*op_code f = filled hold*/
      t.op_code = 'f'
      AND t.transaction_gmt::DATE > CURRENT_DATE - INTERVAL '4 days'

    ORDER BY t.transaction_gmt
    """
    
    requested_holds_query = """\
    SELECT
    rm.record_type_code||rm.record_num AS "bibliographicRecordID",
    t.id AS "holdID",
    /*
    home_library_code is the default pickup location for the patron placing the hold
    the patron does have the option to change it on the fly when placing the hold
    */
    SUBSTRING(p.home_library_code,1,3) AS "patronLocation",
    t.transaction_gmt AS "requestedDate",
    CURRENT_DATE AS "reportDate"

    FROM sierra_view.circ_trans t
    JOIN sierra_view.record_metadata rm
      ON t.bib_record_id = rm.id
    JOIN sierra_view.patron_record p
      ON t.patron_record_id = p.id
    JOIN sierra_view.bib_record_property bp
      ON rm.id = bp.bib_record_id
      AND bp.material_code NOT IN ('b','y','s','h','w','l')

    WHERE 
      /*
      different types of holds are assigned different op_code values
      looking for any starting with an n or h will capture all options
      */
      t.op_code ~ '^(n|h)'
      AND t.transaction_gmt::DATE > CURRENT_DATE - INTERVAL '4 days'

    ORDER BY t.transaction_gmt
    """
    
    unfilled_holds_query = """\
    SELECT
    DISTINCT h.id AS "holdID",
    rm.record_type_code||rm.record_num AS "bibliographicRecordID",
    h.placed_gmt AS "requestedDate",
    /*logic for using first 3 characters of location code to designate branch specific to Minuteman*/
    SUBSTRING(h.pickup_location_code,1,3) AS "requestedLocation",
    CURRENT_DATE AS "reportDate"
 
    FROM sierra_view.hold h
    /*Using or in the join to reconcile both bib holds and item holds to a bib record*/
    JOIN sierra_view.bib_record_item_record_link li
      ON h.record_id = li.bib_record_id OR h.record_id = li.item_record_id
    JOIN sierra_view.record_metadata rm
      ON li.bib_record_id = rm.id
    JOIN sierra_view.bib_record_property bp
      ON rm.id = bp.bib_record_id
      AND bp.material_code NOT IN ('b','y','s','h','w','l')

    WHERE
      (h.expires_gmt > CURRENT_DATE OR h.expires_gmt IS NULL)
      --limit results to just holds with a status of on hold
      AND h.status = '0'

    /*
    Union to second query to account for volume level holds in addition to bib and item level ones
    Minuteman does not use volume holds but meaningful for other customers
    */

    UNION

    SELECT
    DISTINCT h.id AS "holdID",
    rm.record_type_code||rm.record_num AS "bibliographicRecordID",
    h.placed_gmt AS "requestedDate",
    SUBSTRING(h.pickup_location_code,1,3) AS "requestedLocation",
    CURRENT_DATE AS "reportDate"
 
    FROM sierra_view.hold h
    JOIN sierra_view.bib_record_volume_record_link lv
      ON h.record_id = lv.volume_record_id
    JOIN sierra_view.record_metadata rm
      ON lv.bib_record_id = rm.id
    JOIN sierra_view.bib_record_property bp
      ON rm.id = bp.bib_record_id
      AND bp.material_code NOT IN ('b','y','s','h','w','l')
  
    WHERE  
      (h.expires_gmt > CURRENT_DATE OR h.expires_gmt IS NULL)
      --limit results to just holds with a status of on hold
      AND h.status = '0'
    """
    
    on_order_query = """\
    --breaking out copy calculation to sub query to avoid one-to-many join errors
    WITH copies_ordered AS(
    SELECT
    o.id AS order_record_id,
    SUM(cmf.copies) AS copies
  
    FROM sierra_view.order_record o
    /*
    cmf table handles copies/locations/fund data, which may contain multiple values for a single record
    table also contains an extraneous row in these case for a location called 'multi' that displays to staff
    filtering those rows out to avoid duplicate data
    */  
      JOIN sierra_view.order_record_cmf cmf
      ON o.id = cmf.order_record_id
      AND o.order_status_code IN ('o','q')
      AND cmf.location_code != 'multi'
    GROUP BY 1
    ),

    copies_paid AS(
    SELECT
    o.id AS order_record_id,
    SUM(COALESCE(op.copies,0)) AS copies_paid
  
    FROM sierra_view.order_record o
    LEFT JOIN sierra_view.order_record_paid op
      ON o.id = op.order_record_id AND o.order_status_code IN ('o','q')
    GROUP BY 1
    )

    SELECT * FROM(
    SELECT
    rmb.record_type_code||rmb.record_num AS "bibliographicRecordID",
    a.name AS "branchCode",
    rmo.record_type_code||rmo.record_num AS "orderID",
    --total copies ordered - copies that have been paid for
    c.copies - cp.copies_paid AS "copies",
    TO_CHAR(CURRENT_DATE,'YYYY-MM-DD') AS "reportDate"

    FROM sierra_view.order_record o
    JOIN sierra_view.record_metadata rmo
      ON o.id = rmo.id
    JOIN sierra_view.bib_record_order_record_link l
      ON o.id = l.order_record_id
    JOIN sierra_view.record_metadata rmb
      ON l.bib_record_id = rmb.id
    JOIN sierra_view.bib_record_property bp
      ON rmb.id = bp.bib_record_id
      AND bp.material_code NOT IN ('b','y','s','h','w','l')
    /*
    looking at accounting unit as an easy way to tie record to a single location
    Single sites or libraries with a single accounting unit will need to look at order_record_cmf.location_code instead
    */
    JOIN sierra_view.accounting_unit_myuser a
      ON o.accounting_unit_code_num = a.code
    JOIN copies_ordered c
      ON o.id = c.order_record_id
    JOIN copies_paid cp
      ON o.id = cp.order_record_id

    WHERE 
      /*Filtering to orders that are still on order or that have only been partially received*/
      order_status_code IN ('o','q')
    )inner_query
    WHERE inner_query."copies" > 0
    """

    bibs_file = 'Biblio_{}.csv'.format(date.today().strftime('%Y%m%d'))
    items_file = 'Items_{}.csv'.format(date.today().strftime('%Y%m%d'))
    holds_file = 'Holds_{}.csv'.format(date.today().strftime('%Y%m%d'))
    patrons_file = 'Patrons_{}.csv'.format(date.today().strftime('%Y%m%d'))
    circ_file = 'Circ_{}.csv'.format(date.today().strftime('%Y%m%d'))
    fulfilled_holds_file = 'Holds_Fulfilled_{}.csv'.format(date.today().strftime('%Y%m%d'))
    requested_holds_file = 'Holds_Requested_{}.csv'.format(date.today().strftime('%Y%m%d'))
    unfilled_holds_file = 'Holds_Unfilled_{}.csv'.format(date.today().strftime('%Y%m%d'))
    on_order_file = 'OrderedItems_{}.csv'.format(date.today().strftime('%Y%m%d'))

    bibs_csv = runquery(bibs_query,bibs_file)
    ftp_file(bibs_csv)
    holds_csv = runquery(holds_query,holds_file)
    ftp_file(holds_csv)
    patrons_csv = runquery(patrons_query,patrons_file)
    ftp_file(patrons_csv)
    circ_csv = runquery(circ_query,circ_file)
    ftp_file(circ_csv)
    fulfilled_holds_csv = runquery(fulfilled_holds_query,fulfilled_holds_file)
    ftp_file(fulfilled_holds_csv)
    requested_holds_csv = runquery(requested_holds_query,requested_holds_file)
    ftp_file(requested_holds_csv)
    unfilled_holds_csv = runquery(unfilled_holds_query,unfilled_holds_file)
    ftp_file(unfilled_holds_csv)
    on_order_csv = runquery(on_order_query,on_order_file)
    ftp_file(on_order_csv)
    
    if datetime.now().weekday() == 4:
        items_csv = runlargequery(items_file)
    else:
        items_csv = runquery(items_query,items_file)
    ftp_file(items_csv)
    
main()
