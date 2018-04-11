--Jeremy Goldstein
--Minuteman Library Network

--top 50 most requested titles in the network, used for list found at this link: http://www.mln.lib.ma.us/Top50.htm

SELECT
'http://find.minlib.net/iii/encore/record/C__R'||id2reckey(h.record_id)   AS "URL",
best_title,
best_author,
COUNT(h.id)
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_property b
ON
--limited to books
h.record_id = b.bib_record_id and b.material_code = 'a'
GROUP BY 1,2,3
ORDER BY 4 desc
LIMIT 50
