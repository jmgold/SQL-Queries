#!/usr/bin/env python3

"""Create and email a list of new items

Jeremy Goldstein
Minuteman Library Network

Example for Automating booklist curation with SQL presentation given at IUG2019
"""

import psycopg2
import os
import io
import codecs

#Connecting to Sierra PostgreSQL database
#Add in the credentials for your database

conn = psycopg2.connect("dbname='' user='' host='' port='1032' password='' sslmode='require'")

#Opening a session and querying the database for weekly new items
cursor = conn.cursor()
cursor.execute(open("new books list.sql","r", encoding='utf-8').read())
#For now, just storing the data in a variable. We'll use it later.
rows = cursor.fetchall()
conn.close()

#deletes prior week's list

for fname in os.listdir("."):
    if os.path.isfile(fname) and fname.startswith("DemoNewBooks"):
        os.remove(fname)


#creates webpage with MLN css style guide
with io.open('DemoNewBooks.htm','w', encoding='utf-8') as f:
    f.write('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" lang="en"><head><TITLE>Minuteman Library Network Catalog - Booklists - Top Book List</TITLE></head><BODY><table border="1" cellpadding="5" align="center"><tr align="left"><td><strong>Title</strong></td><td><strong>Author</strong></td></tr>')
    #generates table
    for rownum, row in enumerate(rows):
        f.write("<td><a href=" + row[0] + ">" + row[1] + "</a></td><td>" + row[2] + "</td></tr>")
    f.write("</table></body></html>")
f.close()
