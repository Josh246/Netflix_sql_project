--List all movies released in a specific year (e.g., 2020)
SELECT
	show_type,
	title,
	release_year
FROM
	netflix
WHERE
	release_year = 2020