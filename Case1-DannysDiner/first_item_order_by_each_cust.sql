-- 3. What was the first item from the menu purchased by each customer?
-- Solution #1
SELECT 
	q1.customer_id, 
    m.product_name 
FROM 
	(SELECT 
     	customer_id, 
     	min(order_date) first_order_date
	 FROM dannys_diner.sales 
	 GROUP BY customer_id) q1 
JOIN dannys_diner.sales s 
	ON  q1.first_order_date = s.order_date and 				q1.customer_id = s.customer_id 
JOIN dannys_diner.menu m 
	ON  s.product_id = m.product_id
ORDER BY q1.customer_id;


-- Solution #2
SELECT q1.customer_id, m.product_name
FROM 
	(SELECT s.customer_id, 
     		s.product_id,
     		dense_rank() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) first_order
     FROM dannys_diner.sales s) q1
JOIN dannys_diner.menu m
	ON q1.product_id = m.product_id
WHERE first_order = 1
ORDER BY customer_id;

