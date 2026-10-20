USE air_bnb;


-- Q1. Are all rows there? 
SELECT city, COUNT(*) AS listings
FROM raw_listings
GROUP BY city;
#Ans : Berlin-12376, Munich-7493

-- Q2. Is any listing id repeated? 
SELECT id, COUNT(*) AS times_found
FROM raw_listings
GROUP BY id
HAVING COUNT(*) > 1;
#Ans : nothing shown. No Id's are repeated.

-- Q3. How many missing values in the important columns?
-- (SUM of a true/false test counts the rows where the test is true)
SELECT
    SUM(price IS NULL OR TRIM(price) = '') AS price_missing,
    SUM(neighbourhood_cleansed IS NULL OR TRIM(neighbourhood_cleansed) = '') AS neighbourhood_missing,
    SUM(review_scores_rating IS NULL OR TRIM(review_scores_rating) = '') AS rating_missing,
    SUM(minimum_nights IS NULL OR TRIM(minimum_nights) = '') AS min_nights_missing,
    SUM(bedrooms IS NULL OR TRIM(bedrooms) = '') AS bedrooms_missing,
    SUM(estimated_revenue_l365d IS NULL OR TRIM(estimated_revenue_l365d) = '') AS est_revenue_missing
FROM raw_listings;
-- price_missing-6632, neighbourhood_missing-0, rating_missing-3832, min_nights_missing-178, bedrooms_missing-17, est_revenue_missing-6632.

-- Q4. What does the price column look like? (text with a dollar sign)
SELECT price FROM raw_listings WHERE price IS NOT NULL LIMIT 10;

-- Q5. Does any price NOT start with a dollar sign? (expect: no rows)
SELECT price FROM raw_listings
WHERE price IS NOT NULL AND TRIM(price) <> '' AND price NOT LIKE '$%'
LIMIT 10;
-- No price is there with $ dollor sign

-- Q6. Which values exist in the category columns?
SELECT room_type, COUNT(*) AS listings FROM raw_listings GROUP BY room_type ORDER BY listings DESC;
-- Entire home/apt-13434, Private room-6220, Hotel room 110, Shared room 105.alter
SELECT host_is_superhost, COUNT(*) AS listings FROM raw_listings GROUP BY host_is_superhost;
--- f-15130, t-4739
SELECT instant_bookable, COUNT(*) AS listings FROM raw_listings GROUP BY instant_bookable;
-- Instant_bookable-null, listings-19869

-- Q7. whats the date format?
SELECT host_since, first_review, last_review, last_scraped FROM raw_listings LIMIT 5;
-- YYYY-MM-DD

-- Q8. Is the German text stored correctly?
SELECT name, neighbourhood_cleansed FROM raw_listings LIMIT 10;
-- yes

-- Q9. Do the amenities look like a list in square brackets?
SELECT amenities FROM raw_listings WHERE amenities IS NOT NULL LIMIT 3;
--- amenities are in list format with square brackers.
