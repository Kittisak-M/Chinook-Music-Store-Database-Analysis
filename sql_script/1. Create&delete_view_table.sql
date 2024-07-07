/* START */
-- Create Day Return Count as a table view
CREATE VIEW days_rn_cnt AS 
    SELECT  rental_duration - return_days AS days_rn,
       		COUNT(*) AS day_rn_cnt
    FROM rental_list
    GROUP BY days_rn
/* END */    

/* START */
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
/* END */
     
/* Start */     
-- Drop the view tables
DROP VIEW IF EXISTS customer_list;
/* END */

/* START */
DROp VIEW IF EXISTS film_list
/* END */

/* START */
DROp VIEW IF EXISTS sales_by_film_category
/* END */

/* START */
DROp VIew IF EXISTS sales_by_store
/* END */

/* START */
DROp view IF EXISTS staff_list
/* END */

/* START */
DROp view IF EXISTS customer_list
/* END */























