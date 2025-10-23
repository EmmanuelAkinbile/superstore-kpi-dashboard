/* Create views for KPIs */
-- Top Months by Profit
CREATE VIEW sales_monthly_view AS
SELECT
    CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS DATE) AS MonthStart,
    SUM(Sales)  AS Sales,
    SUM(Profit) AS Profit,
    CASE WHEN SUM(Sales) <> 0 THEN SUM(Profit) / SUM(Sales) ELSE 0 END AS Profit_Margin
FROM fact_orders_clean
GROUP BY CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS DATE);

SELECT TOP 10 * from sales_monthly_view
ORDER BY Profit desc;

-- Top Categories by Profit
CREATE VIEW sales_category_monthly_view AS
SELECT 
    CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS DATE) AS MonthStart, 
    Category,
    SUM(Sales) Sales,
    SUM(Profit) Profit,
    CASE WHEN SUM(Sales) <> 0 THEN SUM(Profit) / SUM(Sales) ELSE 0 END AS Profit_Margin
FROM fact_orders_clean
GROUP BY CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS DATE), Category;

SELECT TOP 10 * FROM sales_category_monthly_view
ORDER BY Profit desc;

-- Top Subcategories Per Month by Profit
CREATE VIEW sales_subcat_monthly_view AS
SELECT
  CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS date) AS MonthStart,
  Category,
  Sub_Category,
  SUM(Sales)  AS Sales,
  SUM(Profit) AS Profit,
  CASE WHEN SUM(Sales) <> 0 THEN SUM(Profit)/SUM(Sales) ELSE 0 END AS Profit_Margin
FROM fact_orders_clean
GROUP BY
  CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS date),
  Category, Sub_Category;

SELECT TOP 10 * FROM sales_subcat_monthly_view
Order by Profit desc;

-- Top Regions by Profit
CREATE VIEW sales_region_monthly_view AS
SELECT
  CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS date) AS MonthStart,
  Region,
  SUM(Sales)  AS Sales,
  SUM(Profit) AS Profit,
  CASE WHEN SUM(Sales) <> 0 THEN SUM(Profit)/SUM(Sales) ELSE 0 END AS Profit_Margin
FROM fact_orders_clean
GROUP BY
  CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS date),
  Region;

SELECT TOP 10 * FROM sales_region_monthly_view
Order BY Profit desc;

-- Top Orders in a Month 
CREATE VIEW shipping_monthly_view AS
SELECT
    CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS date) AS MonthStart,
    COUNT(*) AS Orders,
    AVG(CAST(Ship_Days AS decimal(9,2))) AS Avg_Lead_Days
FROM fact_orders_clean
GROUP BY CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS date);

SELECT TOP 10 *
FROM shipping_monthly_view
ORDER BY Orders desc;

-- Top Customers by Profit
CREATE VIEW customer_profit_view AS
SELECT
    Customer_ID,                      -- stable key to group on
    MAX(Customer_Name) AS Customer_Name,  -- display name (in case of minor name variants)
    SUM(Sales)  AS Total_Sales,       -- lifetime sales in the dataset
    SUM(Profit) AS Total_Profit       -- lifetime profit in the dataset
FROM fact_orders_clean
GROUP BY Customer_ID;

SELECT TOP 10 * FROM customer_profit_view
ORDER BY Total_Profit desc;

-- Top Segments.
CREATE VIEW sales_segment_monthly_view AS
SELECT
  CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS date) AS MonthStart,
  Segment,
  SUM(Sales)  AS Sales,
  SUM(Profit) AS Profit,
  CASE WHEN SUM(Sales) <> 0 THEN SUM(Profit)/SUM(Sales) ELSE 0 END AS Profit_Margin
FROM fact_orders_clean
GROUP BY
  CAST(DATEFROMPARTS(YEAR(Order_Date), MONTH(Order_Date), 1) AS date), Segment;

  SELECT TOP 10 * FROM sales_segment_monthly_view
  ORDER BY Profit desc;

-- Top Performing Products by Profit
CREATE VIEW product_performance_view AS
SELECT
  Product_ID,
  MAX(Product_Name) AS Product_Name,
  MAX(Category)     AS Category,
  MAX(Sub_Category) AS Sub_Category,
  SUM(Quantity)     AS Total_Quantity,
  SUM(Sales)        AS Total_Sales,
  SUM(Profit)       AS Total_Profit,
  CASE WHEN SUM(Sales) <> 0 THEN SUM(Profit)/SUM(Sales) ELSE 0 END AS Profit_Margin
FROM fact_orders_clean
GROUP BY Product_ID;

SELECT TOP 10 * FROM product_performance_view
ORDER BY Total_Profit desc;