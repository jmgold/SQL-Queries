--Produces random sample of item records for a specified libraryto be imported into a review file for use
SELECT
id2reckey(i.id)
FROM
sierra_view.item_record AS i
-JOIN
WHERE
i.agency_code_num='2'
ORDER BY
RANDOM()
LIMIT 1000;