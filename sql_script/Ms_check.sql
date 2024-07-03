SELECT *
FROM payment

-- Count missing value in the payment table
SELECT SUM(CASE WHEN payment_id is NULL then 1 else 0 end) as ms_cnt_payment_id,
	   SUM(CASE WHEN customer_id is NULL then 1 else 0 end) as ms_cnt_customer_id,
       SUM(CASE WHEN staff_id is NULL then 1 else 0 end) as ms_cnt_staff_id,
       SUM(CASE WHEN rental_id is NULL then 1 else 0 end) as ms_cnt_rental_id,
       SUM(CASE WHEN amount is NULL then 1 else 0 end) as ms_cnt_amount,
       SUM(CASE WHEN payment_date is NULL then 1 else 0 end) as ms_cnt_payment_date
FROM payment

--Query to check missing value in the rental_id column
SELECT *
FROm payment
WHERE rental_id IS NULL

SELECT *
FROm film

--Count rows in the film table
SELECT COUNT(*)
FROm film

--Check missing values in the film table
SELECT SUM(CASE WHEN film_id is NULL then 1 else 0 end) as ms_cnt_film_id,
       SUM(CASE WHEN title is NULL then 1 else 0 end) as ms_cnt_title,
       SUM(CASE WHEN description is NULL then 1 else 0 end) as ms_cnt_description,
       SUM(CASE WHEN release_year is NULL then 1 else 0 end) as ms_cnt_release_year,
       SUM(CASE WHEN language_id is NULL then 1 else 0 end) as ms_cnt_language_id,
       SUM(CASE WHEN Original_language_id is NULL then 1 else 0 end) as ms_cnt_original_language_id,
       SUM(CASE WHEN rental_duration is NULL then 1 else 0 end) as ms_cnt_rental_duration,
       SUM(CASE WHEN length is NULL then 1 else 0 end) as ms_cnt_length,
       SUM(CASE WHEN replacement_cost is NULL then 1 else 0 end) as ms_cnt_replacement_cost,
       SUM(CASE WHEN rating is NULL then 1 else 0 end) as ms_cnt_rating,
       SUM(CASE WHEN special_features is NULL then 1 else 0 end) as ms_cnt_special_features
FROM film
       
