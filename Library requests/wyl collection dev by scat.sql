    --currently configured for last year to date figures
	 SELECT
    CASE
        WHEN icode1 = 1 THEN 'Adult Fiction'
        WHEN icode1 = 2 THEN 'Adult Mystery'
        WHEN icode1 = 3 THEN 'Adult Science Fiction'
        WHEN icode1 = 4 THEN 'LG PT'
        WHEN icode1 = 10 THEN 'Adult NF 100''s'
        WHEN icode1 = 11 THEN 'Adult NF 120''s'
        WHEN icode1 = 13 THEN 'Adult NF 130''s'
        WHEN icode1 = 14 THEN 'Adult NF 140''s'
        WHEN icode1 = 15 THEN 'Adult NF 150''s'
        WHEN icode1 = 16 THEN 'Adult NF 160''s'
        WHEN icode1 = 17 THEN 'Adult NF 170''s'
        WHEN icode1 = 18 THEN 'Adult NF 180''s'
        WHEN icode1 = 19 THEN 'Adult NF 190''s'
        WHEN icode1 = 20 THEN 'Adult NF 200''s'
        WHEN icode1 = 21 THEN 'Adult NF 210''s'
        WHEN icode1 = 22 THEN 'Adult NF 220''s'
        WHEN icode1 = 23 THEN 'Adult NF 230''s'
        WHEN icode1 = 24 THEN 'Adult NF 240''s'
        WHEN icode1 = 25 THEN 'Adult NF 250''s'
        WHEN icode1 = 26 THEN 'Adult NF 260''s'
        WHEN icode1 = 27 THEN 'Adult NF 270''s'
        WHEN icode1 = 28 THEN 'Adult NF 280''s'
        WHEN icode1 = 29 THEN 'Adult NF 290''s'
        WHEN icode1 = 30 THEN 'Adult NF 300''s'
        WHEN icode1 = 31 THEN 'Adult NF 310''s'
        WHEN icode1 = 32 THEN 'Adult NF 320''s'
        WHEN icode1 = 33 THEN 'Adult NF 330''s'
        WHEN icode1 = 34 THEN 'Adult NF 340''s'
        WHEN icode1 = 35 THEN 'Adult NF 350''s'
        WHEN icode1 = 36 THEN 'Adult NF 360''s'
        WHEN icode1 = 37 THEN 'Adult NF 370''s'
        WHEN icode1 = 38 THEN 'Adult NF 380''s'
        WHEN icode1 = 39 THEN 'Adult NF 390''s'
        WHEN icode1 = 40 THEN 'Adult NF 400''s'
        WHEN icode1 = 41 THEN 'Adult NF 410''s'
        WHEN icode1 = 42 THEN 'Adult NF 420''s'
        WHEN icode1 = 43 THEN 'Adult ESOL'
        WHEN icode1 = 44 THEN 'Adult NF 440''s'
        WHEN icode1 = 45 THEN 'Adult NF 450''s'
        WHEN icode1 = 46 THEN 'Adult NF 460''s'
        WHEN icode1 = 47 THEN 'Adult NF 470''s'
        WHEN icode1 = 48 THEN 'Adult NF 480''s'
        WHEN icode1 = 49 THEN 'Adult NF 490''s'
        WHEN icode1 = 50 THEN 'Adult NF 500''s'
        WHEN icode1 = 51 THEN 'Adult NF 510''s'
        WHEN icode1 = 52 THEN 'Adult NF 520''s'
        WHEN icode1 = 53 THEN 'Adult NF 530''s'
        WHEN icode1 = 54 THEN 'Adult NF 540''s'
        WHEN icode1 = 55 THEN 'Adult NF 550''s'
        WHEN icode1 = 56 THEN 'Adult NF 560''s'
        WHEN icode1 = 57 THEN 'Adult NF 570''s'
        WHEN icode1 = 58 THEN 'Adult NF 580''s'
        WHEN icode1 = 59 THEN 'Adult NF 590''s'
        WHEN icode1 = 60 THEN 'Adult NF 600''s'
        WHEN icode1 = 61 THEN 'Adult NF 610''s'
        WHEN icode1 = 62 THEN 'Adult NF 620''s'
        WHEN icode1 = 63 THEN 'Adult NF 630''s'
        WHEN icode1 = 64 THEN 'Adult NF 640''s'
        WHEN icode1 = 65 THEN 'Adult NF 650''s'
        WHEN icode1 = 66 THEN 'Adult NF 660''s'
        WHEN icode1 = 67 THEN 'Adult NF 670''s'
        WHEN icode1 = 68 THEN 'Adult NF 680''s'
        WHEN icode1 = 69 THEN 'Adult NF 690''s'
        WHEN icode1 = 70 THEN 'Adult NF 700''s'
        WHEN icode1 = 71 THEN 'Adult NF 710''s'
        WHEN icode1 = 72 THEN 'Adult NF 720''s'
        WHEN icode1 = 73 THEN 'Adult NF 730''s'
        WHEN icode1 = 74 THEN 'Adult NF 740''s'
        WHEN icode1 = 75 THEN 'Adult NF 750''s'
        WHEN icode1 = 76 THEN 'Adult NF 760''s'
        WHEN icode1 = 77 THEN 'Adult NF 770''s'
        WHEN icode1 = 78 THEN 'Adult NF 780''s'
        WHEN icode1 = 79 THEN 'Adult NF 790''s'
        WHEN icode1 = 80 THEN 'Adult NF 800''s'
        WHEN icode1 = 81 THEN 'Adult NF 810''s'
        WHEN icode1 = 82 THEN 'Adult NF 820''s'
        WHEN icode1 = 83 THEN 'Adult NF 830''s'
        WHEN icode1 = 84 THEN 'Adult NF 840''s'
        WHEN icode1 = 85 THEN 'Adult NF 850''s'
        WHEN icode1 = 86 THEN 'Adult NF 860''s'
        WHEN icode1 = 87 THEN 'Adult NF 870''s'
        WHEN icode1 = 88 THEN 'Adult NF 880''s'
        WHEN icode1 = 89 THEN 'Adult NF 890''s'
        WHEN icode1 = 90 THEN 'Adult NF 900''s'
        WHEN icode1 = 91 THEN 'Adult Travel and Adult NF 910''s'
        WHEN icode1 = 92 THEN 'Adult Biography and Adult NF 920''s'
        WHEN icode1 = 93 THEN 'Adult NF 930''s'
        WHEN icode1 = 94 THEN 'Adult NF 940''s'
        WHEN icode1 = 95 THEN 'Adult NF 950''s'
        WHEN icode1 = 96 THEN 'Adult NF 960''s'
        WHEN icode1 = 97 THEN 'Adult NF 970''s'
        WHEN icode1 = 98 THEN 'Adult NF 980''s'
        WHEN icode1 = 99 THEN 'Adult NF 990''s'
        WHEN icode1 = 100 THEN 'Adult NF 000''s'
        WHEN icode1 = 101 THEN 'Adult Periodicals'
        WHEN icode1 = 102 THEN 'Adult NF Computers'
        WHEN icode1 = 135 THEN 'Adult DVD'
        WHEN icode1 = 140 THEN 'Adult DVD NF'
        WHEN icode1 = 155 THEN 'Adult Book on CDs'
        WHEN icode1 = 159 THEN 'Adult DVD Series'
        WHEN icode1 = 161 THEN 'YA Fic (and Graphic Novels)'
        WHEN icode1 = 162 THEN 'YA NF'
        WHEN icode1 = 163 THEN 'Teen Fiction'
        WHEN icode1 = 164 THEN 'Teen NF'
        WHEN icode1 = 199 THEN 'CR Reference'
        WHEN icode1 = 201 THEN 'CR Advanced Picture Books (and 1-3 CR Fiction and CR Fiction and CR Graphic Novels)'
        WHEN icode1 = 206 THEN 'CR Picture Books (and Boardbooks and Holiday Books)'
        WHEN icode1 = 207 THEN 'CR (and YA) Media Player'
        WHEN icode1 = 208 THEN 'CR (and YA) Video Games (Wii, XBOX 360, PS3, DS)'
        WHEN icode1 = 209 THEN 'CR Easy Readers'
        WHEN icode1 = 210 THEN 'CR NF 000''s'
        WHEN icode1 = 211 THEN 'CR NF 100''s'
        WHEN icode1 = 212 THEN 'CR NF 200''s'
        WHEN icode1 = 213 THEN 'CR NF 300''s'
        WHEN icode1 = 214 THEN 'CR NF 400''s'
        WHEN icode1 = 215 THEN 'CR NF 500''s'
        WHEN icode1 = 216 THEN 'CR NF 600''s'
        WHEN icode1 = 217 THEN 'CR NF 700''s'
        WHEN icode1 = 218 THEN 'CR NF 800''s'
        WHEN icode1 = 219 THEN 'CR NF 900''s'
        WHEN icode1 = 220 THEN 'CR Biography'
        WHEN icode1 = 221 THEN 'Adult Media Player'
        WHEN icode1 = 227 THEN 'Adult CD Music'
        WHEN icode1 = 230 THEN 'Museum Passes'
        WHEN icode1 = 234 THEN 'Adult VHS Video'
        WHEN icode1 = 239 THEN 'Adult Reference'
        ELSE icode1::VARCHAR
    END AS "Scat",
    COUNT (item_record.id) AS "Item total",
    round(cast(count(item_record.id) as numeric (12,2)) / (select cast(count (item_record.id) as numeric (12,2))from sierra_view.item_record JOIN sierra_view.record_metadata ON item_record.id = record_metadata.id AND record_metadata.creation_date_gmt::DATE < '2022-07-01' where location_code LIKE 'wyl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd')), 6) as relative_item_total,
    /*
	 SUM(checkout_total) + SUM(renewal_total) AS "Total_Circulation",
    round(cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) / (SELECT cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2)) from sierra_view.item_record where location_code LIKE 'wyl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd')), 6) as relative_circ,
    round(cast(SUM(checkout_total) + SUM(renewal_total) as numeric (12,2))/cast(count (id) as numeric (12,2)), 2) as turnover
    */
	 SUM(last_year_to_date_checkout_total) AS "Total_Circulation",
    round(cast(SUM(last_year_to_date_checkout_total) as numeric (12,2)) / (SELECT cast(SUM(last_year_to_date_checkout_total) as numeric (12,2)) from sierra_view.item_record JOIN sierra_view.record_metadata ON item_record.id = record_metadata.id AND record_metadata.creation_date_gmt::DATE < '2022-07-01' where location_code LIKE 'wyl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd')), 6) as relative_circ,
    round(cast(SUM(last_year_to_date_checkout_total) as numeric (12,2))/cast(count (item_record.id) as numeric (12,2)), 2) as turnover
    FROM
    sierra_view.item_record
    JOIN
    sierra_view.record_metadata
    ON
    item_record.id = record_metadata.id AND record_metadata.creation_date_gmt::DATE < '2022-07-01'
    WHERE location_code LIKE 'wyl%' and item_status_code not in ('o', 'n', '$', 'w', 'z', 'd')
    GROUP BY icode1
    ORDER BY icode1