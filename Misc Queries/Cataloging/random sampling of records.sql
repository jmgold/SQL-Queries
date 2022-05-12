/*
Jeremy Goldstein
Minuteman Library Network
Produces random sample of item records for a specified library to be imported into a review file for use
*/
SELECT
rm.record_type_code||rm.record_num||'a' AS item_number
FROM
sierra_view.item_record AS i
JOIN
sierra_view.record_metadata rm
ON
i.id = rm.id
WHERE
i.location_code ~ '^act'
ORDER BY
RANDOM()
LIMIT 1000;
