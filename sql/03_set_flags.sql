USE air_bnb;


UPDATE clean_listings
SET
    -- price_valid: 1 = usable price, 0 = price missing or zero
    price_valid = CASE WHEN price IS NULL THEN 0 
					WHEN price IS NOT NULL AND price > 0 THEN 1 ELSE 0 END,

    -- price_outlier: 1 = nightly price above the cap (CHANGE 1000 IF NEEDED)
    --                NULL = no price, so we cannot say
    price_outlier = CASE WHEN price IS NULL THEN 0
                         WHEN price > 1000 THEN 1 ELSE 0 END,

    -- is_short_term: 1 = minimum stay of 30 nights or less
    --                NULL = minimum nights missing, so we cannot say
    is_short_term = CASE WHEN minimum_nights IS NULL THEN 0
                         WHEN minimum_nights <= 30 THEN 1 ELSE 0 END,

    -- host_type: 2 or more listings = multi-listing host
    host_type     = CASE WHEN host_listings_in_data IS NULL THEN 'Unknown'
                         WHEN host_listings_in_data >= 2 THEN 'Multi-listing'
                         ELSE 'Single-listing' END
WHERE listing_id > 0;   -- this line keeps Workbench's Safe Updates mode happy

SELECT COUNT(*) FROM clean_listings; 
#19869 
