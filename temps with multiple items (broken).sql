SELECT
  b.record_num                AS "bib_record",
  date(b.cataloging_date_gmt) AS "bib_cataloged_dt",
  b.title                     AS "bib_title",
  a.item_count                AS "item_count",
  b.bcode3		      AS "bibcode"
FROM
(SELECT
    l.bib_record_id AS "bib_record_id",
    count(l.id) AS "item_count"
  FROM
    sierra_view.bib_record_item_record_link l
  GROUP BY l.bib_record_id
  HAVING count(l.id) > 100) AS a
    JOIN sierra_view.bib_view b ON a.bib_record_id = b.id
    WHERE
    b.bcode3 = 't'
  