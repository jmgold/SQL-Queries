--avg transit time 2 days
--avg days to pick up 3 days

WITH abandoned_holds AS (
SELECT 
l.bib_record_id,
COUNT (h.*) AS abandoned_count

FROM
sierra_view.hold_removed h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.item_record_id

WHERE
h.removed_by_program = 'clearholdshelf' AND h.expire_holdshelf_gmt IS NOT NULL AND h.removed_gmt > CURRENT_DATE - INTERVAL '1 month'

GROUP BY 1
),

checkins AS (
SELECT
l.bib_record_id,
ROUND(AVG(i.last_checkin_gmt::DATE - i.last_checkout_gmt::DATE)) AS days_out

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
WHERE
i.last_checkin_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month'
AND i.last_checkin_gmt::DATE > i.last_checkout_gmt::DATE

GROUP BY 1
),

filled_holds AS (
SELECT
l.bib_record_id,
COUNT(t.id) AS filled_count

FROM
sierra_view.circ_trans t
JOIN
sierra_view.bib_record_item_record_link l
ON
t.item_record_id = l.item_record_id AND t.op_code = 'f'

GROUP BY 1
),

top_titles AS (
SELECT
id

FROM
sierra_view.record_metadata
WHERE
record_type_code = 'b'
AND record_num IN (
'4192442',
'4158988',
'4183430',
'4105647',
'4135714',
'4168490',
'4135729',
'4153877',
'4199487',
'4161791',
'4160889',
'4154389',
'4188522',
'4153148',
'4183227',
'4197285',
'4051137',
'4175298',
'4197283',
'4197402',
'4169468',
'4083399',
'4199964',
'4153867',
'4189894',
'4169078',
'4055480',
'2404460',
'4168497',
'4034876',
'4185570',
'4175649',
'2299233',
'4183223',
'4163799',
'4169467',
'4157910',
'4202375',
'4197270',
'4192854',
'4130534',
'4183261',
'4163800',
'4189907',
'4157282',
'4199484',
'4153533',
'4199154',
'4176638',
'4146410',
'4191600',
'4178228',
'4129956',
'4202340',
'4167467',
'4167411',
'4196386',
'4188461',
'4169401',
'4183258',
'4193941',
'4169946',
'4186829',
'4169472',
'4191139',
'3592914',
'4201045',
'3784215',
'4146411',
'4158987',
'4194623',
'4175871',
'4201471',
'4199575',
'4190584',
'4169950',
'4169440',
'4160497',
'4167444',
'4199458',
'4201848',
'4196893',
'4163802',
'4169404',
'4200712',
'4166545',
'4188501',
'4194798',
'4199733',
'4197388',
'4103710',
'4194234',
'4197293',
'4086247',
'4183340',
'4188125',
'4169469',
'4153532',
'4127395',
'4199529',
'4137174',
'4160665',
'4191524',
'2950186',
'4055479',
'3997665',
'4196380',
'4191608',
'4201231',
'4189914',
'4200894',
'4201217',
'4105001',
'4183225',
'4188468',
'4119260',
'4192940',
'4183242',
'4189908',
'4204353',
'4169945',
'4178575',
'4144970',
'4200529',
'4170736',
'4179194',
'3986577',
'4183879',
'4176429',
'4188526',
'4190352',
'4188117',
'4197399',
'3808188',
'4050190',
'2095623',
'4177709',
'4200004',
'4200714',
'4174595',
'4194133',
'4133489',
'4135738',
'4188525',
'4208008',
'4179182',
'4199948',
'4167773',
'3222128',
'4134813',
'4194622',
'4197389',
'4172964',
'3982317',
'4201239',
'4204297',
'4160493',
'4170705',
'4175880',
'4189921',
'4155153',
'4191662',
'4166544',
'4162442',
'4199547',
'3895027',
'2760178',
'4197372',
'3939219',
'4196421',
'4203595',
'4154230',
'4183370',
'4037096',
'4162797',
'4199382',
'4179368',
'4174442',
'4201846',
'4179131',
'4201074',
'4177713',
'2662740',
'4194227',
'4111330',
'4156883',
'4183255',
'4192859',
'4143995',
'3892685',
'4174319',
'4140892',
'4189447',
'4056182',
'4199982',
'4131706',
'4196400',
'3049647',
'4111343',
'4154443'
)
)

SELECT
id2reckey(t.id) AS bib_num,
b.best_title,
b.best_author,
ci.days_out AS avg_checkout_length,
ci.days_out + 5 AS avg_checkout_plus_transit_time,
COALESCE(a.abandoned_count,0) AS abandoned_hold_count,
COALESCE(f.filled_count,0) AS filled_hold_count,
ROUND(100.0 * (COALESCE(a.abandoned_count,0)::NUMERIC/(COALESCE(a.abandoned_count,0)::NUMERIC+COALESCE(f.filled_count,0))::NUMERIC),2)||'%' AS abandoned_pct, 
COUNT(DISTINCT h.*) AS outstanding_hold_count,
COUNT(DISTINCT l.item_record_id) AS item_count,
CASE
    WHEN max(o1.order_copies) IS NULL THEN 0
    ELSE max(o1.order_copies)
    END
AS order_copies

FROM
top_titles t
JOIN
sierra_view.bib_record_property b
ON
t.id = b.bib_record_id
JOIN
sierra_view.record_metadata rm
ON
b.bib_record_id = rm.id
LEFT JOIN
abandoned_holds a
ON
b.bib_record_id = a.bib_record_id
LEFT JOIN
filled_holds f
ON
b.bib_record_id = f.bib_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
t.id = l.bib_record_id
JOIN
sierra_view.hold h
ON
l.item_record_id = h.record_id OR l.bib_record_id = h.record_id
LEFT JOIN
checkins ci
ON
b.bib_record_id = ci.bib_record_id
LEFT JOIN (
	SELECT
   SUM(oc.copies) AS order_copies,
   bro.bib_record_id
   
   FROM
	sierra_view.bib_record_order_record_link bro
   JOIN
	sierra_view.order_record o
   ON
	o.id=bro.order_record_id AND o.order_status_code = 'o'
   JOIN
	sierra_view.order_record_cmf oc
   ON oc.order_record_id=bro.order_record_id
   
	GROUP BY bro.bib_record_id
) o1
ON
t.id = o1.bib_record_id

GROUP BY 1,2,3,4,5,6,7
ORDER BY 7 desc