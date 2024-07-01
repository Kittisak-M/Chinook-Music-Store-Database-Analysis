-- rental
SELECT 
    r.rental_id,
    c.first_name || ' ' || c.last_name as customer_name,
    CASE 
        WHEN (julianday(r.return_date) - julianday(r.rental_date)) > CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER) 
        THEN CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER) + 1 
        ELSE CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER)
    END AS return_days,
    f.title,
    f.rating
FROM rental AS r
LEFT JOIN payment AS p
ON r.customer_id = p.customer_id
LEFT JOIN customer AS c
ON c.customer_id = p.customer_id
LEFT JOIN inventory as i
on i.inventory_id = r. inventory_id
LEFT JOIN film as f
on f.film_id = i.film_id

-- COUNT return_days
SELECT 
    CASE 
        WHEN (julianday(r.return_date) - julianday(r.rental_date)) > CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER) 
        THEN CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER) + 1 
        ELSE CAST((julianday(r.return_date) - julianday(r.rental_date)) AS INTEGER)
    END AS return_days,
    COUNT(*) AS count_return_days
FROM rental AS r
LEFT JOIN payment AS p
ON r.customer_id = p.customer_id
GROUP BY return_days;

