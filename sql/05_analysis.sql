USE air_bnb;

-- ---------------------------------------------------------------------
-- STEP 0. The "analysis set": the listings we trust for price and revenue
-- A listing is in the set when it has a usable price (price_valid = 1),
-- the price is not an outlier (price_outlier = 0) and it is a
-- short-term rental (is_short_term = 1).
-- A VIEW is a saved question. 
-- ---------------------------------------------------------------------
DROP VIEW IF EXISTS v_analysis_listings;
CREATE VIEW v_analysis_listings AS
SELECT *
FROM clean_listings
WHERE price_valid = 1
  AND price_outlier = 0
  AND is_short_term = 1;

-- Check: how big is the analysis set, per city?
SELECT city, COUNT(*) AS listings_in_analysis_set
FROM v_analysis_listings
GROUP BY city;
-- Berlin 6593, Munich 4872

-- ---------------------------------------------------------------------
-- Q1. Which neighbourhoods earn the most per listing?
-- We ignore neighbourhoods with fewer than 30 listings, because a few
-- listings can give a misleading average.
-- ---------------------------------------------------------------------
SELECT city, neighbourhood,
       COUNT(*) AS listings,
       ROUND(AVG(price), 0) AS avg_price,
       ROUND(AVG(est_revenue_l365d), 0) AS avg_est_revenue
FROM v_analysis_listings
WHERE est_revenue_l365d IS NOT NULL
GROUP BY city, neighbourhood
HAVING COUNT(*) >= 30
ORDER BY avg_est_revenue DESC
LIMIT 15;

-- ---------------------------------------------------------------------
-- Q2. How do Berlin and Munich differ?
-- AVG(room_type = 'Entire home/apt') is the share of entire homes (0 to 1).
-- ---------------------------------------------------------------------
SELECT city,
       COUNT(*) AS listings,
       ROUND(AVG(price), 0) AS avg_price,
       ROUND(AVG(rating), 2) AS avg_rating,
       ROUND(100 * AVG(room_type = 'Entire home/apt'), 1) AS pct_entire_home,
       ROUND(AVG(est_revenue_l365d), 0) AS avg_est_revenue
FROM v_analysis_listings
GROUP BY city;

-- ---------------------------------------------------------------------
-- Q3. Professional (multi-listing) hosts vs individual hosts
-- ---------------------------------------------------------------------
SELECT city, host_type,
       COUNT(*) AS listings,
       ROUND(AVG(price), 0) AS avg_price,
       ROUND(AVG(rating), 2) AS avg_rating,
       ROUND(AVG(est_revenue_l365d), 0)  AS avg_est_revenue
FROM v_analysis_listings
GROUP BY city, host_type
ORDER BY city, host_type;

-- Q4. What goes together with a higher price?
-- (Careful: "goes together with" is not "causes".)
SELECT room_type, COUNT(*) AS listings, ROUND(AVG(price), 0) AS avg_price
FROM v_analysis_listings
GROUP BY room_type
ORDER BY avg_price DESC;

SELECT is_superhost, COUNT(*) AS listings,
       ROUND(AVG(price), 0) AS avg_price, ROUND(AVG(rating), 2) AS avg_rating
FROM v_analysis_listings
GROUP BY is_superhost;

SELECT accommodates AS guests, COUNT(*) AS listings, ROUND(AVG(price), 0) AS avg_price
FROM v_analysis_listings
WHERE accommodates BETWEEN 1 AND 8
GROUP BY accommodates
ORDER BY accommodates;

-- Q5. When is guest activity highest? Reviews per month in 2025
-- (the last full year in the data). Reviews are a rough sign of stays.
SELECT city, review_month, COUNT(*) AS reviews
FROM clean_reviews
WHERE review_year = 2025
GROUP BY city, review_month
ORDER BY city, review_month;
