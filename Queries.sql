--Data Understanding

--1. Find total number of transactions. 
select count(*) as tot_trans from sales 
--2. Find total revenue generated. 
select sum(amount) as revenue from sales 
--3. Find total unique customers. 
select count(distinct customer_id) as unique_customers from sales 
--4. Find average order value. 
select avg(amount) as avg_order_val from sales 
--5. Find total quantity sold. 
select sum(quantity) as tot_quant from sales 
--6. Find minimum and maximum sale amount. 
select min(amount) as minimum,max(amount) as maximum from sales 
--7. Find average discount given. 
Select avg(discount) as avg_discount from sales 
--8. Find total sales per store. 
select st.store_name,sum(s.amount) as tot_sales from sales s 
join stores st 
on s.store_id=st.store_id 
group by st.store_name 
--9. Find total sales per category. 
select p.category,sum(s.amount) as tot_sales from sales s 
join products p 
on s.product_id=p.product_id 
group by p.category 
--10. Find number of transactions per day. 
select sale_date,count(*) as no_of_trans from sales 
group by sale_date 
order by sale_date

-- Data Cleaning

--1. Replace NULL discount with 0. 
Select sale_id,nvl(discount,0) from sales 
--2. Find number of NULL discounts. 
Select count(*) from sales where discount is null 
--3. Calculate net revenue (amount - discount). 
Select sale_id,amount-nvl(discount,0) as net_revenue from sales 
--4. Replace NULL quantity with 1. 
Select sale_id,nvl(quantity,1) from sales 
--5. Identify rows where amount is NULL. 
Select * from sales where amount is null 
--6. Use COALESCE to handle multiple NULL columns. 
Select sale_id,coalesce(discount,0),coalesce(quantity,1) from sales 
--7. Create a cleaned column for revenue. 
Select sale_id,amount,discount,amount-nvl(discount,0) as revenue from sales 
--8. Check percentage of missing data. 
Select  
Count(*) as total_rows, 
Count(discount) as non_null_dis, 
Count(*)-count(discount) as null_dis, 
Round(((count(*)-count(discount))/count(*))*100,2) as null_percentage 
From sales 
--9. Flag rows with missing values. 
Select sale_id, 
Case when 
Discount is null or amount is null or quantity is null then ‘Missing data’ 
Else ‘Clean’ 
End as tag 
From sales 
--10. Prepare dataset for analysis. 
Select  
sale_id, 
customer_id, 
store_id, 
product_id, 
sale_date,     
NVL(amount, 0) AS amount, 
NVL(quantity, 1) AS quantity, 
NVL(discount, 0) AS discount from sales

--Filtering (WHERE)

--11. Find sales in last 30 days. 
Select * from sales where sale_date>=SYSDATE-30 
--12. Find sales above 5000. 
Select * from sales where amount>5000 
--13. Find sales between 1000 and 5000. 
Select * from sales where amount between 1000 and 5000  
--14. Find sales from CMR store. 
Select s.* from sales s 
Join stores st on s.store_id=st.store_id 
Where st.store_name=’CMR’ 
--15. Find Electronics category sales. 
Select s.* from sales s 
Join products p on s.product_id=p.product_id 
Where p.category=’Electronics’ 
--16. Find sales excluding Grocery category. 
Select s.* from sales s 
Join products p on s.product_id=p.product_id 
Where p.category <> ’Grocery’ 
--17. Find customers from specific store. 
select distinct c.customer_name from sales s 
join customers c on s.customer_id=c.customer_id 
join stores st on s.store_id=st.store_id 
where st.store_name=’CMR’ 
--18. Find high discount transactions. 
Select * from sales where discount>20 
--19. Find low quantity sales. 
Select * from sales where quantity<2 
--20. Find recent transactions. 
select * from sales order by sale_date desc 


--Aggregation (GROUP BY)

--21. Revenue per store. 
Select st.store_name,sum(s.amount) from sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
--22. Revenue per category. 
SELECT p.category, SUM(s.amount) AS total_revenue 
FROM sales s 
JOIN products p ON s.product_id = p.product_id 
GROUP BY p.category 
--23. Revenue per customer. 
select c.customer_name,sum(s.amount) from sales s 
join customers c on s.customer_id=c.customer_id 
group by c.customer_name 
--24. Monthly revenue. 
select to_char(sale_date,’YYYY-MM’) as month, sum(amount) from sales 
group by to_char(sale_date,’YYYY-MM’) 
order by month 
--25. Daily revenue. 
select sale_date,sum(amount) from sales group by sale_date 
--26. Average sales per store. 
Select st.store_name,avg(s.amount) from sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
--27. Total quantity per category. 
SELECT p.category, SUM(s.quantity) AS total_revenue 
FROM sales s 
JOIN products p ON s.product_id = p.product_id 
GROUP BY p.category 
--28. Total discount per store. 
Select st.store_name,sum(s.discount) from sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
--29. Customer-wise total spending. 
select c.customer_name,sum(s.amount) from sales s 
join customers c on s.customer_id=c.customer_id 
group by c.customer_name 
--30. Store-wise transaction count. 
Select st.store_name,count(*) from sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name


-- HAVING 


--31. Customers with revenue > 20000. 
select c.customer_name,sum(s.amount) from sales s 
join customers c on s.customer_id=c.customer_id 
group by c.customer_name 
having sum(s.amount)>20000 
--32. Stores with revenue > 100000. 
Select st.store_name,sum(s.amount) from sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
Having sum(s.amount)>100000  
--33. Categories with avg sales > 3000. 
SELECT p.category, AVG(s.amount) AS avg_sales 
FROM sales s 
JOIN products p ON s.product_id = p.product_id 
GROUP BY p.category 
HAVING AVG(s.amount) > 3000 
--34. Customers with more than 5 transactions. 
select c.customer_name,count(*) from sales s 
join customers c on s.customer_id=c.customer_id 
group by c.customer_name 
having count(*)>5 
--35. Stores with high discount usage. 
Select st.store_name,sum(s.discount) from sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
Having sum(s.discount)>5000 
--36. Categories with low performance. 
SELECT p.category, SUM(s.amount) AS avg_sales 
FROM sales s 
JOIN products p ON s.product_id = p.product_id 
GROUP BY p.category 
HAVING SUM(s.amount) < 20000 
--37. Customers with high avg order value. 
select c.customer_name,avg(s.amount) from sales s 
join customers c on s.customer_id=c.customer_id 
group by c.customer_name 
having avg(s.amount)>4000 
--38. Find top 5 customers using HAVING. 
select c.customer_name,sum(s.amount) as revenue from sales s 
join customers c on s.customer_id=c.customer_id 
group by c.customer_name 
order by revenue desc 
fetch first 5 rows only 
--39. Stores with max transactions. 
Select st.store_name,count(*) as max_trans from sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
Having count(*)=( 
Select max(cnt) 
From ( 
Select count(*) as cnt from sales 
Group by store_id 
) 
); 
--40. Categories with high growth. 
SELECT p.category, 
SUM(CASE WHEN s.sale_date >= SYSDATE - 30 THEN s.amount ELSE 0 END) AS                   
recent_sales, 
SUM(CASE WHEN s.sale_date < SYSDATE - 30 THEN s.amount ELSE 0 END) AS 
old_sales 
FROM sales s 
JOIN products p ON s.product_id = p.product_id 
GROUP BY p.category 
HAVING SUM(CASE WHEN s.sale_date >= SYSDATE - 30 THEN s.amount ELSE 0  
END) >  SUM(CASE WHEN s.sale_date < SYSDATE - 30 THEN s.amount ELSE 0 END); 


-- CASE WHEN

--41. Classify customers as High/Medium/Low spenders. 
SELECT c.customer_name, 
SUM(s.amount) AS total_spent, 
CASE  
WHEN SUM(s.amount) > 20000 THEN 'High' 
WHEN SUM(s.amount) BETWEEN 10000 AND 20000 THEN 'Medium' 
ELSE 'Low' 
END AS spender_type 
FROM sales s 
JOIN customers c ON s.customer_id = c.customer_id 
GROUP BY c.customer_name; 
--42. Classify transactions as Big/Small. 
Select sale_id,amount, 
Case 
When amount>5000 then ‘Big’ 
Else ‘Small’ 
End as trans_type 
From sales 
--43. Create discount flag. 
Select sale_id,discount 
Case 
When discount is null then ‘No Discount’ 
Else ‘Discount Applied’ 
End as dis_flag 
From sales 
--44. Segment stores based on revenue. 
Select st.store_name, sum(s.amount) as tot_revenue, 
Case 
When sum(s.amount)>100000 then ‘Top Store’ 
When sum(s.amount) between 50000 and 100000 then ‘Mid Store’ 
Else ‘Low Store’ 
End as store_segment 
From sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
--45. Categorize customers based on frequency. 
Select c.customer_name, 
count(*) AS total_orders, 
Case 
When count(*) > 10 then 'Frequent' 
When count(*) between 5 and 10 then 'Regular' 
Else 'Occasional' 
End as customer_type 
From sales s 
Join customers c on s.customer_id = c.customer_id 
Group by c.customer_name; 
--46. Create sales buckets. 
Select sale_id,amount, 
Case 
When amount<1000 then ‘Low’ 
When amount between 1000 and 5000 then ‘Medium’ 
Else ‘High’ 
End as sales_buckets 
From sales   
--47. Identify premium customers. 
SELECT c.customer_name, 
SUM(s.amount) AS total_spent, 
CASE  
WHEN SUM(s.amount) > 30000 THEN 'Premium' 
ELSE 'Normal' 
END AS customer_tag 
FROM sales s 
JOIN customers c ON s.customer_id = c.customer_id 
GROUP BY c.customer_name; 
--48. Mark high-value transactions. 
Select sale_id,amount, 
Case 
When amount>10000 then ‘High Value’ 
Else ‘Normal’ 
End as value_flag 
From sales 
--49. Classify categories based on performance. 
Select p.category, sum(s.amount) as tot_revenue, 
Case 
 When sum(s.amount)>50000 then ‘High Performing’ 
 When sum(s.amount) between 20000 and 50000 then ‘Average’ 
 Else ‘Low Performing’ 
End as performance_tag 
From sales s 
Join products p on s.product_id=p.product_id 
Group by p.category 
--50. Create custom labels for reporting. 
Select sale_id,amount, 
CASE  
           WHEN amount > 5000 AND discount > 0 THEN 'High Value + Discount' 
           WHEN amount > 5000 THEN 'High Value' 
           WHEN discount > 0 THEN 'Discount Sale' 
           ELSE 'Regular Sale' 
       END AS report_label 
FROM sales 

-- JOINS (Multiple Tables)

--51. Join sales with customers table. 
Select s.*,c.customer_name from sales s 
Join customers c on s.customer_id=c.customer_id 
--52. Join sales with stores table. 
Select s.*,st.store_name from sales s 
Join stores st on s.store_id=st.store_id 
--53. Join sales with products table. 
Select s.*,p.category from sales s 
Join products p on s.product_id=p.product_id 
--54. Find customer name with store name and sales. 
Select c.customer_name,st.store_name,s.amount 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Join stores st on s.store_id=st.store_id 
--55. Find category-wise revenue using joins. 
Select p.category,sum(s.amount) from sales s 
Join products p on s.product_id=p.product_id 
Group by p.category 
--56. Find store-wise customer count. 
Select st.store_name,count(distinct s.customer_id) as cust_cnt 
From sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
--57. Find top product per store. 
Select store_name,category,total_sales 
From ( 
Select st.store_name,p.category,sum(s.amount) as total_sales, 
RANK() OVER(partition by st.store_name order by sum(s.amount) desc) as 
rnk 
From sales s 
Join stores st on s.store_id=st.store_id 
Join products p on s.product_id=p.product_id 
Group by st.store_name,p.category 
) 
Where rnk=1 
--58. Find customers who purchased from multiple stores. 
Select c.customer_name from sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
Having count(distinct s.store_id)>1 
--59. Find sales with product category. 
Select s.sale_id,s.amount,p.category from sales s 
Join products p on s.product_id=p.product_id 
--60. Find revenue per customer per store. 
Select c.customer_name,st.store_name,sum(s.amount) from sales s 
Join customers c on s.customer_id=c.customer_id 
Join stores st on s.store_id=st.store_id 
Group by c.customer_name,st.store_name 
--61. Find customers with no transactions (LEFT JOIN). 
Select c.customer_name from customers c 
Left join sales s on c.customer_id=s.customer_id 
Where s.sale_id is null 
--62. Find missing product mappings. 
Select s.sale_id from sales s  
Left join products p on s.product_id = p.product_id 
Where p.product_id is null 
--63. Find store performance using joins. 
Select st.store_name, sum(s.amount) as revenue, count(*) as trans 
From sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
--64. Find cross-category purchases. (Customers buying multiple categories) 
Select c.customer_name from sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
Having count(distinct s.product_id)>1 
--65. Find total revenue using joins. 
Select sum(s.amount) as tot_revenue from sales s 
Join customers c on s.customer_id=c.customer_id 
Join stores st on s.store_id=st.store_id 
Join products p on s.product_id=p.product_id 


-- Window Functions 

--66. Calculate total spend per customer using window function. 
Select s.sale_id,c.customer_name,s.amount, 
Sum(s.amount) over(partition by s.customer_id) as total_spend 
From sales s 
Join customers c on s.customer_id=c.customer_id 
--67. Rank customers by revenue. 
Select c.customer_name,sum(s.amount) as revenue, 
RANK() OVER(order by sum(s.amount) desc) as rnk 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
--68. Find top customer per store. 
Select * 
From ( 
Select st.store_name, c.customer_name, 
Sum(s.amount) as total_spend, 
RANK() OVER (partition by st.store_name order by sum(s.amount) desc) as 
rnk 
From sales s 
Join customers c on s.customer_id = c.customer_id 
Join stores st on s.store_id = st.store_id 
Group by st.store_name, c.customer_name 
) 
Where rnk = 1; 
--69. Calculate running total of sales. 
Select sale_id, sale_date, amount, 
Sum(amount) OVER (order by sale_date ROWS BETWEEN UNBOUNDED 
PRECEDING AND CURRENT ROW) AS running_total 
FROM sales; 
--70. Find previous sale using LAG. 
Select sale_id,sale_date,amount, 
LAG(amount) OVER(order by sale_date ) as prev_sale 
From sales  
--71. Find next sale using LEAD. 
Select sale_id,sale_date,amount, 
LEAD(amount) OVER(order by sale_date ) as next_sale 
From sales 
--72. Calculate sales growth. 
Select sale_id,sale_date,amount, 
Amount-LAG(amount) OVER(order by sale_date ) as growth 
From sales  
--73. Find difference between transactions. 
Select sale_id,amount, 
Amount-LAG(amount) OVER(order by sale_date ) as diff 
From sales 
--74. Calculate cumulative revenue. 
Select sale_id, sale_date, amount, 
Sum(amount) OVER (order by sale_date ROWS BETWEEN UNBOUNDED 
PRECEDING AND CURRENT ROW) AS cumulative_revenue 
From sales 
--75. Find moving average of sales. 
Select sale_id, sale_date, amount, 
avg(amount) OVER (order by sale_date ROWS BETWEEN 2 PRECEDING AND 
CURRENT ROW) AS moving_avg 
From sales 
--76. Rank stores by revenue.  
Select st.store_name,sum(s.amount) as revenue, 
RANK() OVER(order by sum(s.amount) desc) as rnk 
From sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
--77. Find second highest sale. 
Select * 
From ( 
Select sale_id,amount, 
DENSE_RANK() OVER(order by amount desc) as rnk 
From sales 
) 
Where rnk=2 
--78. Partition data by store and analyze. 
Select st.store_name,s.sale_id,s.amount, 
Sum(amount) OVER(partition by st.store_name) as store_total 
From sales s 
Join stores st on s.store_id=st.store_id 
--79. Find customer ranking per store. 
Select st.store_name, c.customer_name, 
Sum(s.amount) as total_spend, 
RANK() OVER (partition by st.store_name order by sum(s.amount) desc) as 
rnk 
From sales s 
Join customers c on s.customer_id = c.customer_id 
Join stores st on s.store_id = st.store_id 
Group by st.store_name, c.customer_name 
--80. Calculate frequency using window. 
Select c.customer_name,s.sale_id, 
Count(*) OVER(partition by s.customer_id) as freq from sales s 
Join customers c on s.customer_id=c.customer_id 


-- NTILE / Segmentation 

--81. Divide customers into 4 segments. 
Select c.customer_name,sum(s.amount) as tot_spend, 
NTILE(4) OVER(order by sum(s.amount) desc ) as segment 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
--82. Identify top 25% customers. 
Select *  
From ( 
Select c.customer_name,sum(s.amount) as tot_spend, 
NTILE(4) OVER(order by sum(s.amount) desc ) as segment 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
) 
Where segment=1 
--83. Identify bottom 25% customers. 
Select *  
From ( 
) 
Select c.customer_name,sum(s.amount) as tot_spend, 
NTILE(4) OVER(order by sum(s.amount) desc ) as segment 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
Where segment=4 
--84. Segment stores into 3 groups. 
Select st.store_name,sum(s.amount) as tot_spend, 
NTILE(3) OVER(order by sum(s.amount) desc ) as segment 
From sales s 
Join stores st on s.store_id=st.store_id 
Group by st.store_name 
--85. Create quartiles based on revenue. 
Select c.customer_name,sum(s.amount) as tot_spend, 
NTILE(4) OVER(order by sum(s.amount) desc ) as segment 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
--86. Segment customers per store. 
Select st.store_name,c.customer_name,sum(s.amount) as tot_spend, 
NTILE(3) OVER(partition by st.store_name order by sum(s.amount) desc ) as 
segment 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Join stores st on s.store_id=st.store_id 
Group by st.store_name,c.customer_name 
--87. Identify premium segment. 
Select *  
From ( 
Select c.customer_name,sum(s.amount) as tot_spend, 
NTILE(4) OVER(order by sum(s.amount) desc ) as segment 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
) 
Where segment=1 
--88. Find mid-level customers. 
Select *  
From ( 
Select c.customer_name,sum(s.amount) as tot_spend, 
NTILE(4) OVER(order by sum(s.amount) desc ) as segment 
From sales s 
Join customers c on s.customer_id=c.customer_id 
Group by c.customer_name 
) 
Where segment in (2,3) 
--89. Analyze bucket distribution. 
Select segment_label, Count(*) as customer_count 
From ( 
Select c.customer_name, 
Case  
When NTILE(4) OVER (order by sum(s.amount) desc) = 1 then 'Premium' 
When NTILE(4) OVER (order by sum(s.amount) desc) = 2 then 'Gold' 
When NTILE(4) OVER (order by sum(s.amount) desc) = 3 then 'Silver' 
Else 'Basic' 
End as segment_label 
From sales s 
Join customers c on s.customer_id = c.customer_id 
Group by c.customer_name 
) 
Group by segment_label 
Order by segment_label; 
--90. Create marketing segments. 
Select c.customer_name, 
Case  
When NTILE(4) OVER (order by sum(s.amount) desc) = 1 then 'Premium' 
When NTILE(4) OVER (order by sum(s.amount) desc) = 2 then 'Gold' 
When NTILE(4) OVER (order by sum(s.amount) desc) = 3 then 'Silver' 
Else 'Basic' 
End as segment_label 
From sales s 
Join customers c on s.customer_id = c.customer_id 
Group by c.customer_name 


-- FIRST_VALUE / LAST_VALUE 

--91. Find highest sale. 
Select sale_id,amount, 
FIRST_VALUE(amount) OVER(order by amount desc) as highest_sale 
From sales 
--92. Find lowest sale. 
Select sale_id,amount, 
LAST_VALUE(amount) OVER(order by amount desc ROWS BETWEEN UNBOUNDED 
PRECEDING AND UNBOUNDED FOLLOWING) as lowest_sale 
From sales 
--93. Compare each sale with highest. 
Select sale_id,amount, 
FIRST_VALUE(amount) OVER(order by amount desc) as highest_sale, 
Amount-FIRST_VALUE(amount) OVER(order by amount desc) as diff 
From sales 
--94. Compare each sale with lowest. 
Select sale_id,amount, 
LAST_VALUE(amount) OVER(order by amount desc ROWS BETWEEN UNBOUNDED 
PRECEDING AND UNBOUNDED FOLLOWING) as lowest_sale, 
Amount -LAST_VALUE(amount) OVER(order by amount desc ROWS BETWEEN 
UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as diff 
From sales 
--95. Find highest sale per store. 
Select st.store_name,s.sale_id,s.amount, 
FIRST_VALUE(s.amount) OVER(partition by st.store_name order by s.amount desc) 
as highest_sale from sales s 
Join stores st on s.store_id=st.store_id 
--96. Find lowest sale per store. 
Select st.store_name,s.sale_id,s.amount, 
LAST_VALUE(amount) OVER(partition by st.store_name order by amount desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 
lowest_sale 
from sales s 
Join stores st on s.store_id=st.store_id 
--97. Compare category performance. 
Select p.category,s.amount, 
FIRST_VALUE(s.amount) OVER(partition by p.category order by s.amount desc) as 
best_sale, 
LAST_VALUE(s.amount) OVER(partition by p.category order by s.amount desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 
worst_sale 
From sales s 
Join products p on s.product_id=p.product_id 
--98. Find best customer per store. 
Select * 
From ( 
Select st.store_name, c.customer_name, 
Sum(s.amount) as total_spend, 
RANK() OVER (partition by st.store_name order by sum(s.amount) desc) as 
rnk 
From sales s 
Join customers c on s.customer_id = c.customer_id 
Join stores st on s.store_id = st.store_id 
Group by st.store_name, c.customer_name 
) 
Where rnk = 1; 
--99. Find worst performing category. 
Select* 
From ( 
Select p.category, 
Sum(s.amount) as total_revenue, 
RANK() OVER (order by sum(s.amount)) as rnk 
From sales s 
Join products p on s.product_id = p.product_id 
Group by p.category 
) 
Where rnk = 1; 
--100. Analyze gap between best and worst. 
Select sale_id,amount, 
FIRST_VALUE(amount) OVER(order by amount desc) as max_sale, 
LAST_VALUE(amount) OVER(order by amount desc ROWS BETWEEN 
UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as min_sale, 
FIRST_VALUE(amount) OVER(order by amount desc)- 
LAST_VALUE(amount) OVER(order by amount desc ROWS BETWEEN 
UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as gap 
From sales 


-- Date Analysis -

--101. Find daily sales. 
Select sale_date,sum(amount) from sales 
Group by sale_date 
--102. Find monthly sales. 
Select to_char(sale_date,’YYYY-MM’) as month, 
Sum(amount) from sales 
Group by to_char(sale_date,’YYYY-MM’) 
--103. Find weekend sales. 
Select sale_date,sum(amount) as weekend_sales from sales 
Where to_char(sale_date,’dy’) in (‘sat’,’sun’) 
Group by sale_date 
Order by sale_date 
--104. Find first sale date. 
Select min(sale_date) as first_sale from sales 
--105. Find last sale date. 
Select max(sale_date) as last_sale from sales 
--106. Find sales in specific month. 
Select * from sales 
Where to_char(sale_date,’YYYY-MM’)=’2025-02’ 
--107. Find sales growth month-wise. 
Select month,total_sales, 
Total_sales-LAG(total_sales) OVER(order by month) as growth 
From ( 
Select to_char(s.sale_date,’YYYY-MM’) as month, 
Sum(s.amount) as total_sales 
From sales s 
Group by to_char(s.sale_date,’YYYY-MM’) 
) 
--108. Find inactive customers (30 days). 
select c.customer_name from customers c 
left join sales s 
on c.customer_id=s.customer_id 
group by c.customer_name 
having max(s.sale_date)<SYSDATE-30 or max(s.sale_date) is null 
--109. Find repeat customers. 
select c.customer_name,count(*) from sales s 
join customers c on s.customer_id=c.customer_id 
group by c.customer_name 
having count(*)>1 
--110. Find sales trend. 
Select sale_date,sum(amount) OVER(order by sale_date) as trend 
From sales