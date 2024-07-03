SELECT *
FROm payment

-- Retrieve the earliest (minimum) and latest (maximum) payment dates from the payment table
SELECT MIN(payment_date),
       MAX(payment_date)
FROM payment

-- Calculate top spending
SELECT customer_id,
	   ROUND(SUM(AMOUNT), -2) || '$' AS total_spending
FROM payment
GROUP By customer_id
Order By total_spending ASC


