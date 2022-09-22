-- PRACTICING JOINS

-- 1. Write a query to join the order_items table with the products table. So for each order, it will return both the product_id, as well as its name,
-- followed by the quantity and the unit_price from the order_items table.
SELECT
	oi.order_id,
    p.product_id,
    p.name,
    oi.quantity,
    oi.unit_price
FROM sql_store.order_items oi
JOIN sql_store. products p
	ON oi.product_id = p.product_id;
    
-- 2. Write a query to join payments table with the payment_method table together, with the clients table. produce a report that shows the payment with
-- much details as well as the name of the clientand payment method.
SELECT
	c.name AS client_name,
    c.city,
    c.state,
    c.phone,
    p.amount,
    pm.name AS payment_method
FROM sql_invoicing.payments p
JOIN sql_invoicing.payment_methods pm
	ON p.payment_method = pm.payment_method_id
JOIN sql_invoicing.clients c
	ON c.client_id = p.client_id;
    
-- 3. Write a query that returns all the values in the products table, with the order_items table
SELECT
	p.product_id,
	p.name AS product_name,
    oi.quantity,
    oi.unit_price
FROM sql_store.products p
LEFT JOIN sql_store.order_items oi
	ON p.product_id = oi.product_id
ORDER BY product_id;

-- 4. Write a query that returns the order_date, order_id, first_name, shipper and status, Using LEFT JOIN
SELECT
	o.order_id,
    o.order_date,
    c.first_name AS customer_name,
    s.name AS shipper_name,
    os.name AS status
FROM sql_store.orders o
LEFT JOIN sql_store.customers c
	ON o.customer_id = c.customer_id
LEFT JOIN sql_store.shippers s
	ON o.shipper_id = s.shipper_id
LEFT JOIN sql_store.order_statuses os
	ON o.status = os.order_status_id
ORDER BY o.order_date;

-- 5. Write a query to select the payments from the payment table, and it should return the date, client, amount and payment method name
USE sql_invoicing;
SELECT
	c.name AS client_name,
    p.date,
    p.amount,
    pm.name AS payment_method
FROM payments p
LEFT JOIN clients c
	USING(client_id) -- Note the USING clause will work as long as the column name for both tables are the same, in this case client_id
LEFT JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;

-- 6. using CROSS JOIN, return a table for customers and all products bought by individual customers
USE sql_store;
SELECT
	c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;

-- 7. Write a query to produce the customer_id, first_name, points, and type. For the type column;
-- If a customer has less than 2000 points, then Bronze
-- Between 2000 and 3000 points, then Silver
-- More than 3000 points, then Gold
-- Also sort the result by the first_name
SELECT
	customer_id,
    first_name,
    points,
    'Bronze' AS type
FROM sql_store.customers
WHERE points < 2000
UNION -- This will combine the next query with the previous
SELECT
	customer_id,
    first_name,
    points,
    'Silver' AS type
FROM sql_store.customers
WHERE points BETWEEN 2000 AND 3000
UNION -- This will combine the next query with the previous
SELECT
	customer_id,
    first_name,
    points,
    'Gold' AS type
FROM sql_store.customers
WHERE points > 3000
ORDER BY first_name;

-- 8. From the sql_invoicing database, copy the records from the invoices table into another table called 'invoices_archived'. In the table, instead
-- having the client_id column, we want to have the client name column. For this, you'll need to join the invoices table with the client table and then
-- use the  query as a sub query in 'CREATE TABLE' statement

USE sql_invoicing;
CREATE TABLE invoices_archived AS
SELECT
	i.invoice_id,
	c.name AS client_name,
    i.number,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM invoices AS i
JOIN clients AS c
	ON i.client_id = c.client_id;

-- 9. From the sql_store database, write a sql statement to update the comments for orders of customers who have more than 3000 points (gold customer)
USE sql_store;
UPDATE orders
SET comments = 'Gold Customer'
WHERE customer_id IN (
	SELECT customer_id
	FROM customers
	WHERE points > 3000);
SELECT * FROM orders;

-- 10. Solving question 7 using the CASE WHEN statement.
USE sql_store;
SELECT
	db.customer_id,
    db.full_name,
    db.points,
    db.type
FROM (
	SELECT 
		customer_id,
		CONCAT(first_name, '  ', last_name) AS full_name,
        points,
        CASE
			WHEN points < 2000 THEN 'Bronze'
            WHEN points BETWEEN 2000 AND 3000 THEN 'Silver'
            WHEN points > 3000 THEN 'Gold'
		END AS type
	FROM customers) db
ORDER BY full_name;

USE sql_store;
SELECT c.customer_id, COUNT(o.order_id) AS orders
FROM customers c
JOIN orders o
	USING(customer_id)
GROUP BY customer_id
ORDER BY COUNT(o.order_id) DESC;

select first_name, max(length(first_name))
from sql_store.customers
group by length(first_name)
order by first_name asc;

    