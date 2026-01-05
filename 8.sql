--List all TV shows with more than 5 seasons
SELECT
	*
FROM
	netflix
WHERE
	show_type = 'TV Show'
AND
	SPLIT_PART(duration, ' ', 1)::INT > 5
