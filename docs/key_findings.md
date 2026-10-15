# Key findings from the SQL analysis

Source: Inside Airbnb. Berlin scraped 19 Sep 2026, Munich scraped 23 Sep 2026.

**Analysis set:** listings with a usable price, no price outlier, and a minimum stay of 30 nights or less.
Berlin 6,593 listings, Munich 4,872 listings (11,465 in total, 57.7% of all 19,869 listings).
Revenue is **estimated** (Inside Airbnb estimate for the last 365 days), not real income.

## 1. Berlin listings earn about twice as much as Munich listings, although Munich is more expensive

| | Berlin | Munich |
|---|---|---|
| Average price per night | 179 | 254 (42% higher) |
| Average estimated yearly revenue per listing | 24,764 | 11,829 (less than half of Berlin) |
| Average rating | 4.75 | 4.75 |
| Share of entire homes | 70.8% | 63.2% |

Careful: the revenue estimate is based on reviews, so part of the gap may come from the estimation method. I state this as a limit.

## 2. The best-earning neighbourhoods are in Berlin

The top 15 neighbourhoods by average estimated revenue (at least 30 listings each) are all in Berlin.
- Schloss Charlottenburg: 39,525 (57 listings, a small group)
- Prenzlauer Berg Suedwest: 37,612 (210 listings, a larger and more reliable group)
- Helmholtzplatz: 35,838 (117 listings)

Munich's best neighbourhoods rank lower. The Tableau ranking shows both cities side by side.

## 3. Hosts with several listings are a big part of the market, and they earn more but are rated lower

| | Berlin multi | Berlin single | Munich multi | Munich single |
|---|---|---|---|---|
| Listings | 4,036 | 2,557 | 1,918 | 2,954 |
| Average price | 186 | 168 | 264 | 248 |
| Average rating | 4.68 | 4.85 | 4.66 | 4.82 |
| Average estimated revenue | 26,641 | 21,800 | 18,169 | 7,712 |

Multi-listing hosts own 61.2% of Berlin's analysis set and 39.4% of Munich's.

## 4. What goes together with a higher price

- **Room type:** entire homes average 244, private rooms 143, hotel rooms 167, shared rooms 54 (both cities combined).
- **Capacity:** the price rises with the number of guests: 114 for 1 guest, 164 for 2, 253 for 4, 302 for 6 (about 42% of listings are for 2 guests).
- **Superhosts do not charge more** (207 against 213) but are rated higher (4.86 against 4.68).

"Goes together with" does not mean "causes".

## 5. Busy months

- **Berlin:** busiest from June to October (peak July with 12,889 reviews, lowest January with 6,610).
- **Munich:** peak in September (6,262 reviews), more than three times the February low (1,992). Oktoberfest may be one reason (to confirm).

Reviews are a rough sign of guest stays, not a count of bookings.

## First direction for the recommendation

Berlin looks stronger per listing. Entire homes for 2 to 4 guests in the high-revenue Berlin neighbourhoods look like the best starting point. Munich needs more care: higher prices, but much lower estimated revenue.
