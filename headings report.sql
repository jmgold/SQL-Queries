/*
Case statement shared by David W. Green on Sierra_ILS slack channel 7/12/21
*/

SELECT
CASE
WHEN condition_code_num = '1' THEN 'Used for first time'
WHEN condition_code_num = '2' THEN 'Invalid'
WHEN condition_code_num = '3' THEN 'Duplicate Entry'
WHEN condition_code_num = '4' THEN 'Blind Reference'
WHEN condition_code_num = '5' THEN 'Duplicate Authority'
WHEN condition_code_num = '6' THEN 'Updated Heading'
WHEN condition_code_num = '7' THEN 'Near Match'
WHEN condition_code_num = '8' THEN 'Busy Record'
WHEN condition_code_num = '9' THEN 'Non-Unique 4XX'
WHEN condition_code_num = '10' THEN 'Cross-Thesaurus'
WHEN condition_code_num = '11' THEN 'Missing Form or |8'
WHEN condition_code_num = '12' THEN 'Missing Form 2'
END AS condition,
*
FROM
sierra_view.catmaint C

LIMIT 1000