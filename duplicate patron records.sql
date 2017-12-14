-- based on query by David Jones and shared over Sierra listserv 9/20/16
-- Finds patron records sharing a name

SELECT
    DISTINCT id2reckey(p.id)||'a' AS pnumber,
    n.first_name || ' ' || n.middle_name || ' ' || n.last_name AS Name,
    a.addr1 AS Address,
    p.city as Town/City,
    p.ptype_code AS ptype,
    p.barcode AS Barcode
FROM
    sierra_view.patron_record_fullname as n
JOIN
    sierra_view.patron_view as p
ON
    n.patron_record_id=p.id and p.ptype_code != '205'
JOIN
    sierra_view.patron_record_address as a
ON
    a.patron_record_id=p.id
WHERE
    (concat (n.first_name, n.middle_name, n.last_name),a.addr1) IN (
         SELECT 
              concat (n.first_name, n.middle_name, n.last_name),
              a.addr1
         FROM
              sierra_view.patron_record_fullname AS n
         JOIN
	      sierra_view.patron_view as p
	 ON
              n.patron_record_id=p.id and p.ptype_code != '205'
	 JOIN
              sierra_view.patron_record_address as a
	 ON
              a.patron_record_id=p.id
         GROUP BY
              1,2
         HAVING
              count (n.id) > 1)
ORDER BY
2;
              