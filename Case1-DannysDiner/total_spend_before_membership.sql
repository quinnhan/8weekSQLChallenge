-- 8. What is the total items and amount spent for each member before they became a member?
WITH prior_membership_sale AS 
	(SELECT s.customer_id, 
     		s.product_id,  
     		m.price
		FROM dannys_diner.sales s 
     	join dannys_diner.menu m 
     		on s.product_id = m.product_id
     	join dannys_diner.members mb 
     		on s.customer_id = mb.customer_id 
     		and s.order_date <= mb.join_date)
SELECT customer_id, count(product_id), sum(price)
FROM prior_membership_sale 
GROUP BY customer_id;