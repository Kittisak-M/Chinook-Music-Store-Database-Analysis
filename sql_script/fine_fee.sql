/* START */
SELECT *
FROm rental_list
/* END */
	
/* START */
-- Count the number of times DVDs were returned to the stores based on the rental duration.
-- By calculating the difference between return days and rental duration,
-- and count the occurrences for each difference
WITH counts AS (
    SELECT  return_days - rental_duration  AS days_rn,
       		COUNT(*) AS day_rtn_cnt 
    FROM rental_list
    GROUP BY days_rn
                )
SELECT days_rn,
   	   day_rtn_cnt,
       SUM(day_rtn_cnt) OVER(ORDER BY days_rn) as running_total,
       ROUND(CAST(day_rtn_cnt AS FLOAT) / (SELECT CAST(SUM(day_rtn_cnt) AS FLOAT) 
                                          FROM counts) * 100,2)|| ' %' AS pct_total
FROM counts
/* END */

/* START */
-- Fine 0.5 dollar a day to the customers who don't return the Dvds on time
WITH counts AS (
    SELECT  return_days - rental_duration AS days_rn,
       		COUNT(*) AS day_rn_cnt
    FROM rental_list
    GROUP BY days_rn
                )
SELECT days_rn,
	   ABS(days_rn * 0.5 * day_rn_cnt) as exp_rev_increase -- 0.5 dollar   
FROM Counts
WHERE days_rn > 0 
/* END */

/* START */
-- table of revenue increase if we fine a customer in various values a day         
SELECT days_rn,
	   ABS(days_rn * 0.25 * day_rn_cnt) as exp_rev_increase_025, -- 0.25 dollar
       ABS(days_rn * 0.50 * day_rn_cnt) as exp_rev_increase_05,-- 0.5 dollar
       ABS(days_rn * 0.75 * day_rn_cnt) as exp_rev_increase_075-- 0.5 dollar       
FROM days_rn_cnt
WHERE days_rn > 0 
/* END */

/* START */
--Fine customers with various value.
With fine_fee as (SELECT days_rn,
	   ABS(days_rn * 0.25 * day_rn_cnt) as exp_rev_increase_025, -- 0.25 dollar
       ABS(days_rn * 0.50 * day_rn_cnt) as exp_rev_increase_05,  -- 0.5 dollar
       ABS(days_rn * 0.75 * day_rn_cnt) as exp_rev_increase_075  -- 0.75 dollar       
FROM days_rn_cnt
WHERE days_rn > 0)
/* END */

/* START */
--Table of revenue increment in each fine fee
SELECT SUM(exp_rev_increase_025) As fine_25_cents,
	   SUM(exp_rev_increase_05) As fine_50_cents,
       SUM(exp_rev_increase_075)  As fine_75_cents
FROM fine_fee
/* END */

/* START */
-- Revenue rank by category and rating
SElECT category,
	   rating,
       ROUND(SUM(rental_rate),2) as revenue,
       RANK() OVER(ORDER By sum(rental_rate) DESC) As all_rank,
       RANK() OVER(PARTITION BY category ORDER BY sum(rental_rate) DESC) as category_rank
FROM rental_list
GROUP By category, rating
ORDER by category DESC
/* END */

/* START */
SELECT COUNT(DISTINCT CITY) as city_cnt
FROM rental_list
/* END */

/* START */
SELECT COUNT(DISTINCT country) as country_cnt
FROM rental_list
/* END */

/* START */
--Revenue by country and city
SELECT country,
	   city,
       ROUND(sum(rental_rate),2 ) || ' $' as revenue
FROM rental_list
GROUP by country, city
ORDER By country DESC
/* END */

-- Select movie that makes revenue higher than average
SELECT title,
	   SUM(rental_rate) as rev
FROM rental_list
GROUP By title
HAVING  rev > AVG(rental_rate)
ORDER BY rev DESC

/* START*/
SELECT AVG(rental_rate)
FROM rental_list
/* END */

/* START */
-- Filter high selling movie being more than average selling
SELECT title,
       SUM(rental_rate) AS revenue
FROM rental_list
GROUP BY title
HAVING SUM(rental_rate) > (SELECT AVG(rental_rate) FROM rental_list)
ORDER BY rev DESC;
/* END */

/* START */
-- Filter high selling movie (percentile 80th above)
WITH rental_revenue AS (
    SELECT title,
           SUM(rental_rate) AS total_revenue
    FROM rental_list
    GROUP BY title
),
percentile_calculation AS (
    SELECT total_revenue,
           PERCENT_RANK() OVER (ORDER BY total_revenue) AS percentile
    FROM rental_revenue
),
percentile_80_value AS (
    SELECT total_revenue
    FROM percentile_calculation
    WHERE percentile >= 0.80
    ORDER BY total_revenue
    LIMIT 1
)
SELECT title,
       total_revenue AS rev
FROM rental_revenue
WHERE total_revenue > (SELECT total_revenue FROM percentile_80_value)
ORDER BY total_revenue DESC;
/* END */
