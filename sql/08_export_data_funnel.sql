-- =====================================================================
-- 08_export_data_funnel.sql   |   How 19,869 listings become 11,465
-- Four steps, each one smaller than the one before.
-- Export: run the query, click Export in the Result Grid, choose CSV,
-- save as data_funnel.csv
-- Expected result: 19,869 / 13,237 / 13,102 / 11,465
-- =====================================================================
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
