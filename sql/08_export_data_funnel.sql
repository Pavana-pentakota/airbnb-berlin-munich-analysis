-- Expected : data_funnel.csv
USE air_bnb;

SELECT 1 AS step, 'All listings' AS stage, COUNT(*) AS listings
FROM clean_listings
UNION ALL
SELECT 2, 'With a usable price', COUNT(*)
FROM clean_listings
WHERE price_valid = 1
UNION ALL
SELECT 3, 'Price not an outlier', COUNT(*)
FROM clean_listings
WHERE price_valid = 1 AND price_outlier = 0
UNION ALL
SELECT 4, 'Short-term stay (30 nights or less)', COUNT(*)
FROM clean_listings
WHERE price_valid = 1 AND price_outlier = 0 AND is_short_term = 1
ORDER BY step;
