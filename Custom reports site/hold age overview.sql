/*
Jeremy Goldstein
Minuteman Library Network

Report provides a variety of metrics for analyzing the current hold wait time for segments of the collection
Report is based on data currently in the holds table only, so cannot pull in data for holds that have been fulfilled
*/

SELECT
  *,
  '' AS "HOLD AGE OVERVIEW",
  '' AS "https://sic.minlib.net/reports/94"
FROM (
  SELECT
  {{grouping}} AS "grouping",
  /* possible options are
  EXTRACT(YEAR FROM AGE(rm.creation_date_gmt::DATE))||' Years' --age of title in years since creation date
  ptype.name --ptype
  loc.name --pickup location
  m.name --bibliographic material type */
  COUNT(DISTINCT h.id) AS total_holds_count,
  ROUND(AVG(CURRENT_DATE - h.placed_gmt::DATE)) AS avg_days_on_hold,
  MODE() WITHIN GROUP (ORDER BY (CURRENT_DATE - h.placed_gmt::DATE)) AS mode_days_on_hold,
  ROUND(percentile_cont(0.5) WITHIN GROUP (ORDER BY (CURRENT_DATE - h.placed_gmt::DATE))) AS median_days_on_hold,
  MAX(CURRENT_DATE - h.placed_gmt::DATE) AS max_days_on_hold,
  COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '1 day') "count_placed_in_last_day",
  COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '1 week') "count_placed_in_last_week",
  COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '1 month') "count_placed_in_last_month",
  COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '3 months') "count_placed_in_last_quarter",
  COUNT(DISTINCT h.id) FILTER (WHERE h.placed_gmt::DATE >= CURRENT_DATE - INTERVAL '1 year') "count_placed_in_last_year"

  FROM sierra_view.hold h
  JOIN sierra_view.bib_record_item_record_link AS l
    ON h.record_id = l.bib_record_id
	 OR h.record_id = l.item_record_id
  JOIN sierra_view.bib_record_property b
    ON l.bib_record_id = b.bib_record_id
  JOIN sierra_view.material_property_myuser m
    ON b.material_code = m.code
  JOIN sierra_view.location_myuser loc
    ON SUBSTRING(h.pickup_location_code,1,3) = loc.code
  JOIN sierra_view.patron_record p
    ON h.patron_record_id = p.id
  JOIN sierra_view.ptype_property_myuser ptype
    ON p.ptype_code = ptype.value
  JOIN sierra_view.record_metadata rm
    ON b.bib_record_id = rm.id

  WHERE m.code NOT IN ('b','h','l','w','s','y')
    AND h.pickup_location_code ~ {{pickup_location}}
    --pickup location takes the form of ^abc indicating the start of a location code
    --optionally chose to exclude frozen holds from report calculations
    {{#if Exclude}}
    AND h.is_frozen = FALSE
    {{/if Exclude}}

  GROUP BY 1
)a
ORDER BY SUBSTRING(grouping FROM '([0-9]+)')::INT,grouping