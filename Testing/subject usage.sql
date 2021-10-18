SELECT
d.index_entry,
COUNT(b.id)
FROM
sierra_view.phrase_entry d
JOIN
sierra_view.bib_record b 
ON
d.record_id = b.id AND d.index_tag = 'd'
JOIN
sierra_view.subfield s
ON
b.id = s.record_id AND s.field_type_code = 'd'

WHERE
REPLACE(LOWER(s.content),'-',' ') ~ --'(protestant)|(bible)|(nativity)|(adventis)|(mormon)|(baptist)|(catholic)|(methodis)|(pentecost)|(episcopal)|(lutheran)|(clergy)|(church)|(evangelicalism)|(christianity)|(easter)|(christmas)'
--'(\bzen\b)|(dalai lama)|(buddhis)'
--'(jews)|(judaism)|(hanukkah)|(purim)|(passover)|(zionism)|(hasidism)|(antisemitism)|(rosh hashanah)|(yom kippur)|(sabbath)|(sukkot)|(pentateuch)|(synagogue)'
--'(islam[^ic fundamentalism])|(ramadan)|(id al fitr)|(quran)|(sufism)|(sunnites)|(shiah)|(muslim)|(mosques)'
'(hinduism)|(divali)|(\bholi\b)|(bhagavadgita)|(upanishads)'

GROUP BY 1
ORDER BY 2 DESC