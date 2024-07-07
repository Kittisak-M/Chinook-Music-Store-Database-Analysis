/* START */
-- Count number of customers who return the item back in days
SELECT 
    CASE 
        WHEN (julianday(r.return_date) - julianday(r.rental_date)) > CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER) 
        THEN CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER) + 1 
        ELSE CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER)
    END AS return_days,
    COUNT(*) AS return_days_cnt
FROM rental AS r
LEFT JOIN payment AS p
ON r.customer_id = p.customer_id
GROUP BY return_days;
/* END */

/* START */
SELECT *
FROm rental_list
/* END */
	
/* START */
-- Count occurrences of each unique difference between rental_duration and return_days
WITH counts AS (
    SELECT  rental_duration - return_days AS days_rn,
       		COUNT(*) AS day_rn_cnt
    FROM rental_list
    GROUP BY days_rn
                )
SELECT days_rn,
   	   day_rn_cnt,
       ROUND(CAST(day_rn_cnt AS FLOAT) / (SELECT CAST(SUM(day_rn_cnt) AS FLOAT) FROM counts) * 100,2)|| ' %' AS pct_total
FROM counts
/* END */



-- What if we fine 0.50 per day
WITH counts AS (
    SELECT  rental_duration - return_days AS days_rn,
       		COUNT(*) AS day_rn_cnt
    FROM rental_list
    GROUP BY days_rn
                )
SELECT days_rn,
	   ABS(days_rn * 0.5 * day_rn_cnt) as exp_rev_increase -- 0.5 dollar   
FROM Counts
WHERE days_rn < 0 

-- What if we fine 0.50 per day
WITH counts AS (
    SELECT  rental_duration - return_days AS days_rn,
       		COUNT(*) AS day_rn_cnt
    FROM rental_list
    GROUP BY days_rn
                )
SELECT sum(day_rn_cnt)
FROM counts
where days_rn 


