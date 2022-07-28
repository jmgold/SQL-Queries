/*
check digit generator function
Created by Ray Voelker and shared on Sierra-ILS Slack Workspace 5/29/19
*/

DELIMITER // CREATE OR REPLACE FUNCTION pg_temp.rec2check(rec_num INTEGER) RETURNS CHAR AS $$
DECLARE
    a TEXT[]; 
    counter INTEGER; 
    agg_sum INTEGER; 
BEGIN
    SELECT regexp_split_to_array($1::VARCHAR, '') INTO a;
    -- counter is what we're multiplying by
    counter := 2; 
    agg_sum := 0; 
    FOR i IN REVERSE array_length(a, 1)..1 LOOP
        agg_sum := agg_sum + (a[i]::INTEGER * counter); 
        counter := counter + 1; 
    END LOOP; 

    IF (agg_sum % 11) = 10 THEN
        RETURN 'x'; 
    ELSE
        RETURN agg_sum % 11; 
    END IF; 

END;
$$ LANGUAGE plpgsql;


-- CHECK EXAMPLE #1
-- https://techdocs.iii.com/sierrahelp/Default.htm#sril/sril_records_numbers.html?Highlight=check%20digit
-- the check digit from the example record number of "1024364" is "1"
-- SELECT 
-- pg_temp.rec2check(1024364)
-- ;


-- CHECK EXAMPLE #2
SELECT
r.record_type_code || r.record_num || pg_temp.rec2check(r.record_num) AS record_num
FROM
sierra_view.record_metadata AS r
WHERE
r.record_type_code || r.campus_code = 'b'
LIMIT 100;