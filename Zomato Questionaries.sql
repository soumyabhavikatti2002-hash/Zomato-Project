select * from country;
select * from currency;
select * from main;
desc main;
ALTER TABLE main
ADD COLUMN quarter1 varchar(10);

UPDATE main
SET quarter1 = concat("QTR-",QUARTER(date));


#3. Convert the Average cost for 2 column into USD dollars (currently the Average cost for 2 in local currencies)
select 
	m.Average_Cost_for_two, 
    cr.`usd rate` as rate,
     m.Average_Cost_for_two * cr.`USD rate` AS Cost_in_USD
from main m 
join currency cr
 on m.Currency=cr.Currency;
    
#4.Find the Numbers of Resturants based on City and Country.
select count(restaurantid) from main;
select 
	m.city,
    c.countryname,
    count(restaurantid) as NumberOfRestaurants
from main m
join country c
 on m.CountryCode=c.CountryID
 group by
	m.city,
    c.countryname;
    
#5.Numbers of Resturants opening based on Year , Quarter , Month	
select
    `Year Opening` AS Opening_Year,
    quarter1 AS Opening_Quarter,
    `Month Opening` AS Opening_Month,
    COUNT(RestaurantID) AS Total_Restaurants
from main
GROUP BY 
    `Year Opening`,
    quarter1,
    `Month Opening`
ORDER BY 
    Opening_Year,
    Opening_Quarter,
    Opening_Month;
    
ALTER TABLE main
ADD COLUMN Rating_Category VARCHAR(20);
UPDATE main
SET Rating_Category =
    CASE 
        WHEN Rating >= 4.5 THEN 'Top Rated'
        WHEN Rating >= 4.0 THEN 'Good'
        WHEN Rating >= 3.0 THEN 'Average'
        ELSE 'Low Rated'
    END;

#6.Count of Resturants based on Average Ratings
select
    Rating_Category,
    COUNT(*) AS Total_Restaurants
FROM main
GROUP BY Rating_Category
ORDER BY Total_Restaurants DESC;

ALTER TABLE main
ADD COLUMN Price_Bucket VARCHAR(30);
UPDATE main
SET Price_Bucket =
    CASE 
        WHEN Average_Cost_for_two < 500 THEN 'Below 500'
        WHEN Average_Cost_for_two BETWEEN 500 AND 1000 THEN '500 - 1000'
        WHEN Average_Cost_for_two BETWEEN 1001 AND 2000 THEN '1001 - 2000'
        WHEN Average_Cost_for_two BETWEEN 2001 AND 4000 THEN '2001 - 4000'
        ELSE 'Above 4000'
    END;
    
#7. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select
    Price_Bucket,
    COUNT(*) AS Total_Restaurants
FROM main
GROUP BY Price_Bucket
ORDER BY Total_Restaurants DESC;

#8.Percentage of Resturants based on "Has_Table_booking"
SELECT 
    Has_Table_booking,
    concat(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM main), 2),"%") AS Percentage_Of_Restaurants
FROM main
GROUP BY Has_Table_booking;

#9.Percentage of Resturants based on "Has_Online_delivery"
SELECT 
    Has_Online_delivery,
    concat(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM main), 2),"%") AS Percentage_Of_Restaurants
FROM main
GROUP BY Has_Online_delivery;









    


