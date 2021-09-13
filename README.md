# 8weekSQLChallenge
8 case study provided by Danny Ma who I followed on LinkedIn with addition thoughts of mine. This git is to document my answers and Postgre learning process.  

-- 1. What is the total amount each customer spent at the restaurant?
-- SELECT
--  	s.customer_id, sum(m.price) total_amount
-- FROM dannys_diner.sales s join dannys_diner.menu m on s.product_id = m.product_id
-- GROUP BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?
-- SELECT customer_id , count(distinct order_date)
-- FROM dannys_diner.sales
-- GROUP BY customer_id

-- 3. What was the first item from the menu purchased by each customer?
-- SELECT m.product_name
-- FROM dannys_diner.menu m join dannys_diner.sales s on m.product_id = s.product_id
-- ORDER BY s.order_date
-- limit 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- SELECT m.product_name , count(s.order_date) order_cnt
-- FROM dannys_diner.menu m join dannys_diner.sales s on m.product_id = s.product_id
-- GROUP BY m.product_name
-- ORDER BY order_cnt DESC limit 1;

-- 5. Which item was the most popular for each customer?
/* SELECT customer, item from (SELECT s.customer_id customer, m.product_name item, dense_rank() over(partition by s.customer_id order by count(s.order_date)) r
FROM dannys_diner.sales s join dannys_diner.menu m on s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name) c
WHERE r = 1; */ 

-- 6. Which item was purchased first by the customer after they became a member?
--SELECT customer_id, product_name from (SELECT s.customer_id, m.product_name, DENSE_RANK() OVER(partition by s.customer_id ORDER BY AGE(s.order_date, mb.join_date)) r,s.order_date
--FROM dannys_diner.menu m join dannys_diner.sales s on m.product_id = s.product_id
--join dannys_diner.members mb on s.customer_id = mb.customer_id and mb.join_date <= s.order_date) t where r = 1;
-- 7. Which item was purchased just before the customer became a member?

--SELECT customer_id, product_name from (SELECT s.customer_id, m.product_name, DENSE_RANK() OVER(partition by s.customer_id ORDER BY AGE(mb.join_date, s.order_date)) r,s.order_date
--FROM dannys_diner.menu m join dannys_diner.sales s on m.product_id = s.product_id join dannys_diner.members mb on s.customer_id = mb.customer_id and mb.join_date > s.order_date) t where r = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
-- SELECT s.customer_id, COUNT(s.order_date) total_item, SUM(m.price) amount_spent
-- FROM dannys_diner.sales s join dannys_diner.menu m on s.product_id = m.product_id join dannys_diner.members mb on s.customer_id = mb.customer_id and mb.join_date > s.order_date
-- GROUP BY s.customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- SELECT customer_id, SUM(points) 
-- FROM (SELECT s.customer_id, CASE WHEN s.product_id = 1 THEN m.price*20 ELSE m.price*10 END as points FROM dannys_diner.sales s join dannys_diner.menu m on s.product_id = m.product_id) t
-- GROUP BY customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT customer_id, SUM(points) from (SELECT s.customer_id, CASE WHEN AGE(s.order_date,mb.join_date) <= INTERVAL '7 days' and AGE(s.order_date, mb.join_date) >= INTERVAL '0 days' then m.price*20 WHEN s.product_id = 1 then m.price*20 ELSE m.price*20 END as points from dannys_diner.sales s left join dannys_diner.members mb on s.customer_id = mb.customer_id join dannys_diner.menu m on s.product_id = m.product_id) t GROUP BY customer_id
