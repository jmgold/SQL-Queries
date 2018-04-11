--Jeremy Goldstein
--Minuteman Library Network

-- finds average price for an item by year
SELECT
  date_part('year', record_creation_date_gmt) AS "year",
  (sum(price) / count(*)) AS "avg price"
FROM sierra_view.item_view
--Limit to a location
where agency_code_num = '30'
group by 1
Order by 1;
