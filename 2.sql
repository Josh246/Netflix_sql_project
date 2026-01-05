--Find the most common rating for movies and TV shows
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
