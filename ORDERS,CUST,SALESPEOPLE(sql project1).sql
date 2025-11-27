#1.	Create the Salespeople as below screenshot.
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS Cust;
DROP TABLE IF EXISTS Salespeople;
SET FOREIGN_KEY_CHECKS = 1;
CREATE TABLE Salespeople (
    snum INT PRIMARY KEY auto_increment,
    sname VARCHAR(30),
    city VARCHAR(30),
    comm DECIMAL(4,2)
);
INSERT INTO Salespeople (snum, sname, city, comm) VALUES
(1001, "Peel", "London", 0.12),
(1002, "Serres", "San Jose", 0.13),
(1003,"Axelrod", "New York", 0.10),
(1004,"Motika", "London", 0.11),
(1007,"Rafkin", "Barcelona", 0.15);
select * from salespeople;

#2.Create the Cust Table as below Screenshot    
drop table cust; 
CREATE TABLE Cust (
    cnum INT PRIMARY KEY,
    cname VARCHAR(30),
    city VARCHAR(30),
    rating INT,
    snum INT,
    FOREIGN KEY (snum) REFERENCES Salespeople(snum)
);

INSERT INTO Cust (cnum, cname, city, rating, snum) VALUES
(2001, "Hoffman", "London", 100, 1001),
(2002, "Giovanne", "Rome", 200, 1003),
(2003, "Liu", "San Jose", 300, 1002),
(2004, "Grass", "Berlin", 100, 1002),
(2006, "Clemens", "London", 300, 1007),
(2007, "Pereira", "Rome", 100, 1004),
(2008, "James", "London", 200, 1007);
select* from cust;
#3.	Create orders table as below screenshot.
CREATE TABLE Orders (
    onum INT PRIMARY KEY,
    amt DECIMAL(10,2),
    odate DATE,
    cnum INT,
    snum INT,
    FOREIGN KEY (cnum) REFERENCES Cust(cnum),
    FOREIGN KEY (snum) REFERENCES Salespeople(snum)
);

INSERT INTO Orders (onum, amt, odate, cnum, snum) VALUES
(3001, 18.69, "1994-10-03", 2008, 1007),
(3002, 1900.10, "1994-10-03", 2007, 1004),
(3003, 767.19, "1994-10-03", 2001, 1001),
(3005, 5160.45, "1994-10-03", 2003, 1002),
(3006, 1098.16, "1994-10-04", 2008, 1007),
(3007, 75.75, "1994-10-05", 2004, 1002),
(3008, 4723.00, "1994-10-05", 2006, 1007),
(3009, 1713.23, "1994-10-04", 2002, 1003),
(3010, 1309.95, "1994-10-06", 2004, 1002),
(3011, 9891.88, "1994-10-06", 2006, 1001);
select * from orders;

#4.Write a query to match the salespeople to the customers according to the city they are living.
select s.sname,c.cname,c.city from 
	salespeople s join cust c  on s.snum=c.snum;
    
#5.	Write a query to select the names of customers and the salespersons who are providing service to them.
select s.sname,c.cname from 
	salespeople s join cust c on  s.snum=c.snum;
#6.	Write a query to find out all orders by customers not located in the same cities as that of their salespeople
select 
		o.onum,o.amt,c.cnum,c.cname,c.city,s.sname,s.city 
from 
		orders o join cust c on 
		o.snum=c.snum join 
		salespeople s on
		c.snum=s.snum where s.city<>c.city;
        
#7.	Write a query that lists each order number followed by name of customer who made that order
select 
		o.onum,c.cnum,c.cname 
from 
		orders o join cust c on 
		o.snum=c.snum;

#8.	Write a query that finds all pairs of customers having the same rating………………
select 
	c1.cnum,c2.cnum,c1.rating
from 
	cust c1 join cust c2 on
    c1.rating=c2.rating
	and c1.cnum < c2.cnum 
order by 
	rating;                       #Use < or > on the key column to avoid duplicates.

#9.	Write a query to find out all pairs of customers served by a single salesperson………………..
select 
	c1.cname,c2.cname,sname,s.snum 
from 
	cust c1 join cust c2
on
	c1.snum=c2.snum
    and c1.cnum<c2.cnum
join
	salespeople s 
on
	c1.snum=s.snum;

#10.Write a query that produces all pairs of salespeople who are living in same city………………..
select
	s1.sname,s2.sname,s1.city
from 
	salespeople s1 join salespeople s2
on
	s1.city=s2.city
    and s1.sname<s2.sname;

#11.Write a Query to find all orders credited to the same salesperson who services Customer 2008
select 
	o.onum,s.snum,s.sname,c.cnum,c.cname
from
	orders o join salespeople s 
on
	o.snum=s.snum
join cust c 
on
	s.snum=c.snum where c.cnum=2008;

#12.Write a Query to find out all orders that are greater than the average for Oct 4th
select round(avg(amt),2) from orders where odate="1994-10-04";
select 
	onum,amt,odate
from 
	orders
where 
	amt>
    (select avg(amt) from orders where odate="1994-10-04");    #round(avg(amt),2) = 1405.70

#13.Write a Query to find all orders attributed to salespeople in London
select 
	o.onum,o.amt,s.snum,s.sname,s.city
from 
	orders o join salespeople s
on 
	o.snum=s.snum 
where
	s.city="london";

#14.Write a query to find all the customers whose cnum is 1000 above the snum of Serres. 
select 
	c.cnum,c.cname,s.snum,s.sname
from 
	cust c join salespeople s
on 
	c.snum=s.snum 
where
	c.cnum = (select snum + 1000 FROM Salespeople WHERE sname = 'Serres');

#15.Write a query to count customers with ratings above San Jose’s average rating.
select avg(rating) from cust;
select
	cnum,cname,city,rating
from 
	cust
where
	rating>
		(select avg(rating) from cust where city="San Jose");   #Liu lives in San jose whose rating is 300 and avg(rating)=185.7143

#16.Write a query to show each salesperson with multiple customers.
select 
	s.snum,s.sname,count(c.cnum) tot_cust
from 
	salespeople s join cust c
on
	s.snum=c.snum
    GROUP BY s.snum, s.sname
	HAVING COUNT(c.cnum) > 1;

    




    


    





