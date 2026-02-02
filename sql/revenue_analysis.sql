--    1. Total Revenue

SELECT
    ROUND(SUM(Sales), 2) AS total_revenue
FROM superstore_orders;


--  2. Revenue by Year

SELECT
    YEAR(`Order Date`) AS year,
    ROUND(SUM(Sales), 2) AS yearly_revenue
FROM superstore_orders
GROUP BY YEAR(`Order Date`)
ORDER BY year;


--  3. Monthly Revenue Trend

SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS month,
    ROUND(SUM(Sales), 2) AS monthly_revenue
FROM superstore_orders
GROUP BY month
ORDER BY month;


--  4. Average Order Value (AOV)

SELECT
    ROUND(
        SUM(Sales) / COUNT(DISTINCT `Order ID`),
        2
    ) AS average_order_value
FROM superstore_orders;


--   5. Revenue by Customer

SELECT
    `Customer ID`,
    ROUND(SUM(Sales), 2) AS customer_revenue
FROM superstore_orders
GROUP BY `Customer ID`
ORDER BY customer_revenue DESC;


--  6. Top 10 Customers by Revenue

SELECT
    `Customer ID`,
    ROUND(SUM(Sales), 2) AS revenue
FROM superstore_orders
GROUP BY `Customer ID`
ORDER BY revenue DESC
LIMIT 10;


--  7. Revenue Contribution by Top 10% Customers

WITH customer_revenue AS (
    SELECT
        `Customer ID`,
        SUM(Sales) AS revenue
    FROM superstore_orders
    GROUP BY `Customer ID`
),
ranked_customers AS (
    SELECT
        `Customer ID`,
        revenue,
        NTILE(10) OVER (ORDER BY revenue DESC) AS revenue_bucket
    FROM customer_revenue
)
SELECT
    ROUND(SUM(revenue), 2) AS top_10_percent_revenue
FROM ranked_customers
WHERE revenue_bucket = 1;


--   8. Rolling 3-Month Revenue (Window Function)

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(`Order Date`, '%Y-%m') AS month,
        SUM(Sales) AS revenue
    FROM superstore_orders
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_3_month_revenue
FROM monthly_revenue
ORDER BY month;


-- 9. Month-over-Month Revenue Growth (%)

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(`Order Date`, '%Y-%m') AS month,
        SUM(Sales) AS revenue
    FROM superstore_orders
    GROUP BY month
),
revenue_with_lag AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (revenue - previous_month_revenue) / previous_month_revenue * 100,
        2
    ) AS mom_growth_percentage
FROM revenue_with_lag
ORDER BY month;


-- 10. Revenue by Category

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS category_revenue
FROM superstore_orders
GROUP BY Category
ORDER BY category_revenue DESC;


--  11. Revenue by Region

SELECT
    Region,
    ROUND(SUM(Sales), 2) AS region_revenue
FROM superstore_orders
GROUP BY Region
ORDER BY region_revenue DESC;
