USE air_bnb;

UPDATE clean_listings
SET
    -- price_valid: 1 = we have a usable price (not missing, not zero)
    price_valid   = CASE WHEN price IS NOT NULL AND price > 0 THEN 1 ELSE 0 END,

    -- price_outlier: 1 = nightly price above the cap. Here we given cap is 1000.
    price_outlier = CASE WHEN price > 1000 THEN 1 ELSE 0 END,

    -- is_short_term: 1 = minimum stay of 30 nights or less
    is_short_term = CASE WHEN minimum_nights <= 30 THEN 1 ELSE 0 END,

    -- host_type: a host with 2 or more listings counts as multi-listing
    host_type = CASE WHEN host_listings_in_data >= 2
                         THEN 'Multi-listing' ELSE 'Single-listing' END
WHERE listing_id > 0;   

-- this line keeps Workbench's Safe Updates mode happy

-- Checking quries :
Select price_valid from clean_listings where price_valid <0;  -- no less than 0 values
Select count(price_outlier) from clean_listings where price_outlier <1000; -- 19869 outliers are there in less than 1000.