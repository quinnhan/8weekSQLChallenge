-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
-- - how many points would each customer have?
-- This query was based on the assumption of everyone (member/non-member get points)
-- Temp table
WITH point_conversion AS 
	(SELECT s.customer_id, 
     		CASE WHEN s.product_id = 1 THEN m.price*20 ELSE m.price*10 END points
		FROM dannys_diner.sales s 
     	join dannys_diner.menu m 
     		on s.product_id = m.product_id)
SELECT customer_id, sum(points)
FROM point_conversion 
GROUP BY customer_id;

-- Nesting query
SELECT customer_id, sum(points)
FROM (SELECT s.customer_id, 
     		CASE WHEN s.product_id = 1 THEN m.price*20 ELSE m.price*10 END points
		FROM dannys_diner.sales s 
     	join dannys_diner.menu m 
     		on s.product_id = m.product_id) q1
GROUP BY customer_id;

--end