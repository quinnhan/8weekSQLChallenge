-- 6. Which item was purchased first by the customer after they became a member?
WITH after_membership_sale AS 
	(SELECT s.customer_id, 
     		s.order_date, 
     		s.product_id, 
     		dense_rank() OVER (PARTITION BY 					s.customer_id ORDER BY s.order_date) next_order
		FROM dannys_diner.sales s 
     	join dannys_diner.members mb 
     		on s.customer_id = mb.customer_id 
     		and s.order_date > mb.join_date)
SELECT a.customer_id, m.product_name
FROM after_membership_sale a 
JOIN dannys_diner.menu m 
	on a.product_id = m.product_id
WHERE next_order = 1;