-- Initial Check
SELECT TOP 10 * 
FROM stg_orders;

-- Number of rows; 9994
SELECT COUNT(*) num_of_rows
FROM stg_orders;

-- Number of duplicate rows; 2
SELECT COUNT(*) dupe_rows, Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment, Country, City, State,
Postal_Code, Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit
FROM stg_orders
GROUP BY Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Customer_Name, Segment, Country, City, State,
Postal_Code, Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, Discount, Profit
HAVING COUNT(*) > 1;

-- Number of distinct orders; 5009
SELECT COUNT(DISTINCT Order_ID) distinct_orders
FROM stg_orders;

-- Number of nulls in critical fields; 0 nulls for all
SELECT
  SUM(CASE WHEN Order_ID   IS NULL THEN 1 ELSE 0 END) AS null_order_id,
  SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
  SUM(CASE WHEN Ship_Date  IS NULL THEN 1 ELSE 0 END) AS null_ship_date,
  SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
  SUM(CASE WHEN Product_ID  IS NULL THEN 1 ELSE 0 END) AS null_product_id,
  SUM(CASE WHEN Sales      IS NULL THEN 1 ELSE 0 END) AS null_sales,
  SUM(CASE WHEN Quantity   IS NULL THEN 1 ELSE 0 END) AS null_qty,
  SUM(CASE WHEN Discount   IS NULL THEN 1 ELSE 0 END) AS null_discount,
  SUM(CASE WHEN Profit     IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM stg_orders;

-- Checking ranges for quantitative fields
SELECT
  MIN(Order_Date) AS min_order_date, MAX(Order_Date) AS max_order_date,
  MIN(Ship_Date)  AS min_ship_date,  MAX(Ship_Date)  AS max_ship_date,
  MIN(Sales)      AS min_sales,      MAX(Sales)      AS max_sales,
  MIN(Quantity)   AS min_qty,        MAX(Quantity)   AS max_qty,
  MIN(Discount)   AS min_disc,       MAX(Discount)   AS max_disc,
  MIN(Profit)     AS min_profit,     MAX(Profit)     AS max_profit
FROM stg_orders;

-- Checking for invalid Shipping and Order dates (Shipping dates should be after order dates).
SELECT *
FROM stg_orders
WHERE Ship_Date < Order_Date;

-- Number of distinct values in each qualitative field
SELECT 'Segment' AS col, COUNT(DISTINCT Segment) AS distinct_vals
FROM dbo.stg_orders
UNION ALL SELECT 'Ship_Mode', COUNT(DISTINCT Ship_Mode) FROM stg_orders
UNION ALL SELECT 'Region',    COUNT(DISTINCT Region)    FROM stg_orders
UNION ALL SELECT 'Category',  COUNT(DISTINCT Category)  FROM stg_orders
UNION ALL SELECT 'Sub_Category', COUNT(DISTINCT Sub_Category) FROM stg_orders;

-- Listing the expected values of eacch qualitative field
SELECT TOP (20) Segment FROM stg_orders GROUP BY Segment ORDER BY Segment;
SELECT TOP (20) Ship_Mode FROM stg_orders GROUP BY Ship_Mode ORDER BY Ship_Mode;
SELECT TOP (20) Region FROM stg_orders GROUP BY Region ORDER BY Region;
SELECT TOP (20) Category FROM stg_orders GROUP BY Category ORDER BY Category;
SELECT TOP (20) Sub_Category FROM stg_orders GROUP BY Sub_Category ORDER BY Sub_Category;

/* Now that i've confirmed that the fields are valid and nothing is broken, we will build 
a clean version of the data, separate from the staging table */

SELECT *,
	DATEDIFF(DAY, Order_Date, Ship_Date) Ship_Days -- new column representing days to ship after order
INTO fact_orders
FROM stg_orders;

-- Initial check for fact table. 
SELECT TOP 10 *
FROM fact_orders;

-- Check for duplicates 
SELECT Order_ID, Product_ID, COUNT(*) dupe_count
FROM fact_orders
GROUP BY Order_ID, Product_ID
HAVING COUNT(*) > 1;

-- Identifying the duplicate pairs. True duplicates contain the exact same
SELECT *
FROM fact_orders
WHERE Order_ID = 'US-2016-123750';

SELECT *
FROM fact_orders
WHERE Order_ID = 'CA-2016-137043';

SELECT *
FROM fact_orders
WHERE Order_ID = 'CA-2015-103135';

SELECT *
FROM fact_orders
WHERE Order_ID = 'CA-2016-129714';

SELECT *
FROM fact_orders
WHERE Order_ID = 'CA-2017-152912';

SELECT *
FROM fact_orders
WHERE Order_ID = 'CA-2017-118017';

-- Using CTE to remove duplicate orders
WITH CTE_Dupes AS (
    SELECT *,
           ROW_NUMBER() OVER ( -- Putting a row number beside every distinct instance
               PARTITION BY Order_ID, Product_ID, Quantity, Sales, Discount, Profit -- Treating rows with same value for these fields as one group
               ORDER BY Order_ID
           ) AS rn
    FROM fact_orders
)
DELETE FROM CTE_Dupes
WHERE rn > 1;

-- Creating new table with unique order id + product id pairings
SELECT
    Order_ID,
    Product_ID,
    MIN(Order_Date) AS Order_Date,
    MIN(Ship_Date)  AS Ship_Date,
    MAX(Ship_Mode)  AS Ship_Mode,
    MAX(Customer_ID) AS Customer_ID,
    MAX(Customer_Name) AS Customer_Name,
    MAX(Segment) AS Segment,
    MAX(Country) AS Country,
    MAX(City) AS City,
    MAX(State) AS State,
    MAX(Postal_Code) AS Postal_Code,
    MAX(Region) AS Region,
    MAX(Category) AS Category,
    MAX(Sub_Category) AS Sub_Category,
    MAX(Product_Name) AS Product_Name,
    SUM(Quantity) AS Quantity,
    SUM(Sales) AS Sales,
    MAX(Discount) AS Discount,  -- Since discount is identical across lines
    SUM(Profit) AS Profit
INTO fact_orders_clean
FROM fact_orders
GROUP BY Order_ID, Product_ID;

-- Checking duplucates for new table
SELECT Order_ID, Product_ID, COUNT(*)
FROM fact_orders_clean
GROUP BY Order_ID, Product_ID
HAVING COUNT(*) > 1;

-- Ensuring totals did'nt change
SELECT SUM(Sales) AS Original_Sales, SUM(Profit) AS Original_Profit FROM fact_orders;
SELECT SUM(Sales) AS Clean_Sales, SUM(Profit) AS Clean_Profit FROM fact_orders_clean;

-- Adding days to ship to new table
ALTER TABLE fact_orders_clean
ADD Ship_Days AS DATEDIFF(DAY, Order_Date, Ship_Date);

-- Quick check for nulls
SELECT 
  SUM(CASE WHEN Order_ID     IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
  SUM(CASE WHEN Product_ID   IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
  SUM(CASE WHEN Order_Date   IS NULL THEN 1 ELSE 0 END) AS Null_Order_Date,
  SUM(CASE WHEN Ship_Date    IS NULL THEN 1 ELSE 0 END) AS Null_Ship_Date,
  SUM(CASE WHEN Customer_ID  IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
  SUM(CASE WHEN Sales        IS NULL THEN 1 ELSE 0 END) AS Null_Sales,
  SUM(CASE WHEN Quantity     IS NULL THEN 1 ELSE 0 END) AS Null_Quantity,
  SUM(CASE WHEN Discount     IS NULL THEN 1 ELSE 0 END) AS Null_Discount,
  SUM(CASE WHEN Profit       IS NULL THEN 1 ELSE 0 END) AS Null_Profit,
  SUM(CASE WHEN Region       IS NULL THEN 1 ELSE 0 END) AS Null_Region,
  SUM(CASE WHEN Category     IS NULL THEN 1 ELSE 0 END) AS Null_Category,
  SUM(CASE WHEN Sub_Category IS NULL THEN 1 ELSE 0 END) AS Null_Sub_Category
FROM fact_orders_clean;

/* Quick quality checks */
-- Negative or zero quantities or sales
SELECT COUNT(*) AS Bad_Qty_Sales
FROM fact_orders_clean
WHERE Quantity <= 0 OR Sales < 0;

-- Discount outside 0..1
SELECT COUNT(*) AS Bad_Discount
FROM fact_orders_clean
WHERE Discount < 0 OR Discount > 1;

-- Ship before order
SELECT COUNT(*) AS Bad_ShipDates
FROM fact_orders_clean
WHERE Ship_Date < Order_Date;
