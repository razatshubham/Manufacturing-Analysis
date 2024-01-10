create database Manufacturing_Analysis;
use Manufacturing_Analysis;

select * from dimcustomer;
select * from dimdate;
select * from dimproduct;
select * from dimproductcategory;
select * from dimproductsubcategory;
select * from dimsalesterritory;
select * from fact_internet_sales_new;
select * from factinternetsales;

-- KPI - 1
# show yearwise Sales

select distinct right(orderdate,4) as year, 
round(sum(SalesAmount)+sum(taxamt)) as sales from fact_internet_sales_new
group by year
union
select distinct right(orderdate,4) as year, 
round(sum(SalesAmount)+sum(taxamt)) as sales from factinternetsales
group by year;

select distinct right(orderdate,4) as year, 
round(sum(SalesAmount)+sum(taxamt)) as sales from
(select * from fact_internet_sales_new
union
select * from factinternetsales) as a 
group by year order by year;

-- KPI - 2
#  Monthwise sales

select distinct englishmonthname as month, 
round(sum(salesamount)+sum(taxamt)) as sales from dimdate as d 
left join fact_internet_sales_new as fn
on d.datekey=fn.DueDateKey group by englishmonthname
union
select englishmonthname as month, 
round(sum(salesamount)+sum(taxamt)) as sales from dimdate as d 
left join factinternetsales as f
on d.datekey=f.DueDateKey group by month order by sales desc;

-- KPI- 3
# Quarterwise sales

select qtr, sum(sales) as sales from
(select distinct concat("Q-",CalendarQuarter) as Qtr, 
round(sum(salesamount)+sum(taxamt)) as sales from dimdate as d 
left join fact_internet_sales_new as fn
on d.datekey=fn.DueDateKey group by qtr
union
select distinct concat("Q-",CalendarQuarter) as Qtr, 
round(sum(salesamount)+sum(taxamt)) as sales from dimdate as d 
left join factinternetsales as f
on d.datekey=f.DueDateKey group by qtr order by sales desc)
as a group by qtr;

-- KPI - 4
#  Salesamount and Productioncost together

select distinct right(orderdate,4) as year, 
round(sum(salesamount)+sum(taxamt)) as sales, 
round(sum(totalproductcost)+sum(taxamt)) as production
from fact_internet_sales_new group by year
union
select distinct right(orderdate,4) as year, 
round(sum(salesamount)+sum(taxamt)) as sales, 
round(sum(totalproductcost)+sum(taxamt)) as production
from factinternetsales group by year;

# Gender Wise Sales

select distinct gender, sum(sales) as sales from
(select distinct gender, round(sum(salesamount)+sum(taxamt)) as sales 
from dimcustomer join fact_internet_sales_new
using(customerkey) group by gender
union
select distinct gender, round(sum(salesamount)+sum(taxamt)) as sales 
from dimcustomer join factinternetsales
using(customerkey) group by gender) as a group by gender;

# union of fact_internet_sales_new and factinternatsales

select * from fact_internet_sales_new
union
select * from factinternetsales;

# Customerfull name wise sales

select concat(firstname,' ',middlename,' ',lastname) as customername,
round(sum(salesamount)+sum(taxamt)) as sales
from dimcustomer join fact_internet_sales_new using(customerkey) 
group by customername
union
select concat(firstname,' ',middlename,' ',lastname) as customername,
round(sum(salesamount)+sum(taxamt)) as sales
from dimcustomer join factinternetsales using(customerkey) 
group by customername
order by sales desc;

# year wise profit

select right(orderdate,4) as year, 
round(sum(salesamount)+sum(taxamt)-sum(totalproductcost)) as profit
from fact_internet_sales_new group by year
union
select right(orderdate,4) as year, 
round(sum(salesamount)+sum(taxamt)-sum(totalproductcost)) as profit
from factinternetsales group by year order by year;

# Country Wise Sales and Profit

select distinct salesterritorycountry as country,
round(sum(salesamount)+sum(taxamt)) as sales,
round(sum(salesamount)+sum(taxamt)-sum(totalproductcost)) as profit
from dimsalesterritory join fact_internet_sales_new using(salesterritorykey)
group by country
union
select distinct salesterritorycountry as country,
round(sum(salesamount)+sum(taxamt)) as sales,
round(sum(salesamount)+sum(taxamt)-sum(totalproductcost)) as profit
from dimsalesterritory join factinternetsales using(salesterritorykey)
group by country;

# Top 10 customer's

select concat(firstname,' ',middlename,' ',lastname) as customername,
round(sum(salesamount)+sum(taxamt)) as sales
from dimcustomer join fact_internet_sales_new using(customerkey) 
group by customername
union
select concat(firstname,' ',middlename,' ',lastname) as customername,
round(sum(salesamount)+sum(taxamt)) as sales
from dimcustomer join factinternetsales using(customerkey) 
group by customername
order by sales desc limit 10;

# Product Wise sales

select distinct englishproductcategoryname, sum(sales) as sales from
(select distinct englishproductcategoryname,
round(sum(f.salesamount)+sum(taxamt)) as sales
from fact_internet_sales_new as f 
join dimproduct using(productkey)
join dimproductsubcategory using(productsubcategorykey)
join dimproductcategory as pc using(productcategorykey)
group by englishproductcategoryname
union 
select distinct englishproductcategoryname,
round(sum(fa.salesamount)+sum(taxamt)) as sales
from factinternetsales as fa
join dimproduct using(productkey)
join dimproductsubcategory using(productsubcategorykey)
join dimproductcategory as pc using(productcategorykey)
group by englishproductcategoryname) as a group by englishproductcategoryname;