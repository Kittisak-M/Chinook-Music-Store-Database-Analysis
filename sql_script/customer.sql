/* START */
-- Number of customers visiting the shops in each hour(Year 2005)
SELECT strftime('%H', payment_date) as hour, COUNT(*) as num_of_customers
FROM rental_list
WHERE strftime('%Y', payment_date) = '2005'
GROUP BY strftime('%H', payment_date)
ORDER BY hour ASC 
/* END */

/* START */
-- Peak customers hours in year 2005
SELECT strftime('%H', payment_date) as hour_num, 
	   COUNT(*) as num_of_customers
FROM rental_list
WHERE strftime('%Y', payment_date) = '2005'
GROUP BY strftime('%H', payment_date)
ORDER BY num_of_customers desc 
LIMIT 5
/* END */

/* START */
-- Percentage change table
WITH 
  unique_cust_month AS (
    SELECT strftime('%m', payment_date) || '-2005' AS month, 
           COUNT(DISTINCT customer_name) AS num_of_customers
    FROM rental_list
    WHERE strftime('%Y', payment_date) = '2005'
    GROUP BY strftime('%m', payment_date)
  ),
  cust_month AS (
    SELECT strftime('%m', payment_date) || '-2005' AS month, 
           COUNT(*) AS num_of_customers
    FROM rental_list
    WHERE strftime('%Y', payment_date) = '2005'
    GROUP BY strftime('%m', payment_date)
  ),
  rev_month AS (
    SELECT strftime('%m', payment_date) || '-2005' AS month, 
           SUM(rental_rate) AS rev_by_month
    FROM rental_list
    WHERE strftime('%Y', payment_date) = '2005'
    GROUP BY strftime('%m', payment_date)
  )
SELECT 
  cm.month,
  cm.num_of_customers AS num_cust,
  IFNULL(ROUND((cm.num_of_customers - LAG(cm.num_of_customers) OVER()) * 100.0 / LAG(cm.num_of_customers) OVER(), 2) || '%','-') AS customers_pct_chg,
  ROUND(rm.rev_by_month, 2) AS rev_by_month,
  IFNULL(ROUND((rm.rev_by_month - LAG(rm.rev_by_month) OVER()) * 100.0 / LAG(rm.rev_by_month) OVER(), 2) || '%','-') AS rev_pct_chg,
  uc.num_of_customers AS num_uniq_cust,
  IFNULL(ROUND((uc.num_of_customers - LAG(uc.num_of_customers) OVER()) * 100.0 / LAG(uc.num_of_customers) OVER(), 2) || '%','-') AS asd
FROM 
  cust_month AS cm
LEFT JOIN 
  rev_month AS rm ON cm.month = rm.month
LEFT JOIN 
  unique_cust_month AS uc ON uc.month = cm.month;
/* END */
  
/* START */
-- Revenue and the number of customers by month year
SELECT strftime('%m', payment_date) || '-' ||strftime('%Y', payment_date) AS month,
	   SUM(rental_rate) as revenue,
       COUNT(*) AS num_of_customers,
       COUNT(DISTINCT customer_name) AS num_of_unique_customers
FROM rental_list
GROUP BY strftime('%m', payment_date),strftime('%Y', payment_date)
/* END */

/* START */
-- Customer who return to rent in August
SELECT DISTINCT customer_id
FRom payment
WHERe strftime('%m', payment_date) = '07'
INTERSECT  
SELECT DISTINCT customer_id	   
FRom payment
WHERe strftime('%m', payment_date) = '08'
/* END */

/* START */
-- Customer who rent in May and return to rent the Dvds in July and August
SELECT DISTINCT customer_id
FRom payment
WHERe strftime('%m', payment_date) = '05'
INTERSECT  
SELECT DISTINCT customer_id	   
FRom payment
WHERe strftime('%m', payment_date) = '07'
INTERSECT  
SELECT DISTINCT customer_id	   
FRom payment
WHERe strftime('%m', payment_date) = '08'
/* END */

/* START */
with customer_cnt as(
SELECT DISTINCT customer_id
FRom payment
WHERe strftime('%m', payment_date) = '07'
INTERSECT  
SELECT DISTINCT customer_id	   
FRom payment
WHERe strftime('%m', payment_date) = '08'
  					 )
SELECT COUNT(*)
FROM customer_cnt
/* END */

/* START */
-- Retention rate in July and August
WITH July AS(SELECT DISTINCT customer_id
FRom payment
WHERe strftime('%m', payment_date) = '07'
),   Aug as(
SELECT DISTINCT customer_id	   
FRom payment
WHERe strftime('%m', payment_date) = '08')

SELECT COUNT(a.customer_id) / COUNT(J.customer_id) * 100 || '%' As retentionR_July_Aug_2005
FRom July as j
LEFT JOIN Aug as a
on j.customer_id = a.customer_id
/* END */

