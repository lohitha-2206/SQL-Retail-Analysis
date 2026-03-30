-- customers

CREATE TABLE customers ( 
customer_id NUMBER, 
customer_name VARCHAR2(50) 
); 

-- stores

CREATE TABLE stores ( 
store_id NUMBER, 
store_name VARCHAR2(50) 
); 

-- products

CREATE TABLE products ( 
product_id NUMBER, 
category VARCHAR2(50) 
); 

-- sales

CREATE TABLE sales ( 
sale_id NUMBER, 
customer_id NUMBER, 
store_id NUMBER, 
product_id NUMBER, 
sale_date DATE, 
amount NUMBER, 
quantity NUMBER, 
discount NUMBER 
); 