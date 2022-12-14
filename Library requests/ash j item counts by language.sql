--ASH juv item counts by language,
--given callnumbers of the form [FOREIGN LANGUAGE - SPANISH] J 400

SELECT
SPLIT_PART(SPLIT_PART(ip.call_number,'- ',2),']',1) AS language,
COUNT(i.id) AS item_count
FROM
sierra_view.item_record i
JOIN
sierra_view.item_record_property ip
ON
i.id = ip.item_record_id AND i.location_code ~ '^ashj'
WHERE
ip.call_number_norm ~ '^\[foreign language.*'

GROUP BY 1