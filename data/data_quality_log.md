# Data-quality log

Every problem I find in the raw data, what I decided, and why.
Fill in the numbers from your own queries. Add a row for every new problem.

| # | Table / column | Problem found | Rows affected | Decision | Why |
|---|---|---|---|---|---|
| 1 | raw_listings / id | Check for repeated listing ids | (Q2 result) | Keep as is if none | A primary key needs unique ids |
| 2 | raw_listings / price | Stored as text with a "$" sign and commas | all rows with a price | Remove "$" and ",", convert to number | Text cannot be averaged or sorted correctly |
| 3 | raw_listings / price | Missing price | (Q3: price_missing) | Keep the listing, set price_valid = 0 | The listing is still useful for other KPIs |
| 4 | raw_listings / price | Price of 0 or extremely high | (count after cleaning) | Flag with price_valid / price_outlier, do not delete | Flagging keeps the data and lets me choose later |
| 5 | raw_listings / review_scores_rating | Missing rating | (Q3: rating_missing) | Keep NULL | Usually a listing with no reviews yet, not an error |
| 6 | raw_listings / neighbourhood | Column "neighbourhood" is often empty | (Q3) | Use neighbourhood_cleansed instead | It is the complete version of the same information |
| 7 | raw_listings / true-false columns | Stored as letters t and f | all rows | Convert to 1 and 0 | Numbers are easier to count and average |
| 8 | raw_listings / dates | Stored as text | all rows | Convert to real dates | Needed for sorting and time analysis |
| 9 | raw_listings / minimum_nights | Very long minimum stays | (count of is_short_term = 0) | Flag with is_short_term (30 nights or less) | My project is about short-term rentals |
| 10 | raw_listings / host listings | Need a host type | all rows | Multi-listing if host has 2 or more listings | Needed for question 3 (professional vs individual hosts) |
| 11 | raw_listings / estimated_* | Estimated occupancy and revenue come from Inside Airbnb | (missing count) | Use them and label them as estimates | Airbnb publishes no real sales |
| 12 | price currency | The "$" sign: unclear whether US dollars or formatted local currency | - | Check the Inside Airbnb data dictionary, then write the answer here | Needed to label prices correctly |
