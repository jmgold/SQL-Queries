SELECT
	bcode3,
	count (id),
	round(cast(count (id) as numeric (12,2)) / (select cast(count(id) as numeric (12,2)) from sierra_view.bib_view where cataloging_date_gmt is not null AND cataloging_date_gmt > (localtimestamp - interval '7 days') AND (bcode3 = 't' or bcode3 ='-')),2) as Percentage
FROM
	sierra_view.bib_view
WHERE
	cataloging_date_gmt is not null AND
	cataloging_date_gmt > (localtimestamp - interval '7 days') AND
	(bcode3 = 't' or bcode3 ='-')
GROUP By 1