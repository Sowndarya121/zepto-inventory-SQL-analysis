create database zepto_inventory;
use zepto_inventory;

drop table if exists zepto;
create table zepto (
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock  VARCHAR(10),	
quantity INTEGER
);

alter table zepto
add s_id serial primary key;

---data exploration

---sample data
select * from zepto
limit 10;

--- check null values
select * from zepto 
where category is null
or
name is null
or
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;


--- different category from products
select distinct(category) from zepto
order by category;


--- product in stock and out of stock
select outOfStock,count(outOfStock)
from zepto
group by outOfStock;

---product name present in multiple times
select name,count(s_id)  from zepto 
group by name
having count(s_id)>1 
order by count(s_id) desc;

---data cleaning

---products with price=0
select * from zepto
where mrp=0 or discountedSellingPrice=0;

delete from zepto 
where mrp=0.0;


---convrt paisa into rupees
update zepto
set mrp=mrp/100 , discountedSellingPrice=discountedSellingPrice/100;

----- Q1. Find the top 10 best-value products based on the discount percentage.
select name,mrp,discountPercent from zepto
order by discountPercent desc
limit 10;

-------Q2.What are the Products with High MRP but Out of Stock
select distinct name,mrp from zepto
where  outOfStock='true' and mrp>300 
order by mrpdesc;

--------Q3.Calculate Estimated Revenue for each category
select category,sum(discountedSellingPrice*availableQuantity)/100 as revenue
from zepto
group by category
order by revenue desc;

---------Q3.Calculate  Revenue for each category

select category,sum(discountedSellingPrice*quantity)/100 as revenue
from zepto
group by category
order by revenue desc;

---------- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select * from zepto 
where mrp>500 and discountPercent<10.0
order by mrp desc, discountPercent desc;


---------- Q5. Identify the top 5 categories offering the highest average discount percentage.
select  category , round(avg(discountPercent),2) as avg_discount
from zepto 
group by category
order by avg_discount desc
limit 5;

----------Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,weightInGms,discountedSellingPrice, (discountedSellingPrice/weightInGms) as price_per_gram 
from zepto
where weightInGms>100
order by price_per_gram
limit 10;


-------Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name,weightInGms, 
case when weightInGms<1000 then 'low'
	when weightInGms<5000 then 'meidium'
else 'bulk'
end as weight_category
from zepto;

-------Q8.What is the Total Inventory Weight Per Category 
select  category, sum(weightInGms*availableQuantity) as Total_Inventory_Weight_per_catgegory 
from zepto
group by category
order by Total_Inventory_Weight_per_catgegory ;


--------Q9.Total inventory value by category
select category, sum(discountedSellingPrice*availableQuantity) as inentory_value
from zepto
group by category
order by inentory_value;

---------Q10.Identify dead stock (low quantity + no discount)
select distinct name, availableQuantity ,discountPercent
from zepto
where availableQuantity<10 and discountPercent=0.0
order by availableQuantity;


--------Q11.Find products with inconsistent pricing
select name,mrp,discountedSellingPrice
from zepto
where mrp<discountedSellingPrice;

--------Q12.Rank products within category
select name,category ,mrp , rank() over(partition by category order by mrp desc) as rnk
from zepto ;

-------Which category gives best value for money?
select category, round(avg(mrp/weightInGms),2) as avg_value
from zepto
group by category
order by avg_value
limit 1;

-----is discount actually useful?
SELECT category,
       AVG(discountPercent) AS avg_discount,
       AVG(mrp - discountedSellingPrice) AS avg_savings
FROM zepto
GROUP BY category;

----Best product per category
SELECT *
FROM (
    SELECT name, category, (mrp / weightInGms) AS price_per_gram,
           discountPercent,
           RANK() OVER (
               PARTITION BY category
               ORDER BY (mrp / weightInGms) ASC, discountPercent DESC
           ) AS rnk
    FROM zepto
) t
WHERE rnk = 1;