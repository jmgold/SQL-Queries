-- total orders created per month
SELECT
  case date_part ('month', order_date_gmt)   
  when '01'    then 'January'     
  when '02'    then 'February'  
  when '03'    then 'March'  
  when '04'    then 'April'  
  when '05'    then 'May'  
  when '06'    then 'June'  
  when '07'    then 'July' 
  when '08'    then 'August'  
  when '09'    then 'September'  
  when '10'    then 'October'  
  when '11'    then 'November'  
  when '12'    then 'December'          
  end AS "month",
  count (*) AS "total"
FROM sierra_view.order_view
WHERE date_part('year', order_date_gmt) = 2015
Group by 1
Order by 2 desc;