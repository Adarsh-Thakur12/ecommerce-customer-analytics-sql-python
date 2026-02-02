--    1. Orders count and revenue per customer

WITH customer_metrics AS (
    SELECT
        `Customer ID`,
        COUNT(DISTINCT `Order ID`) AS total_orders,
        ROUND(SUM(Sales), 2) AS total_revenue
    FROM superstore_orders
    GROUP BY `Customer ID`
)
SELECT
    *
FROM customer_metrics
ORDER BY total_revenue DESC;


--  2. Customer Segmentation based on Orders & Revenue

WITH customer_metrics AS (
    SELECT
        `Customer ID`,
        COUNT(DISTINCT `Order ID`) AS total_orders,
        SUM(Sales) AS total_revenue
    FROM superstore_orders
    GROUP BY `Customer ID`
)
SELECT
    `Customer ID`,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    CASE
        WHEN total_orders >= 10 AND total_revenue >= 5000
            THEN 'High-Value Loyal'
        WHEN total_orders >= 5 AND total_revenue >= 2000
            THEN 'Potential Loyalist'
        WHEN total_orders >= 2
            THEN 'Regular'
        ELSE 'One-Time Buyer'
    END AS customer_segment
FROM customer_metrics
ORDER BY total_revenue DESC;


--   3. Segment-wise Customer Count
   
WITH customer_segments AS (
    SELECT
        `Customer ID`,
        CASE
            WHEN COUNT(DISTINCT `Order ID`) >= 10
                 AND SUM(Sales) >= 5000
                THEN 'High-Value Loyal'
            WHEN COUNT(DISTINCT `Order ID`) >= 5
                 AND SUM(Sales) >= 2000
                THEN 'Potential Loyalist'
            WHEN COUNT(DISTINCT `Order ID`) >= 2
                THEN 'Regular'
            ELSE 'One-Time Buyer'
        END AS segment
    FROM superstore_orders
    GROUP BY `Customer ID`
)
SELECT
    segment,
    COUNT(*) AS customer_count
FROM customer_segments
GROUP BY segment
ORDER BY customer_count DESC;


--    4. Segment-wise Revenue Contribution

WITH customer_segments AS (
    SELECT
        `Customer ID`,
        SUM(Sales) AS revenue,
        CASE
            WHEN COUNT(DISTINCT `Order ID`) >= 10
                 AND SUM(Sales) >= 5000
                THEN 'High-Value Loyal'
            WHEN COUNT(DISTINCT `Order ID`) >= 5
                 AND SUM(Sales) >= 2000
                THEN 'Potential Loyalist'
            WHEN COUNT(DISTINCT `Order ID`) >= 2
                THEN 'Regular'
            ELSE 'One-Time Buyer'
        END AS segment
    FROM superstore_orders
    GROUP BY `Customer ID`
)
SELECT
    segment,
    ROUND(SUM(revenue), 2) AS segment_revenue
FROM customer_segments
GROUP BY segment
ORDER BY segment_revenue DESC;


--   5. Top Customers within Each Segment (Window Function)

WITH customer_segments AS (
    SELECT
        `Customer ID`,
        SUM(Sales) AS revenue,
        CASE
            WHEN COUNT(DISTINCT `Order ID`) >= 10
                 AND SUM(Sales) >= 5000
                THEN 'High-Value Loyal'
            WHEN COUNT(DISTINCT `Order ID`) >= 5
                 AND SUM(Sales) >= 2000
                THEN 'Potential Loyalist'
            WHEN COUNT(DISTINCT `Order ID`) >= 2
                THEN 'Regular'
            ELSE 'One-Time Buyer'
        END AS segment
    FROM superstore_orders
    GROUP BY `Customer ID`
),
ranked_customers AS (
    SELECT
        `Customer ID`,
        segment,
        ROUND(revenue, 2) AS revenue,
        RANK() OVER (PARTITION BY segment ORDER BY revenue DESC) AS rank_in_segment
    FROM customer_segments
)
SELECT
    `Customer ID`,
    segment,
    revenue
FROM ranked_customers
WHERE rank_in_segment <= 5
ORDER BY segment, revenue DESC;


--   6. Average Order Value by Segment

WITH customer_segments AS (
    SELECT
        `Customer ID`,
        COUNT(DISTINCT `Order ID`) AS orders,
        SUM(Sales) AS revenue,
        CASE
            WHEN COUNT(DISTINCT `Order ID`) >= 10
                 AND SUM(Sales) >= 5000
                THEN 'High-Value Loyal'
            WHEN COUNT(DISTINCT `Order ID`) >= 5
                 AND SUM(Sales) >= 2000
                THEN 'Potential Loyalist'
            WHEN COUNT(DISTINCT `Order ID`) >= 2
                THEN 'Regular'
            ELSE 'One-Time Buyer'
        END AS segment
    FROM superstore_orders
    GROUP BY `Customer ID`
)
SELECT
    segment,
    ROUND(SUM(revenue) / SUM(orders), 2) AS avg_order_value
FROM customer_segments
GROUP BY segment
ORDER BY avg_order_value DESC;
