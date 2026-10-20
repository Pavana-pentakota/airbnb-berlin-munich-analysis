USE air_bnb;

-- EXPORT 1: one row per listing (save as listings_tableau.csv)
-- We leave out the listing title (name) on purpose: it is free text typed by the
-- hosts and can contain commas and quotation marks, which can break a CSV file.
-- We also leave out the columns that are empty in the 2026 data.
-- in_analysis_set = 1 means: usable price, not an outlier, short-term.
SELECT listing_id, city, host_id, is_superhost, host_listings_in_data, host_type,
       neighbourhood, neighbourhood_group, latitude, longitude,
       property_type, room_type, accommodates, bedrooms, beds, amenities_count,
       price, minimum_nights, availability_365, number_of_reviews, reviews_last_12m,
       est_occupancy_l365d, est_revenue_l365d, first_review, last_review, rating,
       has_license_number, reviews_per_month, scrape_date,
       price_valid, price_outlier, is_short_term,
       CASE WHEN price_valid = 1 AND price_outlier = 0 AND is_short_term = 1
            THEN 1 ELSE 0 END AS in_analysis_set,
       CASE WHEN availability_365 > 0 THEN 'Bookable' ELSE 'No bookable days' END AS booking_status
FROM clean_listings;

-- EXPORT 2: reviews per city and month (save as reviews_monthly.csv)
SELECT city, review_year, review_month, COUNT(*) AS reviews
FROM clean_reviews
GROUP BY city, review_year, review_month
ORDER BY city, review_year, review_month;

USE air_bnb;
SELECT city, COUNT(*) AS listings, ROUND(AVG(est_occupancy_l365d), 1) AS avg_est_occupancy,
       MAX(est_occupancy_l365d) AS max_est_occupancy, ROUND(AVG(est_revenue_l365d), 0) AS avg_est_revenue
FROM v_analysis_listings GROUP BY city;
