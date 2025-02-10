
WITH coffee_counts AS (
    SELECT
        data_role,
        ordered_coffee,
        COUNT(*) AS coffee_count
    FROM DEEPNOTE_DEVELOPMENT.TYPEFORM.COFFEE_RESPONSES
    GROUP BY data_role, ordered_coffee
),

ranked_coffees AS (
    SELECT
        data_role,
        ordered_coffee,
        coffee_count,
        ROW_NUMBER() OVER (PARTITION BY data_role ORDER BY coffee_count DESC) AS rank
    FROM coffee_counts
)

SELECT
    data_role,
    ordered_coffee AS most_popular_coffee,
    coffee_count,
    ROUND((coffee_count / SUM(coffee_count) OVER (PARTITION BY data_role)) * 100, 2) AS percentage
FROM ranked_coffees
WHERE rank = 1
