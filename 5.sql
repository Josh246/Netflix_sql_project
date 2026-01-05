--Identify the longest movie
SELECT
	title,
	duration
FROM
	netflix
WHERE
	show_type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)
