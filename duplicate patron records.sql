-- based on query by David Jones and shared over Sierra listserv 9/20/16
-- Finds patron records sharing a name

SELECT
    id2reckey(p.id)||'a' AS pnumber,
    n.first_name || ' ' || n.middle_name || ' ' || n.last_name AS Name,
    a.addr1 AS Address,
    p.ptype_code AS ptype,
    p.barcode AS Barcode
FROM
    sierra_view.patron_record_fullname as n
JOIN
    sierra_view.patron_view as p
ON
    n.patron_record_id=p.id
JOIN
    sierra_view.patron_record_address as a
ON
    a.patron_record_id=p.id
WHERE
    concat (n.first_name, n.middle_name, n.last_name) IN (
         SELECT 
              concat (n.first_name, n.middle_name, n.last_name)
         FROM
              sierra_view.patron_record_fullname AS n
         GROUP BY
              1
         HAVING
              count (n.id) > 1)
ORDER BY
2;
              