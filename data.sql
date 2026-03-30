-- Customers 

INSERT INTO customers 
SELECT LEVEL, 'Cust_'||LEVEL FROM dual CONNECT BY LEVEL<=50; 

-- Stores

INSERT INTO stores VALUES (1,'CMR'); 
INSERT INTO stores VALUES (2,'SR'); 
INSERT INTO stores VALUES (3,'Lucky');
 
 -- Products

INSERT INTO products VALUES (1,'Electronics'); 
INSERT INTO products VALUES (2,'Fashion'); 
INSERT INTO products VALUES (3,'Grocery'); 
INSERT INTO products VALUES (4,'Home');

 -- Sales (1000 rows)
  
INSERT INTO sales 
SELECT  
LEVEL, 
MOD(LEVEL,50)+1, 
MOD(LEVEL,3)+1, 
MOD(LEVEL,4)+1, 
DATE '2025-01-01' + MOD(LEVEL,90), 
ROUND(DBMS_RANDOM.VALUE(100,10000)), 
MOD(LEVEL,5)+1, 
CASE WHEN MOD(LEVEL,4)=0 THEN NULL ELSE ROUND(DBMS_RANDOM.VALUE(10,500)) 
END 
FROM dual 
CONNECT BY LEVEL <= 1000; 