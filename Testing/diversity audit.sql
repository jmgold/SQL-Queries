SELECT
CASE
	WHEN d.index_entry ~ '(sexual minorities)|(gender)|(aesexual)|(bisexual)|(gay)|(intersex)|(homosexual)|(lesbian)' THEN 'LGBTQIA+ & Gender Studies'
	WHEN d.index_entry ~ '(asians)|(asian americans)' THEN 'Asian'
	WHEN d.index_entry ~ '(substance abuse)|(alcoholism)|(addiction)' THEN 'Substance Abuse & Addiction'
	WHEN d.index_entry ~ '(abuse)|(violence against)' THEN 'Abuse & Violence'
	WHEN d.index_entry ~ 'indigenous' THEN 'Indigenous'
	WHEN d.index_entry ~ 'hispanic' THEN 'Hispanic & Latino'
	WHEN d.index_entry ~ 'multicultural' THEN 'Multicultural'
	WHEN d.index_entry ~ '(arab)|(middle eastern)' THEN 'Arab & Middle Eastern'
	/*
	other collectionHQ subjects
	Black
	Disabilities & Special Needs
	Equity & Social Issues
	Mental & Emotional Health
	Own Voices
	Religion
	*/
END AS topic,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'j') AS juv_items,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) = 'y') AS ya_items,
COUNT(i.id) FILTER(WHERE SUBSTRING(i.location_code,4,1) NOT IN('y','j')) AS adult_items

FROM
sierra_view.item_record i
JOIN
sierra_view.bib_record_item_record_link l
ON
i.id = l.item_record_id
JOIN
sierra_view.phrase_entry d
ON
l.bib_record_id = d.record_id AND d.index_tag = 'd'
AND (d.index_entry ~ '(sexual minorities)|(gender)|(aesexual)|(bisexual)|(gay)|(intersex)|(homosexual)|(lesbian)'
OR d.index_entry ~ '(asians)|(asian americans)'
OR d.index_entry ~ '(substance abuse)|(alcoholism)|(addiction)'
OR d.index_entry ~ '(abuse)|(violence against)'
OR d.index_entry ~ 'indigenous'
OR d.index_entry ~ 'hispanic'
OR d.index_entry ~ 'multicultural'
OR d.index_entry ~ '(arab)|(middle eastern)')
GROUP BY 1
ORDER BY 1