-- 1. Count the number of Movies vs TV Shows

SELECT 
	show_type,
	COUNT(*)
FROM 
	netflix
GROUP by
	show_type


-- 2. Find the most common rating for movies and TV shows

WITH m_rating AS
(
SELECT
	show_type,
	rating,
	COUNT(rating) AS rating_count
FROM
	netflix
WHERE
	rating IS NOT NULL
GROUP BY
	show_type,
	rating
),

rating_rank AS 
(
SELECT
	*,
	RANK() OVER (PARTITION BY show_type ORDER BY rating_count DESC) as rank
FROM
	m_rating
ORDER BY
	rating
)

SELECT
	show_type,
	rating
FROM
	rating_rank
WHERE
	rank = 1


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT
	show_type,
	title,
	release_year
FROM
	netflix
WHERE
	release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix

SELECT 
	TRIM(country_name) AS country,
	COUNT(*) AS total_content
FROM 
	netflix
	CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(country, ',')) AS country_name
WHERE 
	country_name IS NOT NULL
GROUP BY 
	country_name 
ORDER BY 
	total_content DESC
LIMIT 5;


-- 5. Identify the longest movie

SELECT
	title,
	duration
FROM
	netflix
WHERE
	show_type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)


-- 6. Find content added in the last 5 years

SELECT
	*
FROM 
	netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT
	title,
	TRIM(director_name) AS director
FROM
	netflix
	CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
WHERE
	director_name = 'Rajiv Chilaka'


-- 8. List all TV shows with more than 5 seasons

SELECT
	*
FROM
	netflix
WHERE
	show_type = 'TV Show'
AND
	SPLIT_PART(duration, ' ', 1)::INT > 5


-- 9. Count the number of content items in each genre
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, 
	COUNT(*)
FROM
	netflix
GROUP BY
	genre


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- Return top 5 year with highest avg content release !

SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM 
	netflix
WHERE 
	country = 'India' 
GROUP BY 
	country, 2
ORDER BY 
	avg_release DESC 
LIMIT 
	5


-- 11. List all movies that are documentaries

SELECT
	*
FROM
	netflix
WHERE
	listed_in LIKE 'Documentaries'


-- 12. Find all content without a director
SELECT
	*
FROM
	netflix
WHERE
	director IS NULL


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT
	COUNT(show_type)
FROM
	netflix
WHERE
	casts LIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
GROUP BY
	show_type


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM
	netflix
WHERE
	country = 'India'
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	10


-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' 
-- in the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

SELECT 
    category,
	show_type,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 
	1, 2
ORDER BY 
	2