USE netflix;

SELECT * FROM netflix_titles_working_sheet;

DESCRIBE netflix_titles_working_sheet;

SELECT * FROM netflix_titles_category;

DESCRIBE netflix_titles_category;

-- Get count of total titles
SELECT COUNT(*) AS total_titles
FROM netflix_titles_working_sheet;

-- Convert string to date
SELECT date_added, str_to_date(date_added, '%m/%d/%Y')
FROM netflix_titles_working_sheet
LIMIT 10;

-- Get first 10 titles added to Netflix (from dataset given)
SELECT title 
FROM netflix_titles_working_sheet
ORDER BY str_to_date(date_added, '%m/%d/%Y') ASC
LIMIT 10;

-- Get most recent titles added
SELECT title 
FROM netflix_titles_working_sheet
ORDER BY str_to_date(date_added, '%m/%d/%Y') DESC
LIMIT 5;

-- Get all TV Shows released in 2020
SELECT title
FROM netflix_titles_working_sheet
WHERE type = 'TV Show' AND release_year = 2020;

-- Distinct content ratings
SELECT DISTINCT rating
FROM netflix_titles_working_sheet;

-- List all titles with rating of TV-MA
SELECT *
FROM netflix_titles_working_sheet
WHERE rating = 'TV-MA';

-- Count of movies vs tv shows
SELECT type, COUNT(*) AS total
FROM netflix_titles_working_sheet
GROUP BY type;

-- Count of titles added each year
SELECT year_added, COUNT(*) AS total
FROM netflix_titles_working_sheet
GROUP BY year_added
ORDER BY 2 DESC;

-- Most common content rating
SELECT rating, COUNT(*) AS total
FROM netflix_titles_working_sheet
GROUP BY rating
ORDER BY 2 DESC;

-- average duration of movie
SELECT AVG(duration_minutes) as 'average movie duration'
FROM netflix_titles_working_sheet
WHERE type = 'Movie';

-- average duration of tv show
SELECT AVG(duration_seasons) as 'average tv show duration'
FROM netflix_titles_working_sheet
WHERE type = 'TV Show';

-- joining netflix titles with netflix titles category (genre)
SELECT t.show_id AS show_id , t.title as title, t.type as type, t.release_year as release_year, c.listed_in AS genre
FROM netflix_titles_working_sheet t
JOIN netflix_titles_category c
ON t.show_id = c.show_id;

-- using join as a cte to find count of all genres
WITH Titles_Plus_Categories AS 
(
SELECT t.show_id AS show_id , t.title as title, t.type as type, t.release_year as release_year, c.listed_in AS genre
FROM netflix_titles_working_sheet t
JOIN netflix_titles_category c
ON t.show_id = c.show_id
)
SELECT genre, COUNT(*) AS total
FROM Titles_Plus_Categories
GROUP BY genre
ORDER BY 2 DESC;

-- using join as a cte to find count of all genres with release year after 2015
WITH Titles_Plus_Categories AS 
(
SELECT t.show_id AS show_id , t.title as title, t.type as type, t.release_year as release_year, c.listed_in AS genre
FROM netflix_titles_working_sheet t
JOIN netflix_titles_category c
ON t.show_id = c.show_id
)
SELECT genre, COUNT(*) AS total
FROM Titles_Plus_Categories
WHERE release_year > 2015
GROUP BY genre
ORDER BY 2 DESC;

-- what rating is most common for each content type
SELECT type, rating, COUNT(*) AS total
FROM netflix_titles_working_sheet
GROUP BY type, rating
ORDER BY 1, 3 DESC;

-- same query as above but using rank
WITH rating_ranked AS
(
	SELECT type, rating, COUNT(*) AS total,
    RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rank_num
    FROM netflix_titles_working_sheet
    GROUP BY type, rating
)
SELECT *
FROM rating_ranked
WHERE rank_num = 1;

-- genres that appear in both TV Shows and Movies
-- noticed no overlap
WITH Titles_Plus_Categories AS 
(
SELECT t.show_id AS show_id , t.title as title, t.type as type, t.release_year as release_year, c.listed_in AS genre
FROM netflix_titles_working_sheet t
JOIN netflix_titles_category c
ON t.show_id = c.show_id
)
SELECT genre
FROM Titles_Plus_Categories
GROUP BY genre
HAVING COUNT(DISTINCT type) = 2;

-- find distinct genres
-- noticed here there are things like International TV Shows and International Movies that could be in one genre, like International
SELECT DISTINCT listed_in AS genre
FROM netflix_titles_category
ORDER BY 1;

-- created a genre mapping table in excel and imported it
SELECT * FROM genre_mapping;

-- join genre mapping with netflix genres before finding count of genres
WITH Normalized_Genres AS 
(
SELECT c.show_id, c.listed_in AS original_genre, g.normalized_genre
FROM netflix_titles_category c
JOIN genre_mapping g
ON c.listed_in = g.genre
), 
Titles_Plus_Categories AS 
(
SELECT t.show_id , t.title, t.type, t.release_year, n.normalized_genre AS genre
FROM netflix_titles_working_sheet t
JOIN Normalized_Genres n
ON t.show_id = n.show_id
)
SELECT genre, COUNT(*) AS total
FROM Titles_Plus_Categories
GROUP BY genre
ORDER BY total DESC;

-- create a view for a table with the titles and normalized genres (Exported)
DROP VIEW IF EXISTS titles_with_normalized_genres_view;
CREATE VIEW titles_with_normalized_genres_view AS
WITH Normalized_Genres AS
(
SELECT c.show_id, c.listed_in AS original_genre, g.normalized_genre
FROM netflix_titles_category c
JOIN genre_mapping g
ON c.listed_in = g.genre
)
SELECT t.show_id AS show_id, t.title AS title, t.type AS type, t.release_year AS release_year, t.rating AS rating, t.date_added AS date_added, t.year_added AS year_added, t.duration_minutes AS duration_minutes, t.duration_seasons AS duration_seasons, n.normalized_genre AS genre
FROM netflix_titles_working_sheet t
JOIN Normalized_Genres n
ON t.show_id = n.show_id;

SELECT * FROM titles_with_normalized_genres_view;

-- find genres that appear in both tv shows and movies
SELECT genre
FROM titles_with_normalized_genres_view
GROUP BY genre
HAVING COUNT(DISTINCT type) > 1;

-- for each year, what is the count of titles by type 
-- use show_id because some movies/tv shows have same title but are different 
SELECT release_year, type, COUNT(DISTINCT show_id) AS number_of_titles
FROM netflix_titles_working_sheet
GROUP BY release_year, type
ORDER BY release_year ASC;

-- average number of genres per title
WITH Num_Genres_Per_Title AS
(
SELECT title, COUNT(DISTINCT genre) AS number_of_genres
FROM titles_with_normalized_genres_view
GROUP BY show_id
)
SELECT AVG(number_of_genres) AS avg_num_genres
FROM Num_Genres_Per_Title;

-- top 10 titles with most genres
SELECT title, COUNT(DISTINCT genre) AS number_of_genres
FROM titles_with_normalized_genres_view
GROUP BY show_id
ORDER BY 2 DESC
LIMIT 10;

-- year over year growth in number of titles added to netflix (Exported)
WITH Yearly_Counts AS
(
SELECT year_added, COUNT(*) AS total
FROM netflix_titles_working_sheet
GROUP BY year_added
), 
With_Lag AS
(
SELECT year_added, total, 
LAG(total) OVER (ORDER BY year_added) as prev_year_total
FROM Yearly_Counts
)
SELECT year_added, total, prev_year_total,
ROUND(((total - prev_year_total) / prev_year_total * 100 ), 2)AS yoy_growth_percent
FROM With_Lag
ORDER BY year_added;

-- for each genre, which year had the most number of titles (year_added)
WITH year_ranked AS
(
SELECT year_added, genre, COUNT(DISTINCT show_id) AS number_of_titles,
RANK() OVER (PARTITION BY genre ORDER BY COUNT(DISTINCT show_id) DESC) AS rank_num
FROM titles_with_normalized_genres_view
GROUP BY genre, year_added
)
SELECT *
FROM year_ranked
WHERE rank_num = 1;

-- for each genre, which year had the most number of titles (release_year)
WITH year_ranked AS
(
SELECT release_year, genre, COUNT(DISTINCT show_id) AS number_of_titles,
RANK() OVER (PARTITION BY genre ORDER BY COUNT(DISTINCT show_id) DESC) AS rank_num
FROM titles_with_normalized_genres_view
GROUP BY genre, release_year
)
SELECT *
FROM year_ranked
WHERE rank_num = 1;

-- which genres have the highest average duration
SELECT genre, AVG(duration_minutes)
FROM titles_with_normalized_genres_view
WHERE type = 'Movie'
GROUP BY genre
ORDER BY 2 DESC;

-- case breakdown of ratings: kid-friendly, teen, adult (Exported)
-- kid-friendly: 'G', 'TV-G', 'TV-Y', 'TV-Y7', 'PG', 'TV-PG'
-- teen: 'PG-13', 'TV-14'
-- adult: 'R', 'TV-MA', 'NC-17'
-- else 'NR'
WITH categorized_ratings AS
(
SELECT genre, title, show_id,
CASE
	WHEN rating IN ('G', 'TV-G', 'TV-Y', 'TV-Y7', 'PG', 'TV-PG') THEN 'Kid-Friendly'
    WHEN rating IN ('PG-13', 'TV-14') THEN 'Teen'
    WHEN rating IN ('R', 'TV-MA', 'NC-17') THEN 'Adult'
    ELSE 'Not Rated'
END AS rating_category
FROM titles_with_normalized_genres_view
)
SELECT genre, rating_category, COUNT(DISTINCT show_id) as title_count
FROM categorized_ratings
GROUP BY genre, rating_category
ORDER BY genre, rating_category;

-- leaderboard of most frequent content types per year
WITH Types_Per_Year AS
(
SELECT year_added, COUNT(*) as total, type
FROM netflix_titles_working_sheet
GROUP BY year_added, type
ORDER BY year_added
),
Ranked_Types_Per_Year AS
(
SELECT year_added, type, total, RANK() OVER (PARTITION BY year_added ORDER BY total DESC) AS rank_num
FROM Types_Per_Year
)
SELECT *
FROM Ranked_Types_Per_Year
WHERE rank_num = 1;

-- titles with more than one genre, group by type
WITH Num_Of_Genres AS
(
SELECT title, type, COUNT(DISTINCT genre) as num_of_genres
FROM titles_with_normalized_genres_view
GROUP BY show_id, type
)
SELECT *
FROM Num_Of_Genres
WHERE num_of_genres > 1;

-- counts of genres per year (Exported)
SELECT genre, year_added, COUNT(DISTINCT show_id) AS number_of_titles
FROM titles_with_normalized_genres_view
GROUP BY genre, year_added
ORDER BY genre, year_added;

SELECT * FROM titles_with_normalized_genres_view
WHERE rating = 'NC-17';



-- genre distribution for non-US titles
WITH NonUS_Titles AS (
SELECT DISTINCT t.show_id
FROM netflix_titles_working_sheet t
JOIN netflix_titles_countries c ON t.show_id = c.show_id
WHERE c.country NOT LIKE '%United States%'
),
GenreCounts AS (
SELECT g.genre, COUNT(DISTINCT t.show_id) AS genre_count
FROM netflix_titles_working_sheet t
JOIN netflix_titles_countries c ON t.show_id = c.show_id
JOIN titles_with_normalized_genres_view g ON t.show_id = g.show_id
WHERE c.country NOT LIKE '%United States%'
GROUP BY g.genre
)
SELECT g.genre, genre_count, ROUND(genre_count * 100.0 / (SELECT COUNT(*) FROM NonUS_Titles), 2) AS pct_of_non_us
FROM GenreCounts g
ORDER BY pct_of_non_us DESC;





