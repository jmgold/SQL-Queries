--Requested by Somerville
SELECT
round(AVG(bp.publish_year) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '1 year')), 0) as within_one_year,
round(AVG(bp.publish_year) FILTER(WHERE i.last_checkout_gmt >= (localtimestamp - interval '2 years')), 0) as within_two_years,
round(AVG(bp.publish_year) FILTER(WHERE i.last_checkout_gmt  < (localtimestamp - interval '5 years')), 0) as not_in_5_years
FROM
sierra_view.item_view i
JOIN
sierra_view.bib_record_item_record_link as bi
ON
i.id=bi.item_record_id
JOIN
sierra_view.bib_record_property bp
ON
bi.bib_record_id = bp.bib_record_id
WHERE
i.location_code LIKE 'so%'

