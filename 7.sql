--Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT
	title,
	TRIM(director_name) AS director
FROM
	netflix
	CROSS JOIN LATERAL UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
WHERE
	director_name = 'Rajiv Chilaka'
