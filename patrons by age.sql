--Jeremy Goldstein
--Minuteman Library Network

--Counts patrons by age within a ptype

SELECT
date_part('year',AGE(localtimestamp,birth_date_gmt)) as age,
count(id)
from
sierra_view.patron_record
where
ptype_code = '40'
GROUP BY 1
ORDER By 1 desc