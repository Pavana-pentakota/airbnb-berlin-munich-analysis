# Data-quality log

Every problem I found in the raw data, what I decided, and why.
Source: Inside Airbnb. Berlin scraped 19 Sep 2026, Munich scraped 23 Sep 2026.

**Load check:** `raw_listings` has Berlin 12,376 and Munich 7,493 rows (total 19,869), matching the source files. Excel shows one more row per file because it counts the header line.

## Findings from profiling the raw data (01_profiling.sql)

| # | Table / column | Problem found | Rows affected | Decision | Why |
|---|---|---|---|---|---|
| 1 | raw_listings / id | Check for repeated listing ids (Q2) | 0 | Keep all rows | Ids are unique, so listing_id can be the primary key |
| 2 | raw_listings / price | Stored as text with a "$" sign and commas; every price starts with "$" (Q5) | 13,237 listings have a price | Remove "$" and ",", convert to a number | Text cannot be sorted or averaged correctly |
| 3 | raw_listings / price | **Price is missing for a third of the listings** (Q3). It happens in both cities: Berlin 4,219 of 12,376 (34.1%), Munich 2,413 of 7,493 (32.2%). 5,475 of the 6,632 (82.6%) are listings with no bookable days in the next 365 days (availability_365 = 0). 97.1% of those listings have no price, against 8.1% of the others (1,157 of 14,230) | 6,632 (33.4%) | Keep the listing, set price_valid = 0, leave price empty (NULL) | The listing is still useful for other questions. Price and revenue KPIs use only the 66.6% of listings with a price, and I say this openly |
| 4 | raw_listings / estimated_revenue_l365d | Missing for exactly the same number of listings as price (Q3) | 6,632 (33.4%) | Keep empty (NULL), use only listings with an estimate | Estimated revenue is based on price, so no price means no estimate |
| 5 | raw_listings / review_scores_rating | Missing rating (Q3) | 3,832 (19.3%) | Keep empty (NULL) | To confirm: probably listings without reviews yet, which is normal and not an error |
| 6 | raw_listings / neighbourhood_cleansed | No missing values (Q3). The host-typed column "neighbourhood" is not loaded | 0 | Use neighbourhood_cleansed | It is the complete version of the same information |
| 7 | raw_listings / minimum_nights | Missing minimum nights (Q3) | 178 (0.9%) | Keep empty (NULL), set is_short_term to unknown (NULL) | I do not guess whether these are short stays |
| 8 | raw_listings / bedrooms | Missing bedrooms (Q3) | 17 (0.1%) | Keep empty (NULL) | Too few to matter, and bedrooms is not used in the main KPIs |
| 9 | raw_listings / room_type | Four types, none missing (Q6): Entire home/apt 13,434 (67.6%), Private room 6,220 (31.3%), Hotel room 110 (0.6%), Shared room 105 (0.5%) | 0 | Keep all four types | Hotel room and Shared room are very small groups, so I interpret them with care |
| 10 | raw_listings / host_is_superhost | Stored as letters, none missing (Q6): t = 4,739 (23.9%), f = 15,130 (76.1%) | 19,869 | Convert t and f to 1 and 0 | Numbers are easier to count and average |
| 11 | raw_listings / instant_bookable | **Empty in every row** (Q6) | 19,869 (100%) | Not used in the project. I removed it from the clean table | A column with no values cannot answer any question |
| 12 | raw_listings / date columns | Stored as text in the format YYYY-MM-DD (Q7) | all rows | Convert to real dates | Needed for sorting and time analysis |
| 13 | raw_listings / name | German letters (ä, ö, ü) are stored correctly (Q8) | 0 | No action | The database uses utf8mb4 |
| 14 | raw_listings / amenities | Stored as a list in square brackets (Q9) | rows with amenities | Count the items into amenities_count | I need the number of amenities, not the list itself |
| 15 | raw_listings / availability_365 | 5,639 listings (28.4%) have no bookable day in the next 365 days | 5,639 | Keep them, do not delete. Find out why (blocked by the host, booked out, or inactive) before defining an active listing | They explain most of the missing prices, and they could bias the revenue KPIs |
| 16 | raw_listings / minimum_nights | A big group requires a minimum stay of 92 nights: 3,405 listings (17.1%) | 3,405 | Treat as long-stay: they get is_short_term = 0 | My project is about short-term rentals |

## Decisions to complete

| # | Table / column | Problem found | Rows affected | Decision | Why |
|---|---|---|---|---|---|
| 17 | clean_listings / price | Price of 0 | (fill in after the check) | Flag with price_valid = 0 | A price of 0 is not a real price |
| 18 | clean_listings / price | Extremely high prices. The top prices are 79,599.92, 68,392.00 and 10,025.00 | 135 (1.0% of the 13,237 listings with a price) | Flag with price_outlier = 1 above a cap of 1,000 per night. I keep the rows | The top prices are extremely unlikely to be normal nightly prices and would distort averages. A cap of 1,000 flags only about 1% of priced listings |
| 19 | clean_listings / minimum_nights | Long minimum stays, and 178 missing values | (fill in: number with is_short_term = 0, and number unknown) | Flag with is_short_term. 30 nights or less = short-term (1), more than 30 = long-stay (0), missing = unknown (empty) | My project is about short-term rentals |
| 20 | clean_listings / host_type | Need a host type for question 3 | (fill in counts per type) | Multi-listing = host with 2 or more listings; Single-listing = 1 listing; Unknown = value missing | Needed to compare professional and individual hosts |
| 21 | price currency | The "$" sign: unclear whether US dollars or just formatting | - | Check the Inside Airbnb data dictionary and write the answer here: ____ | Needed to label prices correctly |
