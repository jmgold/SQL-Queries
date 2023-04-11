WITH RECURSIVE 
    smoothed_data (date, transaction_count, smoothed_count) AS (
        SELECT 
            t.transaction_gmt::DATE AS date, 
            COUNT(t.id) AS transaction_count, 
            AVG(COUNT(t.id)) OVER (ORDER BY t.transaction_gmt::DATE ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS smoothed_count
        FROM 
            circ_trans t
        WHERE t.op_code = 'o'
        GROUP BY 1
		   
    ),
    forecast (date, forecast_count) AS (
        SELECT 
            (SELECT MAX(DATE) FROM smoothed_data) + interval '1 day', 
            smoothed_count
        FROM 
            smoothed_data
        UNION ALL
        SELECT 
            forecast.date + interval '1 day', 
            (.2/*alpha*/ * transaction_count) + ((1 - .2/*alpha*/) * forecast_count)
        FROM 
            forecast 
            JOIN smoothed_data ON forecast.date = smoothed_data.date
        WHERE 
            forecast.date < (SELECT MAX(t.transaction_gmt::DATE) FROM sierra_view.circ_trans t) + interval '30 days'
    )
SELECT 
    date, 
    forecast_count 
FROM 
    forecast 
WHERE 
    date > (SELECT MAX(t.transaction_gmt::DATE) FROM sierra_view.circ_trans t)
ORDER BY 
    date;