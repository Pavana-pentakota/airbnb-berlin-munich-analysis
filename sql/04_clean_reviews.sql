USE air_bnb;
-- DROP TABLE IF EXISTS removes the old version first.
DROP TABLE IF EXISTS clean_reviews;

-- Creating new Table.
-- Not changing anything in original table because, if any mistake happend, no need to worry about the original data.
CREATE TABLE clean_reviews AS
SELECT listing_id, city, review_date,
    YEAR(review_date) AS review_year, MONTH(review_date) AS review_month
FROM (SELECT
        CAST(listing_id AS UNSIGNED) AS listing_id, city,
        STR_TO_DATE(date, '%Y-%m-%d') AS review_date
    FROM raw_reviews) AS r;
    
--- checking table created or not.
select * from clean_reviews;
select count(review_year) from clean_reviews;

-- An INDEX works like the index of a book: finding a listing's reviews becomes fast.
CREATE INDEX idx_reviews_listing ON clean_reviews (listing_id);
