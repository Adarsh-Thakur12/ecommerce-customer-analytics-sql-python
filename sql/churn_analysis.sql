--    1. Find the latest order date in the dataset

SELECT
    MAX(`Order Date`) AS latest_order_date
FROM superstore_orders;


--    2. Last purchase date for each customer

SELECT
    `Customer ID`,
    MAX(`Order Date`) AS last_order_date
FROM superstore_orders
GROUP BY `Customer ID`;


--    3. Identify churned customers (inactive for 90+ days)

WITH last_purchase AS (
    SELECT
        `Customer ID`,
        MAX(`Order Date`) AS last_order_date
    FROM superstore_orders
    GROUP BY `Customer ID`
),
latest_date AS (
    SELECT
        MAX(`Order Date`) AS max_date
    FROM superstore_orders
)
SELECT
    lp.`Customer ID`,
    lp.last_order_date,
    DATEDIFF(ld.max_date, lp.last_order_date) AS days_inactive
FROM last_purchase lp
CROSS JOIN latest_date ld
WHERE DATEDIFF(ld.max_date, lp.last_order_date) > 90
ORDER BY days_inactive DESC;


--    4. Total churned vs active customers

WITH customer_status AS (
    SELECT
        `Customer ID`,
        MAX(`Order Date`) AS last_order_date
    FROM superstore_orders
    GROUP BY `Customer ID`
),
latest_date AS (
    SELECT
        MAX(`Order Date`) AS max_date
    FROM superstore_orders
)
SELECT
    CASE
        WHEN DATEDIFF(ld.max_date, cs.last_order_date) > 90
            THEN 'Churned'
        ELSE 'Active'
    END AS customer_status,
    COUNT(*) AS customer_count
FROM customer_status cs
CROSS JOIN latest_date ld
GROUP BY customer_status;


--    5. Churn rate (%)

WITH customer_status AS (
    SELECT
        `Customer ID`,
        MAX(`Order Date`) AS last_order_date
    FROM superstore_orders
    GROUP BY `Customer ID`
),
latest_date AS (
    SELECT
        MAX(`Order Date`) AS max_date
    FROM superstore_orders
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN DATEDIFF(ld.max_date, cs.last_order_date) > 90
                    THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM customer_status cs
CROSS JOIN latest_date ld;


--    6. Churned customers by Segment

WITH churned_customers AS (
    SELECT
        s.`Customer ID`,
        s.Segment
    FROM superstore_orders s
    JOIN (
        SELECT
            `Customer ID`,
            MAX(`Order Date`) AS last_order_date
        FROM superstore_orders
        GROUP BY `Customer ID`
    ) lp
    ON s.`Customer ID` = lp.`Customer ID`
    WHERE DATEDIFF(
        (SELECT MAX(`Order Date`) FROM superstore_orders),
        lp.last_order_date
    ) > 90
)
SELECT
    Segment,
    COUNT(DISTINCT `Customer ID`) AS churned_customers
FROM churned_customers
GROUP BY Segment
ORDER BY churned_customers DESC;


--   7. Churned customers by Region

WITH churned_customers AS (
    SELECT
        s.`Customer ID`,
        s.Region
    FROM superstore_orders s
    JOIN (
        SELECT
            `Customer ID`,
            MAX(`Order Date`) AS last_order_date
        FROM superstore_orders
        GROUP BY `Customer ID`
    ) lp
    ON s.`Customer ID` = lp.`Customer ID`
    WHERE DATEDIFF(
        (SELECT MAX(`Order Date`) FROM superstore_orders),
        lp.last_order_date
    ) > 90
)
SELECT
    Region,
    COUNT(DISTINCT `Customer ID`) AS churned_customers
FROM churned_customers
GROUP BY Region
ORDER BY churned_customers DESC;


--    8. Revenue lost due to churned customers

WITH churned_customers AS (
    SELECT
        `Customer ID`
    FROM (
        SELECT
            `Customer ID`,
            MAX(`Order Date`) AS last_order_date
        FROM superstore_orders
        GROUP BY `Customer ID`
    ) lp
    WHERE DATEDIFF(
        (SELECT MAX(`Order Date`) FROM superstore_orders),
        lp.last_order_date
    ) > 90
)
SELECT
    ROUND(SUM(Sales), 2) AS revenue_lost_due_to_churn
FROM superstore_orders
WHERE `Customer ID` IN (SELECT `Customer ID` FROM churned_customers);
