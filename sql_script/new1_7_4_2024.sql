-- Use CTEs to create number of customers and revenue in tables
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
  



