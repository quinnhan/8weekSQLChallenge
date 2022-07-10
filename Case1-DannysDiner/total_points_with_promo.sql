-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
-- This question is vague whether or not this business award points for non-member aka punch cards/giftcards
-- I am going to proceed with 2 scenarios

-- Case 1: Points award to non-members
WITH sales_with_points AS 
	(SELECT s.customer_id, 
     		s.order_date,
     		s.product_id,
     		CASE WHEN (s.order_date >= mb.join_date and s.order_date <= mb.join_date + 7) or m.product_name = 'sushi' THEN m.price*20 ELSE m.price*10 END points
     FROM dannys_diner.sales s 
     JOIN dannys_diner.menu m ON s.product_id = m.product_id
     LEFT JOIN dannys_diner.members mb ON s.customer_id = mb.customer_id)
SELECT customer_id, sum(points)
FROM sales_with_points
GROUP BY customer_id;

-- Case 2: Points only award to members
WITH sales_with_points AS 
	(SELECT s.customer_id, 
     		s.order_date,
     		s.product_id,
     		CASE WHEN s.order_date < mb.join_date then 0
     			WHEN (s.order_date >= mb.join_date and s.order_date <= mb.join_date + 7) or m.product_name = 'sushi' THEN m.price*20 ELSE m.price*10 END points
     FROM dannys_diner.sales s 
     JOIN dannys_diner.menu m ON s.product_id = m.product_id
     JOIN dannys_diner.members mb ON s.customer_id = mb.customer_id)
SELECT customer_id, sum(points)
FROM sales_with_points
GROUP BY customer_id;

--end
