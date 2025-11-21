/*
Jeremy Goldstein
Minuteman Library Network
Based on code shared by Ray Voelker

Identifies potentially duplicated patron records based on matching birth_date and near matching name
Is passed variable for ptype(s)
*/

SELECT
  *,
  '' AS "DUPLICATE PATRON RECORDS",
  '' AS "https://sic.minlib.net/reports/28"

FROM(
  SELECT
    t1.created_date,
    MAX(t1.barcode) AS barcode,
    'p'||t1.patron_record_num||'a' AS patron_number,
    STRING_AGG(t1.name,'|') AS NAME,
    t1.birth_date,
    t1.ptype_code,
    t1.home_library_code,
    t1.activity_gmt AS last_active_date,
    t1.expiration_date_gmt AS expiration_date

  FROM (
    SELECT
      r.creation_date_gmt::DATE AS created_date,
      e.index_entry AS barcode,
      r.record_num AS patron_record_num,
      pn.last_name||', '||pn.first_name||COALESCE(' '||NULLIF(pn.middle_name,''),'') AS NAME,
      pr.birth_date_gmt AS birth_date,
      pr.ptype_code,
      pr.home_library_code,
      pr.activity_gmt::DATE,
      pr.expiration_date_gmt::DATE

    FROM sierra_view.patron_record_fullname pn
    JOIN sierra_view.patron_record pr
      ON pr.record_id = pn.patron_record_id
    JOIN sierra_view.record_metadata r
      ON r.id = pr.record_id
    LEFT JOIN sierra_view.phrase_entry e
      ON e.record_id = r.id
		AND e.index_tag = 'b'
		AND e.varfield_type_code = 'b'
  
  WHERE SUBSTRING(pn.last_name,1,4) || ', ' ||SUBSTRING(pn.first_name,1,3) || COALESCE(' ' || NULLIF(pn.middle_name, ''), '') || ' ' || pr.birth_date_gmt 
    IN (
	   SELECT
	    SUBSTRING(n.last_name,1,4) || ', ' ||SUBSTRING(n.first_name,1,3) || COALESCE(' ' || NULLIF(n.middle_name, ''), '') || ' ' || p.birth_date_gmt AS patron_name
	
	   FROM sierra_view.patron_record p
	   JOIN sierra_view.record_metadata r
	     ON r.id = p.record_id
	   JOIN sierra_view.patron_record_fullname n
	     ON n.patron_record_id = r.id
		
	   WHERE r.record_type_code = 'p'
	   AND p.ptype_code IN ({{ptype}})
		GROUP BY p.birth_date_gmt, patron_name, p.ptype_code
   	HAVING COUNT(*) > 1
    )
  )t1
  JOIN (
    SELECT MAX(patron_record_num) AS max_record_num,
    NAME,
    ptype_code,
    birth_date,
    created
    FROM (
      SELECT
        r.creation_date_gmt as created,
        e.index_entry as barcode,
        r.record_num AS patron_record_num,
        pn.last_name || ', ' ||pn.first_name || COALESCE(' ' || NULLIF(pn.middle_name, ''), '') AS NAME,
        pr.birth_date_gmt as birth_date,
        pr.ptype_code,
        pr.home_library_code,
        pr.activity_gmt,
        pr.expiration_date_gmt

      FROM sierra_view.patron_record_fullname pn
      JOIN sierra_view.patron_record pr
        ON pr.record_id = pn.patron_record_id
      JOIN sierra_view.record_metadata r
        ON r.id = pr.record_id
      LEFT JOIN sierra_view.phrase_entry e
        ON e.record_id = r.id
		  AND e.index_tag = 'b'
		  AND (e.varfield_type_code = 'b')
  
      WHERE SUBSTRING(pn.last_name,1,4)||', '||SUBSTRING(pn.first_name,1,3)||COALESCE(' '||NULLIF(pn.middle_name,''),'')||' '||pr.birth_date_gmt 
        IN (
	       SELECT
	         SUBSTRING(n.last_name,1,4)||', '||SUBSTRING(n.first_name,1,3)||COALESCE(' '||NULLIF(n.middle_name,''),'')||' '||p.birth_date_gmt AS patron_name
	 
	       FROM sierra_view.patron_record p
	       JOIN sierra_view.record_metadata r
	         ON r.id = p.record_id
	       JOIN sierra_view.patron_record_fullname n
	         ON n.patron_record_id = r.id
	
	       WHERE r.record_type_code = 'p'
	       GROUP BY p.birth_date_gmt,patron_name,p.ptype_code
	       HAVING COUNT(*) > 1
        )
    )t1

    GROUP BY 5,2,3,4
  )t2
    ON t1.birth_date = t2.birth_date
	 AND t1.patron_record_num = t2.max_record_num 

  GROUP BY 3,1,5,6,7,8,9
  HAVING COUNT(t1.name) = 1

  ORDER BY 4,6,1,3
)a