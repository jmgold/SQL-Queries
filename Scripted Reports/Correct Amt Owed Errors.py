'''
Jeremy Goldstein
Minuteman Library Network

Script identifies patrons where the amt owed field does not equal the total of their current fines
Uses the Sierra API to correct those discrepancies by creating a manual fine for that residual amt and then waving it
'''

import requests
import json
import configparser
from base64 import b64encode
import psycopg2

#make sure to remove verify=False from all request calls, in place to handle expired certificate on test
#also temporary limit on error query from testing

def get_token():
    # config api    
    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\api_info.ini')
    base_url = config['api']['base_url']
    client_key = config['api']['client_key']
    client_secret = config['api']['client_secret']
    auth_string = b64encode((client_key + ':' + client_secret).encode('ascii')).decode('utf-8')
    header = {}
    header["authorization"] = 'Basic ' + auth_string
    header["Content-Type"] = 'application/x-www-form-urlencoded'
    body = {"grant_type": "client_credentials"}
    url = base_url + '/token'
    response = requests.post(url, data=json.dumps(body), headers=header, verify=False)
    json_response = json.loads(response.text)
    token = json_response["access_token"]
    return token

def runquery(query):
    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\api_info.ini')
    
    try:
	    conn = psycopg2.connect( config['api']['connection_string'] )
    except:
        print("unable to connect to the database")
        clear_connection()
        return
        
    cursor = conn.cursor()
    cursor.execute(query)
    rows = cursor.fetchall()
    return rows
    
def manual_charge(patron_id,amount,location):
    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\api_info.ini')
    token = get_token()
    url = config['api']['base_url'] + "/patrons/" + patron_id + "/fines/charge"
    header = {"Authorization": "Bearer " + token, "Content-Type": "application/json;charset=UTF-8"}
    payload = {"amount": amount, "reason": "Residual fine","location": location}
    request = requests.post(url, data=json.dumps(payload), headers = header, verify=False)

def clear_fine(patron_id,invoiceNumber):
    config = configparser.ConfigParser()
    config.read('C:\\SQL Reports\\creds\\api_info.ini')
    token = get_token()
    url = config['api']['base_url'] + "/patrons/" + patron_id + "/fines/payment"
    header = {"Authorization": "Bearer " + token, "Content-Type": "application/json;charset=UTF-8"}
    payload = {"payments": [{"amount": 0, "paymentType": 2, "invoiceNumber": "" + invoiceNumber + ""}]}
    request = requests.put(url, data=json.dumps(payload), headers = header, verify=False)
    
def main():
    error_query = """\
            SELECT
              rm.record_num,
              (p.owed_amt * 100 - (SUM(COALESCE(f.item_charge_amt*100, 0) + COALESCE(f.processing_fee_amt*100, 0) + COALESCE(f.billing_fee_amt*100, 0) - COALESCE(f.paid_amt*100, 0))))::INT AS FineDiscrepancy,
              p.home_library_code AS location
  
            FROM sierra_view.record_metadata rm
            JOIN sierra_view.patron_record p
              ON p.id = rm.id
            LEFT JOIN sierra_view.fine f
              ON f.patron_record_id = p.id

            GROUP BY rm.record_num, p.owed_amt,3
            HAVING p.owed_amt != SUM(COALESCE(f.item_charge_amt, 0.00) + COALESCE(f.processing_fee_amt, 0.00) + COALESCE(f.billing_fee_amt, 0.00) - COALESCE(f.paid_amt, 0.00))
            """
    
    manual_charge_query = """\
        SELECT
        rm.record_num,
        f.invoice_num::varchar

        FROM sierra_view.fine f
        JOIN sierra_view.record_metadata rm
            ON f.patron_record_id = rm.id

        WHERE f.assessed_gmt::DATE = CURRENT_DATE
            AND f.charge_code = '1'
            AND f.description = 'Residual fine' 
        """
    
    #identify patrons with amt owed errors and create manual charges in the amount of those discrepancies
    amt_owed_errors = runquery(error_query)
    for rownum, row in enumerate(amt_owed_errors):
        manual_charge(str(row[0]),row[1],row[2])

    #Find the newly created manual charges and waive them
    fines_to_clear = runquery(manual_charge_query)
    for rownum, row in enumerate(fines_to_clear):
        clear_fine(str(row[0]),row[1])         
                    
main()

