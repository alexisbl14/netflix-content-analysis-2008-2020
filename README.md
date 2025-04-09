# Netflix Streaming Content Analysis (2008–2020)
This project explores trends in Netflix's content from January 2008 to January 2020 using a cleaned and transformed [dataset](https://public.tableau.com/app/learn/sample-data) from Tableau Public.
It analyzes growth trends, genre and rating distributions, and country-level contributions — offering insight into how Netflix’s global catalog has evolved.

## Project Timeline
I contributed to this project from March 2025 to April 2025.

## Project Highlights
- **Tools Used**: SQL · Excel · Power BI · DAX
- **Data Cleaning**: Normalized multi-genre and multi-country fields, handled any missing/invalid values, removed any duplicate entries
- **Dashboard Features**: Slicers, bookmarks, KPI Cards, dynamic titles, DAX-powered insights
- **Focus Areas**: Genre trends, rating categories, country analysis, YoY growth

## Skills Demonstrated
- **SQL**: Filtering, joining, CTEs, aggregation
- **Excel**: Data cleaning, formatting, preprocessing
- **Power BI**: Data modeling, relationship design, calculated columns
- **DAX**: Measures for YoY growth, ranking, conditional categories, dynamic text
- **Dashboard Design**: Clean, responsive layout, multi-page navigation, tooltips, card KPIs

## Dataset Overview
- **Source**: [Excel](https://public.tableau.com/app/learn/sample-data) table with 5 sheets
- Cleaned and joined 3 CSVs from the original dataset
    * `netflix_titles`
    * `netflix_titles_category`
    * `netflix_titles_countries`
- Joined 2 CSVs that acted as mapping tables
    * `genre_mapping` maps the original genre to a normalized genre, ie TV Drama and Drama just become one genre: Drama
    * `rating_mapping` maps the original ratings to a label such as `Kid-Friendly`, `Teen`, `Adult`, or `Not Rated`
- **Data Cards**: The following tables describe the 3 CSV files with data from the source.
  
  `netflix_titles_description`
  
  | Field | Description |
  | -------- | ----------- |
  | `duration_minutes` | Duration of a movie in minutes, blank for TV Shows |
  | `duration_seasons` | Duration of a TV Show in seasons, blank for Movies |
  | `type` | Type of the title, can be `TV Show` or `Movie` |
  | `title` | Name of the TV Show or Movie on Netflix |
  | `date_added` | The date the title was added to Netflix |
  | `release_year` | The year the title was released |
  | `rating` | Rating as given by the Movie/TV Show rating system, ie `TV-14`, `PG-13`, `R`, etc|
  | `description` | Short description of the TV Show or Movie |
  | `show_id` | ID for the TV Show or Movie, also used as the primary key |
  | `year_added` | Year the title was added to Netflix |
  | `years_added_after_release` | Denotes the number of years after the title was released that it was added to Netflix |

  _Note: `year_added` and `years_added_after_release` were created for temporal analysis._

  `netflix_titles_category`
  
  | Field | Description |
  | -------- | ----------- |
  | `listed_in` | Original genre for the title |
  | `show_id` | ID for the TV Show or Movie |

   _Note: Titles with multiple genres appear as separate rows._

  `netflix_titles_countries`
  
  | Field | Description |
  | -------- | ----------- |
  | `country` | Country the title originated from |
  | `show_id` | ID for the TV Show or Movie |

### ERD Diagram
![ERD Diagram](./assets/Netflix%20Data%20Analysis%20ERD%20Diagram.png)


## Dataset Preparation
The dataset included over 6,000 Netflix titles with different attributes, and the data required a bit of cleaning and restructuring.
Most of the dataset preparation and cleaning was done in Excel:
- Looked up and filled in 9 missing ratings manually (~0.14% of entries)
- Removed 11 entries with a missing `date_added` since a lot of my analysis relies on this field (~0.17% of entries)
- 4 entries had dates as titles, so I changed the datatype to string for consistency with the rest of the dataset
- Fixed 2 overflowed rows with manual correction and a close attention to detail
- Normalized 95 entries with a `rating` of `TV-Y7-FV` to  `TV-Y7` and 7 entries with a `rating` of `UR` to `NR` for a more cohesive analysis
- Removed 2 duplicate entries (same dates and descriptions along with show_id and title)
- Added `years_added_after_release` column to denote the number of years after release that the show or movie was added to Netflix and set negatives to 0 (~9 entries or 0.14%)
- Joined 5 tables using `show_id` as the primary key
- Created mapping tables for genres and ratings

## Exploratory Data Analysis
After preparing and cleaning the datasets, I performed exploratory data analysis (EDA) to better understand content patterns and identify areas of interest for the dashboard.
Some interesting tables were exported, and are denoted by a comment `(Exported)` next to the query. These exports include:
- `titles_with_normalized_genres_view` : A view for a table with the titles and normalized genres that was reused throughout the EDA
- `yoy_growth` : Year over year growth in number of titles added to netflix
- `genre_year_counts` : Counts of genres per year
- `rating_category_breakdown` : Case breakdown of ratings between kid-friendly, teen, adult

By analyzing genre frequencies, rating distributions, and country-level contributions, I identified patterns that guided both the layout and the analytical depth of each dashboard page. Trends uncovered during EDA, such as the rising dominance of TV Shows since 2017 and the dramatic year-over-year growth after 2016, helped prioritize visualizations like KPI cards and YoY trend lines in the Overview page. Ultimately, EDA served not just as a discovery tool, but as a design framework that made the dashboard more meaningful and user-focused.

## Dashboard Pages
The interactive dashboard consists of five pages: 

**1. Overview** 
A summary of total titles, content and growth trends over time, and type breakdown (Movies vs TV Shows). Includes YoY growth and slicers for filtering by genre, country, rating, release year, and type.

**2. Genre Breakdown**
Explores the most popular genres overall and by content type, as well as the genre distribution over time.

**3. Rating Analysis**
Groups content ratings into Kid-Friendly, Teen, Adult, and Not Rated categories. Visualizes the shift in rating types over time and highlights the most common categories per genre.

**4. Country Analysis**
Examines which countries contribute the most titles to Netflix's catalog and what genres are most commone in each. Includes a treemap and top genres for the top countries. 

**5. Explorer Page**
A search table for users to filter and explore individual titles by genre, release year, duration (seasons or minutes), rating category, and type.

## Key Insights
- **International titles** made up over **70%** of **non-US content**, reflecting Netflix's global expansion. This may also indicate that content not produced in the U.S. is frequently labeled as “International” by default, rather than by a specific genre, which could obscure cultural or thematic distinctions.
- **42.8%** of titles originate from the **United States** - more than any other country in the dataset. This highlights the U.S. as Netflix’s primary content source, despite global diversification in later years.
- **Adult-rated content** (TV-MA, R) grew from **24%** of total titles to **44%** of total titles between **2015–2018**, overtaking Kid-Friendly and Teen categories post-2016. This trend may reflect a strategic shift toward more mature audiences — potentially increasing exposure to adult themes among teens during that time, as age-based content restrictions on Netflix remained minimal.
- Since **2017**, **TV Shows** have outpaced **Movies** in growth, aligning with Netflix’s pivot toward episodic, binge-watchable content formats. This change mirrors the platform’s investment in original series and audience engagement through serialized storytelling.
- Countries like **Japan**, **Korea**, and the **UK** contribute highly niche or genre specific content (eg Anime, Korean TV Shows, British TV Shows), suggesting strong regional variation.
- **Content diversity** has increased **post-2016**, with more **niche genres** like **LGBTQ+**, **Faith & Spirituality**, and **Science/Nature** content entering the catalog, reflecting broader inclusivity and a widening appeal to diverse audiences.
- Starting in **2016**, Netflix saw a **rapid growth** in the **number of titles** added to the platform. This is most likely due to a number of factors including a global expansion into 130 new countries, the launch of popular original series, and a shift in consumer media consumption habits.

## Project Assets
- Power BI Report: [`Netflix Insights Dashboard.pbix`](https://github.com/alexisbl14/netflix-content-analysis-2008-2020/blob/main/Netflix%20Insights%20Dashboard.pbix)
- PDF Export (Static Power BI Report): [`Netflix Insights Dashboard.pdf`](https://github.com/alexisbl14/netflix-content-analysis-2008-2020/blob/main/Netflix%20Insights%20Dashboard.pdf)
- Dashboard Screenshots: [`/assets/`](./assets)
- Dataset Source: [Tableau Public Datasets](https://public.tableau.com/app/learn/sample-data)
- SQL Exploratory Data Analysis: [`netflix_titles_analysis.sql`](https://github.com/alexisbl14/netflix-content-analysis-2008-2020/blob/main/netflix_titles_analysis.sql)
- CSV Data and SQL Query Outputs: [`/data`](./data)

## How to View the Project
1. Open the `.pbix` file in Power BI Desktop
2. Explore the dashboard pages using slicers and buttons
3. Use slicers to drill into specific years, countries, or rating categories
4. Alternatively, view the exported visuals in (name of dashboard pdf)

## Future Exploration
- Find top rating categories by country.
- Transfer the interactive dashboard on Power BI into a Tableau Public dashboard.

## Author
**Alexis Lydon**  
*Aspiring Data Analyst and Software Developer · UC Davis B.S. Computer Science*  
[Email](mailto:alexisblydon@gmail.com) · [LinkedIn](https://www.linkedin.com/in/alexis-lydon-477498223/) · [My Portfolio](https://alexisbl14.github.io/personal-portfolio/)

---
