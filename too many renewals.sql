--Jeremy Goldstein
--Minuteman Library Network
--id's items that have been renewed too many times

SELECT
id2reckey(c.item_record_id)||'a' as inumber,
i.barcode,
c.loanrule_code_num,
c.checkout_gmt,
b.best_title,
c.renewal_count,
id2reckey(c.patron_record_id)||'a' as pnumber,
p.last_name||', '||p.first_name||' '||p.middle_name
FROM
sierra_view.checkout c
JOIN
sierra_view.item_record_property i
ON
c.item_record_id = i.item_record_id
JOIN
sierra_view.bib_record_item_record_link l
ON
i.item_record_id = l.item_record_id
JOIN
sierra_view.bib_record_property b
ON
l.bib_record_id = b.bib_record_id
JOIN
sierra_view.patron_record_fullname p
ON
c.patron_record_id = p.patron_record_id
WHERE
renewal_count > '7'