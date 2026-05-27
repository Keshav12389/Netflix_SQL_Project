-- ============================================
-- NETFLIX CONTENT ANALYSIS — SQL PROJECT
-- Author  : Keshav Meena
-- Tool    : PostgreSQL
-- Dataset : Netflix Movies and TV Shows (Kaggle)
-- Rows    : 8,800+ titles
-- ============================================


-- ============================================
-- DATABASE SETUP
-- ============================================

CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

-- Verify data loaded correctly
SELECT COUNT(*) AS total_titles FROM netflix;
SELECT * FROM netflix LIMIT 5;


-- ============================================
-- PROBLEM 1: Count the Number of Movies vs TV Shows
-- ============================================
-- Business use: Understand content type distribution
-- on the platform

SELECT
    type,
    COUNT(*) AS total_content
FROM netflix
GROUP BY type
ORDER BY total_content DESC;


-- ============================================
-- PROBLEM 2: Find the Most Common Rating for
--            Movies and TV Shows
-- ============================================
-- Business use: Identify the target audience
-- for each content type

SELECT type, rating
FROM (
    SELECT
        type,
        rating,
        COUNT(*),
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY 1, 2
) AS t1
WHERE ranking = 1;


-- ============================================
-- PROBLEM 3: List All Movies Released in 2020
-- ============================================
-- Business use: Track content additions for
-- a specific release year

SELECT
    title,
    type,
    release_year,
    country
FROM netflix
WHERE
    type = 'Movie'
    AND release_year = 2020
ORDER BY title;


-- ============================================
-- PROBLEM 4: Find Top 5 Countries with the
--            Most Content on Netflix
-- ============================================
-- Business use: Identify dominant content-producing
-- regions to guide acquisition strategy

SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS new_country,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- ============================================
-- PROBLEM 5: Identify the Longest Movie
-- ============================================
-- Business use: Find outlier content durations
-- for platform curation

SELECT
    title,
    duration
FROM netflix
WHERE
    type = 'Movie'
    AND duration = (SELECT MAX(duration) FROM netflix);


-- ============================================
-- PROBLEM 6: Find Content Added in the Last 5 Years
-- ============================================
-- Business use: Analyze how recently the platform
-- has been updated with new titles

SELECT
    title,
    type,
    date_added
FROM netflix
WHERE
    date_added ~ '^\d{2}-[A-Za-z]{3}-\d{2}$'
    AND TO_DATE(date_added, 'DD-Mon-YY') >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY TO_DATE(date_added, 'DD-Mon-YY') DESC;


-- ============================================
-- PROBLEM 7: Find All Movies/TV Shows by
--            Director 'Rajiv Chilaka'
-- ============================================
-- Business use: Analyse a specific director's
-- contribution to the platform

SELECT
    title,
    type,
    director,
    release_year
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'
ORDER BY release_year DESC;


-- ============================================
-- PROBLEM 8: List All TV Shows with More Than
--            5 Seasons
-- ============================================
-- Business use: Identify long-running shows
-- for viewer retention analysis

SELECT
    title,
    duration,
    country
FROM netflix
WHERE
    type = 'TV Show'
    AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5
ORDER BY SPLIT_PART(duration, ' ', 1)::NUMERIC DESC;


-- ============================================
-- PROBLEM 9: Count the Number of Content Items
--            in Each Genre
-- ============================================
-- Business use: Understand genre popularity
-- to guide content investment decisions

SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;


-- ============================================
-- PROBLEM 10: Average Number of Content Releases
--             in India Per Year on Netflix
-- ============================================
-- Business use: Track India's content contribution
-- trend over time (Top 5 years by average)

SELECT
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::NUMERIC /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::NUMERIC * 100, 2
    ) AS avg_release_percentage
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release_percentage DESC
LIMIT 5;


-- ============================================
-- PROBLEM 11: List All Movies that are
--             Documentaries
-- ============================================
-- Business use: Filter content by genre for
-- category-specific recommendations

SELECT
    title,
    listed_in,
    release_year,
    country
FROM netflix
WHERE listed_in ILIKE '%documentaries%'
ORDER BY release_year DESC;


-- ============================================
-- PROBLEM 12: Find All Content Without a Director
-- ============================================
-- Business use: Identify data quality issues
-- and incomplete metadata in the catalog

SELECT
    title,
    type,
    country,
    release_year
FROM netflix
WHERE director IS NULL
ORDER BY type, release_year DESC;


-- ============================================
-- PROBLEM 13: Find How Many Movies Actor
--             'Salman Khan' Appeared in
--             the Last 10 Years
-- ============================================
-- Business use: Analyse a top actor's recent
-- presence on the platform

SELECT
    title,
    casts,
    release_year,
    country
FROM netflix
WHERE
    casts ILIKE '%Salman Khan%'
    AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
ORDER BY release_year DESC;


-- ============================================
-- PROBLEM 14: Top 10 Actors Who Have Appeared
--             in the Highest Number of Movies
--             Produced in India
-- ============================================
-- Business use: Identify the most prominent
-- Indian actors on Netflix for partnership insights

SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
    COUNT(*) AS total_appearances
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- ============================================
-- PROBLEM 15: Categorize Content Based on the
--             Presence of 'Kill' and 'Violence'
--             Keywords in Description
-- ============================================
-- Business use: Flag potentially sensitive content
-- for content moderation and parental controls

SELECT
    category,
    COUNT(*) AS content_count
FROM (
    SELECT
        CASE
            WHEN description ILIKE '%kill%'
              OR description ILIKE '%violence%' THEN 'Bad Content'
            ELSE 'Good Content'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category
ORDER BY content_count DESC;


-- ============================================
-- BONUS: Additional Insights
-- ============================================

-- BONUS 1: Year-wise content addition trend
-- (How aggressively did Netflix grow its catalog?)
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
    COUNT(*) AS titles_added
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY 1
ORDER BY 1 DESC;


-- BONUS 2: Movies vs TV Shows ratio by country (Top 10)
SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country_name,
    COUNT(CASE WHEN type = 'Movie' THEN 1 END) AS movies,
    COUNT(CASE WHEN type = 'TV Show' THEN 1 END) AS tv_shows,
    COUNT(*) AS total
FROM netflix
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY total DESC
LIMIT 10;


-- BONUS 3: Most popular rating category in India
SELECT
    rating,
    COUNT(*) AS total
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY rating
ORDER BY total DESC
LIMIT 5;
