-- Create Day Return Count as a table view
CREATE VIEW days_rn_cnt AS 
    SELECT  rental_duration - return_days AS days_rn,
       		COUNT(*) AS day_rn_cnt
    FROM rental_list
    GROUP BY days_rn
    
-- table of revenue increase if we fine a customer in various values a day         
SELECT days_rn,
	   ABS(days_rn * 0.25 * day_rn_cnt) as exp_rev_increase_025, -- 0.25 dollar
       ABS(days_rn * 0.50 * day_rn_cnt) as exp_rev_increase_05,-- 0.5 dollar
       ABS(days_rn * 0.75 * day_rn_cnt) as exp_rev_increase_075-- 0.5 dollar       
FROM days_rn_cnt
WHERE days_rn < 0 

--If we fine customer with various value of money who lately return dvd
With fine_fee as (SELECT days_rn,
	   ABS(days_rn * 0.25 * day_rn_cnt) as exp_rev_increase_025, -- 0.25 dollar
       ABS(days_rn * 0.50 * day_rn_cnt) as exp_rev_increase_05,  -- 0.5 dollar
       ABS(days_rn * 0.75 * day_rn_cnt) as exp_rev_increase_075  -- 0.75 dollar       
FROM days_rn_cnt
WHERE days_rn < 0)

SELECT SUM(exp_rev_increase_025),
	   SUM(exp_rev_increase_05),
       SUM(exp_rev_increase_075)
FROM fine_fee

SELECT *
FROM rental_list

-- Revenue rank by category and rating
SElECT category,
	   rating,
       ROUND(SUM(rental_rate),2) as revenue,
       RANK() OVER(ORDER By sum(rental_rate) DESC) As all_rank,
       RANK() OVER(PARTITION BY category ORDER BY sum(rental_rate) DESC) as category_rank
FROM rental_list
GROUP By category, rating
ORDER by category DESC

SELECT COUNT(DISTINCT CITY)
FROM rental_list

SELECT COUNT(DISTINCT country)
FROM rental_list

--Revenue by country and city
SELECT country,
	   city,
       sum(rental_rate) as rev
FROM rental_list
GROUP by country, city
ORDER By country DESC

-- Select movie that makes revenue higher than average
SELECT title,
	   SUM(rental_rate) as rev
FROM rental_list
GROUP By title
HAVING  rev > AVG(rental_rate)
ORDER BY rev DESC

SELECT AVG(rental_rate)
FROM rental_list

-- Filter high selling movie being more than average selling
SELECT title,
       SUM(rental_rate) AS rev
FROM rental_list
GROUP BY title
HAVING SUM(rental_rate) > (SELECT AVG(rental_rate) FROM rental_list)
ORDER BY rev DESC;

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














