# Data dictionary: the 32 columns I load

Source: Inside Airbnb listings file (90 columns, I keep 32) plus 1 column I add (`city`).
"Raw name" is the column in the file. "Clean name" is the name in my `clean_listings` table.
Meanings are in simple words. Check the official Inside Airbnb data dictionary if you need exact wording.

## About the listing

| Raw name | Clean name | What it means | Type after cleaning | Used for |
|---|---|---|---|---|
| id | listing_id | Airbnb's unique number for the listing | whole number | Primary key, joining tables |
| name | name | The title of the listing, as the host wrote it | text | Reading and checking |
| property_type | property_type | What kind of place it is, for example "Entire rental unit" | text | Describing the listing |
| room_type | room_type | Entire home/apt, Private room, Shared room or Hotel room | text | Question 2 and 4 |
| accommodates | accommodates | The maximum number of guests | whole number | Question 4 (price and size) |
| bathrooms | bathrooms | Number of bathrooms. **Empty in every row of my data** | decimal | Not used |
| bedrooms | bedrooms | Number of bedrooms | decimal | Describing size |
| beds | beds | Number of beds | decimal | Describing size |
| amenities | amenities_count | A list of features (Wi-Fi, kitchen, ...). I keep only how many | whole number | Question 4 (do more amenities mean a higher price?) |

## Location

| Raw name | Clean name | What it means | Type after cleaning | Used for |
|---|---|---|---|---|
| neighbourhood_cleansed | neighbourhood | The neighbourhood, assigned by Inside Airbnb from the map position | text | Question 1 |
| neighbourhood_group_cleansed | neighbourhood_group | A larger area that groups neighbourhoods (can be empty) | text | Optional grouping |
| latitude | latitude | North-south position on the map | decimal | Maps in Tableau |
| longitude | longitude | East-west position on the map | decimal | Maps in Tableau |

## Price and rules

| Raw name | Clean name | What it means | Type after cleaning | Used for |
|---|---|---|---|---|
| price | price | The nightly price the host asks, in local currency (euros). The raw data is text with a "$" sign | decimal | Questions 1, 2, 4 |
| minimum_nights | minimum_nights | The fewest nights a guest must book | whole number | Deciding short-term vs long-term |
| availability_365 | availability_365 | How many of the next 365 days the listing can be booked | whole number | Describing availability |
| license | has_license_number | The licence or registration number, if the host shows one. I keep only yes (1) or no (0) | 0 or 1 | Optional bonus question |

## Host

| Raw name | Clean name | What it means | Type after cleaning | Used for |
|---|---|---|---|---|
| host_id | host_id | Airbnb's unique number for the host | whole number | Grouping listings by host |
| host_since | host_since | The date the host joined Airbnb. **Empty in every row of my data** | date | Not used |
| host_is_superhost | is_superhost | Whether the host has Airbnb's Superhost badge (t = yes, f = no; I convert to 1 and 0) | 0 or 1 | Questions 3 and 4 |
| host_total_listings_count | host_total_listings | How many listings the host has, according to Airbnb. **Empty in every row of my data** | whole number | Not used |
| calculated_host_listings_count | host_listings_in_data | How many listings the host has in this dataset, counted by Inside Airbnb | whole number | Deciding host_type (question 3) |

## Reviews and estimates

| Raw name | Clean name | What it means | Type after cleaning | Used for |
|---|---|---|---|---|
| number_of_reviews | number_of_reviews | Total reviews the listing has ever received | whole number | Popularity |
| number_of_reviews_ltm | reviews_last_12m | Reviews received in the last 12 months | whole number | Recent activity |
| first_review | first_review | Date of the first review | date | Age of the listing |
| last_review | last_review | Date of the latest review | date | Recent activity |
| review_scores_rating | rating | Overall guest rating (out of 5) | decimal | Questions 2 and 3 |
| reviews_per_month | reviews_per_month | Average number of reviews per month | decimal | Activity level |
| estimated_occupancy_l365d | est_occupancy_l365d | Inside Airbnb's estimate of how much the listing was booked in the last 365 days (check the unit in their dictionary) | decimal | Estimated revenue |
| estimated_revenue_l365d | est_revenue_l365d | Inside Airbnb's estimate of the income in the last 365 days | decimal | Questions 1 and 6 |

## Technical

| Raw name | Clean name | What it means | Type after cleaning | Used for |
|---|---|---|---|---|
| last_scraped | scrape_date | The date Inside Airbnb collected the data | date | Stating how current the data is |
| (added by me) | city | Berlin or Munich | text | Comparing cities |
| instant_bookable | (removed) | Whether guests can book without host approval. Empty in all rows of my data | - | Not used |

## Columns I add in the cleaning

| Name | What it means |
|---|---|
| price_valid | 1 = usable price, 0 = price missing or zero |
| price_outlier | 1 = price above my cap, 0 = not, empty = no price |
| is_short_term | 1 = minimum stay of 30 nights or less, 0 = longer, empty = unknown |
| host_type | Multi-listing, Single-listing or Unknown |
