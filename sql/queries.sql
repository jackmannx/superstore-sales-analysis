-- Sales performance queries
-- Table assumed: orders (loaded from data/Sample-Superstore.csv)
-- Load locally with:
--   sqlite3 superstore.db
--   .mode csv
--   .import data/Sample-Superstore.csv orders

-- overall totals
SELECT
    ROUND(SUM(CAST(Sales AS REAL)), 0) AS total_sales,
    ROUND(SUM(CAST(Profit AS REAL)), 0) AS total_profit,
    ROUND(100.0 * SUM(CAST(Profit AS REAL)) / SUM(CAST(Sales AS REAL)), 1) AS margin_pct
FROM orders;

-- sales & profit by category
SELECT
    Category,
    ROUND(SUM(CAST(Sales AS REAL)), 0) AS total_sales,
    ROUND(SUM(CAST(Profit AS REAL)), 0) AS total_profit
FROM orders
GROUP BY Category
ORDER BY total_sales DESC;

-- sub-categories losing money
SELECT
    "Sub-Category",
    ROUND(SUM(CAST(Sales AS REAL)), 0) AS total_sales,
    ROUND(SUM(CAST(Profit AS REAL)), 0) AS total_profit
FROM orders
GROUP BY "Sub-Category"
HAVING total_profit < 0
ORDER BY total_profit ASC;

-- sales & profit by region
SELECT
    Region,
    ROUND(SUM(CAST(Sales AS REAL)), 0) AS total_sales,
    ROUND(SUM(CAST(Profit AS REAL)), 0) AS total_profit,
    ROUND(100.0 * SUM(CAST(Profit AS REAL)) / SUM(CAST(Sales AS REAL)), 1) AS margin_pct
FROM orders
GROUP BY Region
ORDER BY total_sales DESC;

-- discount tiers vs profit (does deep discounting kill margin?)
SELECT
    CASE
        WHEN CAST(Discount AS REAL) = 0 THEN 'no discount'
        WHEN CAST(Discount AS REAL) <= 0.2 THEN '1-20%'
        WHEN CAST(Discount AS REAL) <= 0.4 THEN '21-40%'
        ELSE '40%+'
    END AS discount_tier,
    COUNT(*) AS orders,
    ROUND(SUM(CAST(Profit AS REAL)), 0) AS total_profit,
    ROUND(AVG(CAST(Profit AS REAL)), 2) AS avg_profit_per_order
FROM orders
GROUP BY discount_tier
ORDER BY avg_profit_per_order DESC;

-- top 10 products by sales
SELECT
    "Product Name",
    ROUND(SUM(CAST(Sales AS REAL)), 0) AS total_sales
FROM orders
GROUP BY "Product Name"
ORDER BY total_sales DESC
LIMIT 10;
