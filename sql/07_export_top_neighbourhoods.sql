-- Export: top_neighbourhoods.csv
-- =====================================================================
USE air_bnb;

SELECT city, neighbourhood, listings, avg_price, avg_est_revenue, revenue_rank
FROM (
    SELECT city, neighbourhood,
           COUNT(*) AS listings,
           ROUND(AVG(price), 0) AS avg_price,
           ROUND(AVG(est_revenue_l365d), 0) AS avg_est_revenue,
           ROW_NUMBER() OVER (PARTITION BY city
                              ORDER BY AVG(est_revenue_l365d) DESC) AS revenue_rank
    FROM v_analysis_listings
    WHERE est_revenue_l365d IS NOT NULL
    GROUP BY city, neighbourhood
    HAVING COUNT(*) >= 30
) AS ranked
WHERE revenue_rank <= 10
ORDER BY city, revenue_rank;
