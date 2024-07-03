-- Create Day Return Count as a table view
CREATE VIEW days_rn_cnt AS 
    SELECT  rental_duration - return_days AS days_rn,
       		COUNT(*) AS day_rn_cnt
    FROM rental_list
    GROUP BY days_rn
                
SELECT days_rn,
	   ABS(days_rn * 0.25 * day_rn_cnt) as exp_rev_increase_025, -- 0.25 dollar
       ABS(days_rn * 0.50 * day_rn_cnt) as exp_rev_increase_05,-- 0.5 dollar
       ABS(days_rn * 0.75 * day_rn_cnt) as exp_rev_increase_075-- 0.5 dollar       
FROM days_rn_cnt
WHERE days_rn < 0 

--If we fine customer with various number who lately return dvd
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

SElECT category,
	   rating,
       sum(rental_rate) as rev,
       RANK() OVER(ORDER By sum(rental_rate) DESC),
       RANK() OVER(PARTITION BY category ORDER BY sum(rental_rate) ASC)
FROM rental_list
GROUP By category, rating
HAVING category = 'Music'
ORDER by REV DESC























