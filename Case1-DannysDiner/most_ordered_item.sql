-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name, count(s.order_date) 
FROM dannys_diner.menu m 
JOIN dannys_diner.sales s 
	ON m.product_id = s.product_id
GROUP BY m.product_name
ORDER BY count(s.order_date) DESC
LIMIT 1;