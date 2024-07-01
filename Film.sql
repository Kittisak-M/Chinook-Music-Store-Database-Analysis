-- Explore movies in the database
SELECT *
FROM film as f

-- Count number of movies in each category
SELECT rating,
	   COUNT(rating) as movies_count,
       ROUND(AVG(rental_duration),2) as avg_rental_duration,
       ROUND(AVG(length),2) as avg_length
FRom film
GROUP BY rating
Order by COUNT(rating) DESC

-- Explore the film table
SELECT f.title,
	   f.description,
       f.release_year,
       c.name,
       f.rental_duration,
       f.rental_rate,
       f.length,
       f.replacement_cost,
       f.rating
FROM film as f
LEFT JOIN language as l
ON f.language_id = f.language_id
LEFT JOIN film_category as fc
on fc.film_id = f.film_id
left join category as c
on fc.category_id = c.category_id

--Count movies categorized by length
WIth film_al AS(SELECT f.title,
					   f.description,
   				    f.release_year,
       c.name,
       f.rental_duration,
       f.rental_rate,
       f.length,
       f.replacement_cost,
       f.rating
FROM film as f
LEFT JOIN language as l
ON f.language_id = f.language_id
LEFT JOIN film_category as fc
on fc.film_id = f.film_id
left join category as c
on fc.category_id = c.category_id)


--Count movies categorized by length
WITH m_length AS (
SELECT 
		title,
        CASE 
        	WHEN length < 60  Then 'Short'
            WHEN length < 90  Then 'Medium'
            Else 'Long' End movie_length
FROM film)

SELECT m_length.movie_length,
	   COUNT(*) as movies_count
FROM m_length
GROUP BY movie_length

-- COUNT number of movies in each category with revenue
SELECT f.title,
	   p.amount,
 	   p.payment_date,
       c.name
FROM payment as p
LEFT JOIN rental as r
on r.rental_id = p.rental_id
LEFT JOIN inventory as i
on i.inventory_id = r.inventory_id
LEFT JOIN film as f
on f.film_id = i.film_id
LEFT JOIn film_category as fc
on f.film_id = fc.film_id
LEFT JOIN category as c
on c.category_id = fc.category_id
WHERe p.customer_id IN (SELECT *
                FROM payment
                WHERE p.customer_id = 1)


