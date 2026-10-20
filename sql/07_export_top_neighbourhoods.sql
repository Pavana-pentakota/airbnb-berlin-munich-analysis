-- =====================================================================
-- 07_export_top_neighbourhoods.sql   |   Ranking file for Tableau
-- Top 10 neighbourhoods per city by average estimated yearly revenue.
-- Only neighbourhoods with at least 30 listings count, because a few
-- listings can give a misleading average.
-- ROW_NUMBER() ... PARTITION BY city numbers the neighbourhoods 1, 2, 3...
-- separately inside each city, from the highest revenue down.
-- Export: run the query, click Export in the Result Grid, choose CSV,
-- save as top_neighbourhoods.csv
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
