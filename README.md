# Netflix Streaming Content Analysis (2008–2020) (March 2025 - Present) (Work in Progress)
This project explores trends in Netflix's content from January 2008 to January 2020 using a cleaned and transformed [dataset](https://public.tableau.com/app/learn/sample-data) from Tableau Public.
It analyzes growth trends, genre and rating distributions, and country-level contributions — offering insight into how Netflix’s global catalog has evolved.

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
    * `netflix_titles_working_sheet`
    * `netflix_titles_category`
    * `netflix_titles_countries`
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

  _Note: `year_added` and `years_added_after_release` are not fields from the original dataset. I added these columns to create a measure of how many years after relase a title was added to Netflix for future analyses._

  `netflix_titles_category`
  
  | Field | Description |
  | -------- | ----------- |
  | `listed_in` | Original genre for the title |
  | `show_id` | ID for the TV Show or Movie |

   _Note: Titles with more than one genre had one row for each genre._

  `netflix_titles_countries`
  
  | Field | Description |
  | -------- | ----------- |
  | `country` | Country the title originated from |
  | `show_id` | ID for the TV Show or Movie |

- Joined 2 CSVs that acted as mapping tables
    * `genre_mapping` maps the original genre to a normalized genre, ie TV Drama and Drama just become one genre: Drama
    * `rating_mapping` maps the original ratings to a label such as `Kid-Friendly`, `Teen`, `Adult`, or `Not Rated`

## Dataset Preparation
Most of the dataset preparation and cleaning was done in Excel:
- In entries with a missing `rating` field, I looked up the rating on Google and filled it in myself
    * about 9 entries, or ~0.14% of entries, were affected here
- Entries with a missing `date_added` field were removed, since a lot of my analysis relies on this field
    * about 11 entries, or ~0.17% of entries, were removed
- 4 entries had dates as titles, so I changed the datatype to string for consistency with the rest of the dataset
- 2 entries had data overflowing to the next row, so I bumped the overflow back to the original row with a close attention to detail
- 95 entries had a `rating` of `TV-Y7-FV`, which I changed to just `TV-Y7` since it is a very similar rating, in order to normalize `ratings` for a more cohesive analysis
- 7 entries had `UR` rating, which I changed to `NR` to have a more cohesive analysis since these ratings mean the same thing
- There were 2 duplicate entries, of which I removed the duplicates if they had the same dates and descriptions
- Created a column to denote the number of years after release that the show or movie was added to Netflix
     * Some values were negative, so I set them to be 0 since it doesn't make sense that the show or movie was added to Netflix years before it was released.
     * This affected about 9 entries, or 0.14%

## Dashboard Pages
The interactive dashboard consists of five pages: 
| Page    | Focus |
| -------- | ------- |
| **Overview**  | KPIs, growth trends, content breakdown by type |
| **Genre Breakdown** | Genre distribution over time and by type |
| **Rating Analysis**    | Categorized ratings (Kid, Teen, Adult) over time and by genre |
| **Country Analysis**    | Top contributing countries and their top genres |
| **Explorer Page**    | Interactive searchable table of all titles with filters |

## Key Insights

## Project Assets
- Power BI Report: [`Netflix Insights Dashboard.pbix`](https://github.com/alexisbl14/netflix-content-analysis-2008-2020/blob/main/Netflix%20Insights%20Dashboard.pbix)
- PDF Export (Static Power BI Report): [`Netflix Insights Dashboard.pdf`](https://github.com/alexisbl14/netflix-content-analysis-2008-2020/blob/main/Netflix%20Insights%20Dashboard.pdf)
- Dashboard Screenshots:
- Dataset Source: [Tableau Public Datasets](https://public.tableau.com/app/learn/sample-data)

## How to View the Project
1. Open the `.pbix` file in Power BI Desktop
2. Explore the dashboard pages using slicers and buttons
3. Use slicers to drill into specific years, countries, or rating categories
4. Alternatively, view the exported visuals in (name of dashboard pdf)

## Author
**Alexis Lydon**  
*Aspiring Data Analyst and Software Developer · UC Davis B.S. Computer Science*  
[Email](mailto:alexisblydon@gmail.com) · [LinkedIn](https://www.linkedin.com/in/alexis-lydon-477498223/) · [My Portfolio](https://alexisbl14.github.io/personal-portfolio/)

---
