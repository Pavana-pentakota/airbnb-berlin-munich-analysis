USE air_bnb;


DROP TABLE IF EXISTS clean_listings;

CREATE TABLE clean_listings AS
SELECT
    -- PATTERN 1: whole numbers (ids). CAST changes the data type.
    CAST(id AS UNSIGNED)                                         AS listing_id,

    -- PATTERN 2: text stays text. We only give some columns clearer names.
    city,
    name,
    CAST(NULLIF(TRIM(host_id), '') AS UNSIGNED)                  AS host_id,

    -- PATTERN 3: dates. STR_TO_DATE reads text like 2019-07-01 as a real date.
    -- TRIM removes spaces; NULLIF turns an empty text '' into NULL (= missing).
    STR_TO_DATE(NULLIF(TRIM(host_since), ''), '%Y-%m-%d')        AS host_since,

    -- PATTERN 4: true/false letters become 1 and 0 (anything else stays NULL).
    CASE host_is_superhost WHEN 't' THEN 1 WHEN 'f' THEN 0 END   AS is_superhost,

    -- PATTERN 5: counts that may be written like 3.0. We read them as
    -- decimals first, then turn them into whole numbers (SIGNED).
    CAST(CAST(NULLIF(TRIM(host_total_listings_count), '') AS DECIMAL(12,2)) AS SIGNED)
                                                                 AS host_total_listings,
    CAST(CAST(NULLIF(TRIM(calculated_host_listings_count), '') AS DECIMAL(12,2)) AS SIGNED)
                                                                 AS host_listings_in_data,

    neighbourhood_cleansed                                       AS neighbourhood,
    neighbourhood_group_cleansed                                 AS neighbourhood_group,

    -- PATTERN 6: decimals (coordinates, rooms, ratings).
    CAST(NULLIF(TRIM(latitude), '')  AS DECIMAL(9,6))            AS latitude,
    CAST(NULLIF(TRIM(longitude), '') AS DECIMAL(9,6))            AS longitude,
    property_type,
    room_type,
    CAST(CAST(NULLIF(TRIM(accommodates), '') AS DECIMAL(12,2)) AS SIGNED) AS accommodates,
    CAST(NULLIF(TRIM(bathrooms), '') AS DECIMAL(5,1))            AS bathrooms,
    CAST(NULLIF(TRIM(bedrooms), '')  AS DECIMAL(5,1))            AS bedrooms,
    CAST(NULLIF(TRIM(beds), '')      AS DECIMAL(5,1))            AS beds,

    -- amenities is a list in square brackets: we only need HOW MANY items it has.
    CASE WHEN JSON_VALID(amenities) THEN JSON_LENGTH(amenities) END AS amenities_count,

    -- PATTERN 7: the price. Remove the $ and the commas, then make it a number.
    CAST(REPLACE(REPLACE(NULLIF(TRIM(price), ''), '$', ''), ',', '') AS DECIMAL(10,2))
                                                                 AS price,

    CAST(CAST(NULLIF(TRIM(minimum_nights), '') AS DECIMAL(12,2)) AS SIGNED)         AS minimum_nights,
    CAST(CAST(NULLIF(TRIM(availability_365), '') AS DECIMAL(12,2)) AS SIGNED)       AS availability_365,
    CAST(CAST(NULLIF(TRIM(number_of_reviews), '') AS DECIMAL(12,2)) AS SIGNED)      AS number_of_reviews,
    CAST(CAST(NULLIF(TRIM(number_of_reviews_ltm), '') AS DECIMAL(12,2)) AS SIGNED)  AS reviews_last_12m,

    -- Inside Airbnb's own estimates (we label them as estimates in the project)
    CAST(NULLIF(TRIM(estimated_occupancy_l365d), '') AS DECIMAL(10,2)) AS est_occupancy_l365d,
    CAST(NULLIF(TRIM(estimated_revenue_l365d), '')   AS DECIMAL(14,2)) AS est_revenue_l365d,

    STR_TO_DATE(NULLIF(TRIM(first_review), ''), '%Y-%m-%d')      AS first_review,
    STR_TO_DATE(NULLIF(TRIM(last_review), ''),  '%Y-%m-%d')      AS last_review,
    CAST(NULLIF(TRIM(review_scores_rating), '') AS DECIMAL(4,2)) AS rating,

    -- 1 = the listing shows a licence/registration number, 0 = it does not.
    CASE WHEN license IS NULL OR TRIM(license) = '' THEN 0 ELSE 1 END AS has_license_number,

    CAST(NULLIF(TRIM(reviews_per_month), '') AS DECIMAL(8,2))    AS reviews_per_month,
    STR_TO_DATE(NULLIF(TRIM(last_scraped), ''), '%Y-%m-%d')      AS scrape_date
FROM raw_listings;

-- A PRIMARY KEY makes every listing_id unique and fast to find.
ALTER TABLE clean_listings ADD PRIMARY KEY (listing_id);

-- Empty columns for our flags. We fill them in the next script.
-- We do NOT delete any rows: we only mark them, so nothing is lost.
ALTER TABLE clean_listings
    ADD COLUMN price_valid    TINYINT,
    ADD COLUMN price_outlier  TINYINT,
    ADD COLUMN is_short_term  TINYINT,
    ADD COLUMN host_type      VARCHAR(20);
