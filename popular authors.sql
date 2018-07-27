--top 100 authors by holds, 
--swap in commented lines to calculate by checkouts instead

SELECT
b.best_author,
count (h.id)
--count (c.id)
FROM
sierra_view.hold h
--sierra_view.circ_trans c
JOIN
sierra_view.bib_record_property b
ON
h.record_id = b.bib_record_id
--c.bib_record_id = b.bib_record_id
AND b.material_code = 'a'
--AND c.op_code = 'o'
GROUP BY 1
ORDER BY 2 DESC

LIMIT 101