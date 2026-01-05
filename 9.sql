--Count the number of content items in each genre
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, 
	COUNT(*)
FROM
	netflix
GROUP BY
	genre