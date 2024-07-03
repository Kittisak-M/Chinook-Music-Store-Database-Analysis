-- Create view in the rental table syn
CREATE View rental_list as
SELECT 
    ROW_NUMBER() OVER () AS row_num,
    c.first_name || ' ' || c.last_name as customer_name,
    f.title,
    ct.name as category,
    f.rating,
    CASE 
        WHEN (julianday(r.return_date) - julianday(r.rental_date)) > CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER) 
        THEN CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER) + 1 
        ELSE CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER)
    END AS return_days,
    f.rental_duration,
    f.rental_rate,    
    p.payment_date,
    f.replacement_cost,
    ci.city,
    cou.country
FROM rental AS r
LEFT JOIN payment AS p 
ON r.rental_id = p.rental_id
LEFT JOIN customer AS c 
ON r.customer_id = c.customer_id
LEFT JOIN inventory AS i 
ON i.inventory_id = r.inventory_id
LEFT JOIN film AS f 
ON f.film_id = i.film_id
LEFT JOIN film_category as fc
on fc.film_id = f.film_id
LEFT JOIN category as ct
ON ct.category_id = fc.category_id
LEFT JOIN address as ad
on ad.address_id = c.address_id
lEFT JOIN city as ci
on ci.city_id = ad.city_id
left join country as cou
on cou.country_id = ci.country_id


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

SELECT *
FROm rental_list


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

-- Drop the view tables
DROP VIEW IF EXISTS customer_list;
DROp VIEW IF EXISTS film_list
DROp VIEW IF EXISTS sales_by_film_category
DROp VIew IF EXISTS sales_by_store
DROp view IF EXISTS staff_list


