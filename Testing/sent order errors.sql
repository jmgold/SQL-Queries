--test for records sent more than twice
--add column with text saying sent x times
--add in orders that were not sent, older than x to avoid records in queue

SELECT
id2reckey(o.id)||'a' AS order_num,
COUNT(sent2.id)
FROM
sierra_view.order_record o
JOIN
sierra_view.varfield sent1
ON
o.id = sent1.record_id AND sent1.varfield_type_code = 'b' AND TO_DATE(SUBSTRING(sent1.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL AND sent1.occ_num = '0'
JOIN
sierra_view.varfield sent2
ON
o.id = sent2.record_id AND sent2.varfield_type_code = 'b' AND TO_DATE(SUBSTRING(sent2.field_content, '\d{2}\-\d{2}\-\d{4}'),'MM-DD-YYYY') IS NOT NULL AND sent1.occ_num != sent2.occ_num


WHERE
o.accounting_unit_code_num = '12'

GROUP BY 1