--
SELECT strftime('%H', payment_date), COUNT(*)
FROM rental_list
WHERE strftime('%Y', payment_date) = '2005'
GROUP BY strftime('%H', payment_date)

-- Number of customers visiting the shops in each hour
SELECT strftime('%H', payment_date) as hour, COUNT(*) as num_of_customers
FROM rental_list
WHERE strftime('%Y', payment_date) = '2005'
GROUP BY strftime('%H', payment_date)
ORDER BY hour ASC 

-- Peak customers hours in year 2005
SELECT strftime('%H', payment_date), 
	   COUNT(*) as num_of_customers
FROM rental_list
WHERE strftime('%Y', payment_date) = '2005'
GROUP BY strftime('%H', payment_date)
ORDER BY num_of_customers desc 
LIMIT 5

--
WITH 
 cust_month AS (
  SELECT strftime('%m', payment_date) as month, 
       	 COUNT(*) as num_of_customers
  FROM rental_list
  GROUP BY strftime('%m', payment_date)
  ORDER BY month ASC
               ),
  rev_month AS (
  SELECT strftime('%m', payment_date) as month, 
       	 SUM(rental_rate) as rev_by_month
  FROM rental_list
  GROUP BY strftime('%m', payment_date)
  ORDER BY month ASC
             )
SELECT month,
	   cm.number_of_customers,
       rm.rev_by_month
FROM cust_month as cm
LEFT JOIN rev_month AS rm

-- lastest
WITH 
  cust_month AS (
    SELECT strftime('%m', payment_date) AS month, 
           COUNT(*) AS num_of_customers
    FROM rental_list
    GROUP BY strftime('%m', payment_date)
  ),
  rev_month AS (
    SELECT strftime('%m', payment_date) AS month, 
           SUM(rental_rate) AS rev_by_month
    FROM rental_list
    GROUP BY strftime('%m', payment_date)
  )
SELECT 
  cm.month,
  cm.num_of_customers AS number_of_customers,
  COALESCE(rm.rev_by_month, 0) AS rev_by_month
FROM 
  cust_month cm
LEFT JOIN 
  rev_month rm ON cm.month = rm.month
ORDER BY 
  cm.month ASC;

SELECT r
FROM rental_list
