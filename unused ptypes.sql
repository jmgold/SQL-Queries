-- ==================================================================

-- SELECT Item Type Codes that are not being used for any items

-- Brent Searle. Langara College. 2016-07-06

-- ==================================================================


SELECT

  ptprop.value                        AS "Ptype Code",

  ptname.description                  AS "Ptype Name",

  SUM (

    CASE

      WHEN p.ptype_code IS NULL THEN 0

      ELSE 1

    END

  )                                   AS "Patron Count"

FROM

  sierra_view.ptype_property          AS ptprop

JOIN

  sierra_view.ptype_property_name     AS ptname

  ON

  ptname.ptype_id = ptprop.id

  AND

  -- Code description is in English.

  -- Change the language code number

  -- for code descriptions in other

  -- languages in your system

  ptname.iii_language_id = '1'

LEFT JOIN

  sierra_view.patron_record           AS p

  ON

  p.ptype_code = ptprop.value

GROUP BY

  -- group by columns 1 and 2

  1,2

HAVING

  -- limit result to codes that are

  -- not currently in use by patron records

  SUM (

    CASE

      WHEN p.ptype_code IS NULL THEN 0

      ELSE 1

    END

  ) = 0

ORDER BY

  -- sort by ptype code

  ptprop.value

;
