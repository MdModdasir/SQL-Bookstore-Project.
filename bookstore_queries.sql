CREATE TABLE BOOKS(
 BOOK_ID SERIAL PRIMARY KEY,
 TITLE TEXT,
 AUTHOR VARCHAR(100),
 GENRE VARCHAR(50),
 PUBLISHED_YEAR INT,
 PRICE NUMERIC(10,2),
 STOCK INT
);
COPY BOOKS(BOOK_ID,TITLE,AUTHOR,GENRE,PUBLISHED_YEAR,PRICE,STOCK)
FROM 'C:\Users\pc\OneDrive\Documents\SQL\Project'
CSV HEADER;

CREATE TABLE CUSTOMERS(
CUSTOMER_ID SERIAL PRIMARY KEY,
NAME VARCHAR(100),
EMAIL VARCHAR(100),
PHONE VARCHAR(15),
CITY VARCHAR(50),
COUNTRY VARCHAR(50)
);

CREATE TABLE ORDERS(
ORDER_ID SERIAL PRIMARY KEY,
CUSTOMER_ID INT REFERENCES CUSTOMERS(CUSTOMER_ID),
BOOK_ID INT REFERENCES BOOKS(BOOK_ID),
ORDER_DATE DATE,
QUANTITY INT,
TOTAL_AMOUNT NUMERIC(10,2)
);
ALTER TABLE CUSTOMERS
ALTER COUNTRY TYPE VARCHAR(150);



--Retrive all books in the 'fiction' genre?---
select genre from books
where genre in ('Fiction');

select * from books
where genre = 'Fiction';

--find the books published afte the year 1950:
select * from books 
where published_year>1950;

--list all the customers from the canada;
select * from customers
where country = 'Canada';

--show orders placed in November 2023:
select * from orders
where order_date between '2023-11-01' and '2023-11-30';

--retrive the total stock of books available:
select sum(stock) from books;

--find the details of most expensive book:
select * from books
where price= (select max(price)from books);

SELECT * FROM BOOKS ORDER BY PRICE DESC LIMIT 1;

--show all customers who ordered more than 1 quantity of a book:
SELECT c.*
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.quantity > 1;

--SHOW ALL AUTHOR WHO QUANTITY IS MORE THAN 10:
SELECT TITLE FROM BOOKS
JOIN ORDERS
ON BOOKS.BOOK_ID = ORDERS.BOOK_ID
WHERE ORDERS.QUANTITY>10;
--retrive all orders where the total amount exceeds $20--
select * from orders 
where total_amount>20;

--list all genres avialable in books table AND COUNT:
SELECT  COUNT(GENRE) FROM BOOKS;

SELECT DISTINCT genre
FROM books;

SELECT genre, COUNT(*) AS total_books
FROM books
GROUP BY genre;


---FIND THE BOOK WITH THE LOWEST STOCK--
SELECT * FROM BOOKS 
WHERE STOCK = (SELECT MIN(STOCK)AS LOWEST_STOCK FROM BOOKS);

SELECT * FROM BOOKS ORDER BY PRICE LIMIT 1;

--CALCULATE THE TOTAL REVENUE GENERATED FORM ALL ORDERS:
SELECT SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE FROM ORDERS;

--RETRIVE THE TOTAL NUMBER OF BOOK SOLD BY EACH GENRE
select b.genre,SUM(o.quantity)
from orders o
join
books b
ON b.book_id = o.book_id
GROUP BY b.genre;

--FIND THE AVERAGE PRICE OF BOOKS IN THE FANTASY GENRE:
SELECT AVG(PRICE)
FROM BOOKS
WHERE GENRE = 'Fantasy';

--list customers who have placed at least 2 orders:
SELECT ORDERS.customer_id,CUSTOMER.NAME,COUNT(ORDERS.order_id) AS ORDER_COUNT
FROM orders
JOIN CUSTOMERS
ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID
GROUP BY ORDERS.customer_id CUSTOMERS.NAME
HAVING COUNT(order_id) >=2;

SELECT B.TITLE,O.QUANTITY
FROM BOOKS B
JOIN
ORDERS O
ON B.BOOK_ID = O.BOOK_ID;

--FIND THE MOST FEQUENTLY ORDERED BOOK:
SELECT O.BOOK_ID,B.TITLE,COUNT(O.ORDER_ID)
FROM ORDERS O
JOIN BOOKS B
ON O.BOOK_ID=B.BOOK_ID
GROUP BY O.BOOK_ID,B.TITLE ORDER BY COUNT DESC LIMIT 1;

---SHOW THE TOP 3 MOST EXPENSIVE BOOK OF FANTASY GENERE:
SELECT TITLE as most_expensive_book FROM BOOKS
WHERE GENRE ='Fantasy' order by price desc limit 3;

--retrieve the total quantity of books sold by each author:
select b.author,b.price,o.quantity,o.total_amount,sum(o.quantity)
from books b
join orders o
on b.book_id = o.book_id
group by b.author,b.price,o.quantity,o.total_amount
order by total_amount desc limit 10;

--list the cities where customers who spent over 30 are located:
select distinct c.city,c.name,o.total_amount
from customers c
join orders o
on c.customer_id=o.customer_id
where o.total_amount>30;

select distinct total_amount from orders;

--find the customer who spent the most on orders:
select c.name,c.customer_id,sum(o.total_amount) as total_spent
from orders o
join customers c
on o.customer_id = c.customer_id
group by c.name,c.customer_id
order by total_spent desc limit 1;

--calculate the stock remaining after fulfilling all orders:
select b.stock,o.quantity  --,sum(b.stock)as total_stock,sum(o.quantity)as total_quantity
from books b
join orders o
on b.book_id = o.book_id

group by b.stock,o.quantity;

SELECT COUNT(ORDER_ID)FROM ORDERS;
SElECT * FROM BOOKS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;