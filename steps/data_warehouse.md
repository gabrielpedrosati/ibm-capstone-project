## Scenario

The company would like to create a data warehouse so that it can create reports like:

- total sales per year per country
- total sales per month per category
- total sales per quarter per country
- total sales per category per country

## Identify Fact and Dimension Tables

- Fact Table
  
  - FactSales

- Dimension Tables 
  
  - DimDate (year, month, quarter...)
  
  - DimCountry (country)
  
  - DimCategory (category)

## Dimensional Modeling

![](../imgs/dw_modeling.png)

## Technology

- IBM Cloud DB2 Database

## Load data into Data Warehouse

1. Create an DB2 instance

2. Open the DB2 panel

3. Go to Manage > Data > Load  data

4. Populate your Data Warehouse with a full load

## Fact Sales Populated

![](../imgs/factsales.png) 

## Reports and Summary

### Grouping sets

Grouping sets query using the columns country, category, totalsales.

```sql
select co.country, ca.categoryname, sum(f.amount) as totalsales
from "SPM41023"."FactSales" f
left join "SPM41023"."DimCountry" co
on f.idcountry = co.idcountry
left join "SPM41023"."DimCategory" ca
on f.idcategory = ca.idcategory
group by grouping sets(co.country,ca.categoryname)
order by co.country, ca.categoryname
```

### Rollup

rollup query using the columns year, country, and totalsales.

```sql
select co.country, d.year, sum(f.amount) as totalsales
from "SPM41023"."FactSales" f
left join "SPM41023"."DimCountry" co
on f.idcountry = co.idcountry
left join "SPM41023"."DimDate" d
on f.iddate = d.iddate
group by rollup(co.country,d.year);
```

### Cube

Cube query using the columns year, country, and average sales.

```sql
select co.country, d.year, avg(f.amount) as avgsales
from "SPM41023"."FactSales" f
left join "SPM41023"."DimCountry" co
on f.idcountry = co.idcountry
left join "SPM41023"."DimDate" d
on f.iddate = d.iddate
group by cube(co.country,d.year);
```

## MQT (Materialized Query Table)

MQT named total_sales_per_country that has the columns country and total_sales.

```sql
CREATE TABLE total_sales_per_country (country, total_sales) AS
  (select co.country, SUM(f.amount)
from "SPM41023"."FactSales" f
left join "SPM41023"."DimCountry" co
on f.idcountry = co.idcountry
group by co.country)
     DATA INITIALLY DEFERRED
     REFRESH DEFERRED
     MAINTAINED BY SYSTEM;
```
