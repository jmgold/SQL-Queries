--Lazy way to generate staff picks booklist
SELECT
--link to Encore
'https://find.minlib.net/iii/encore/record/C__R'||id2reckey(b.bib_record_id)   AS field_booklist_entry_encore_url,
b.best_title as title,
b.best_author as field_booklist_entry_author
FROM
sierra_view.bib_record_property b
JOIN sierra_view.bib_record_item_record_link bi
ON
b.bib_record_id = bi.bib_record_id
JOIN
sierra_view.bib_view v
ON
b.bib_record_id = v.id AND
v.record_num IN (
'3218896','1055905','1568235','3620398','3039722','2120661','3621089','3620408','3677969','3157060','3435459','3507884','3639882',
'3479291','3471855','3739969','3563377','3138163','3599414','3679584','3478349','3520383','3782760','3769047','3733251','3730457',
'3676011','3720196','3771046','3775305','3480633','3749959','3149142','3422954','3475094','3455206','3243400','3755826','3490099',
'3771138','3771146','3755685','3434597','3273511','3438905','2138191','3605651','3612407','3738695','3648316','3508650','3146837',
'3583872'
)
GROUP BY 1,2,3 
ORDER BY RANDOM()
LIMIT 25;