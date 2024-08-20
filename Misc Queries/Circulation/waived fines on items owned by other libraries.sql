/*
Jeremy Goldstein
Minuteman Library Network

Identifies waived fines from the fines paid table where the transaction library is not the charging library
*/

SELECT *

FROM
sierra_view.fines_paid f

WHERE
((f.charge_type_code IN ('3','5') AND f.paid_now_amt = 0)
OR f.payment_status_code = '3')
AND
SUBSTRING(f.charge_location_code,1,2) != CASE
WHEN (f.tty_num BETWEEN '100' AND '109') OR (f.tty_num BETWEEN '870' AND '879') THEN 'ac'
WHEN f.tty_num BETWEEN '110' AND '129' OR f.tty_num = '996' THEN 'ar'
WHEN f.tty_num BETWEEN '130' AND '139' THEN 'as'
WHEN f.tty_num BETWEEN '140' AND '149' THEN 'be'
WHEN f.tty_num BETWEEN '150' AND '179' THEN 'bl'
WHEN f.tty_num BETWEEN '180' AND '209' THEN 'br'
WHEN (f.tty_num BETWEEN '210' AND '299') OR f.tty_num IN ('994','997') THEN 'ca'
WHEN f.tty_num BETWEEN '300' AND '319' THEN 'co'
WHEN f.tty_num BETWEEN '340' AND '349' THEN 'de'
WHEN f.tty_num BETWEEN '320' AND '339' THEN 'dd'
WHEN f.tty_num BETWEEN '350' AND '359' THEN 'do'
WHEN f.tty_num BETWEEN '360' AND '379' THEN 'fp'
WHEN f.tty_num BETWEEN '390' AND '399' THEN 'fs'
WHEN f.tty_num BETWEEN '380' AND '389' THEN 'fr'
WHEN f.tty_num BETWEEN '400' AND '409' THEN 'ho'
WHEN f.tty_num BETWEEN '410' AND '419' THEN 'la'
WHEN f.tty_num BETWEEN '420' AND '439' THEN 'le'
WHEN f.tty_num BETWEEN '440' AND '449' THEN 'li'
WHEN f.tty_num BETWEEN '450' AND '459' THEN 'ma'
WHEN f.tty_num BETWEEN '500' AND '509' THEN 'ml'
WHEN f.tty_num BETWEEN '480' AND '489' THEN 'me'
WHEN f.tty_num BETWEEN '520' AND '529' THEN 'mw'
WHEN f.tty_num BETWEEN '490' AND '499' THEN 'mi'
WHEN f.tty_num BETWEEN '530' AND '569' THEN 'na'
WHEN f.tty_num BETWEEN '570' AND '579' THEN 'ne'
WHEN f.tty_num BETWEEN '590' AND '599' THEN 'nt'
WHEN f.tty_num BETWEEN '580' AND '589' THEN 'no'
WHEN f.tty_num BETWEEN '620' AND '629' THEN 'ol'
WHEN f.tty_num BETWEEN '830' AND '839' THEN 'pm'
WHEN f.tty_num BETWEEN '840' AND '849' THEN 're'
WHEN f.tty_num BETWEEN '850' AND '859' THEN 'sh'
WHEN f.tty_num BETWEEN '640' AND '679' THEN 'so'
WHEN f.tty_num BETWEEN '680' AND '689' THEN 'st'
WHEN f.tty_num BETWEEN '690' AND '699' THEN 'su'
WHEN (f.tty_num BETWEEN '700' AND '709') OR f.tty_num = '993' THEN 'wl'
WHEN f.tty_num BETWEEN '710' AND '739' THEN 'wa'
WHEN f.tty_num BETWEEN '740' AND '749' THEN 'wy'
WHEN f.tty_num BETWEEN '750' AND '779' THEN 'we'
WHEN f.tty_num BETWEEN '800' AND '809' THEN 'ws'
WHEN f.tty_num BETWEEN '810' AND '829' THEN 'ww'
WHEN f.tty_num BETWEEN '780' AND '789' THEN 'wi'
WHEN f.tty_num BETWEEN '790' AND '799' THEN 'wo'
END

ORDER BY f.paid_date_gmt