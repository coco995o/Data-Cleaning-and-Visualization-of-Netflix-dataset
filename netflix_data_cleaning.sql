CREATE TABLE IF NOT EXISTS netflix (
	show_id varchar,
	type varchar,
	title text,
	director varchar,
	casting text,
	country varchar,
	date_added varchar,
	release_year integer,
	rating varchar,
	duration varchar,
	listed_in text,
	description text
);

--Standardizing show_id
/*SELECT show_id, TRIM(show_id, 's ')
FROM netflix
ORDER BY TRIM(show_id, 's ');

UPDATE netflix
SET show_id = TRIM(show_id, 's ');

ALTER TABLE netflix
ALTER COLUMN show_id TYPE integer
USING show_id::integer; 
*/

--Checking for NULLS
SELECT * FROM netflix
WHERE NOT (netflix IS NOT NULL);

SELECT director
FROM netflix
WHERE director IS NULL;

UPDATE netflix
SET director = 'Unknown'
WHERE director IS NULL;

SELECT director
FROM netflix;

SELECT casting 
FROM netflix
WHERE casting IS NULL;

UPDATE netflix
SET casting = 'Unknown'
WHERE casting IS NULL;

SELECT title, COUNT(*) 
FROM netflix
GROUP BY title
ORDER BY COUNT(*) DESC;

SELECT *
FROM netflix
WHERE title = '22-Jul';

SELECT *
FROM netflix
WHERE country IS NULL;

UPDATE netflix
SET country = 'Unknown'
WHERE country IS NULL;

SELECT *
FROM netflix
WHERE NOT (netflix IS NOT NULl);

DELETE FROM netflix
WHERE date_added IS NULL;

SELECT *
FROM netflix
WHERE NOT (netflix IS NOT NULl);

--Observing that the rating also has the duration of the movie, I have updated the value of duration
WITH cte AS (
	SELECT n1.rating AS new_duration, n2.duration, n1.show_id 
	FROM netflix AS n1
	LEFT JOIN netflix AS n2
	ON n1.show_id = n2.show_id
	
)

UPDATE netflix
SET duration = cte.new_duration
FROM cte
WHERE netflix.show_id = cte.show_id
	AND netflix.duration IS NULL;

--Checking again for NULLS
SELECT * 
FROM netflix
WHERE NOT (netflix IS NOT NULL);

UPDATE netflix
SET rating = 'Unknown'
WHERE rating IS NULL;

--Final check for NULLS
SELECT * 
FROM netflix
WHERE NOT (netflix IS NOT NULL);

--Searching for duplicates
WITH dup AS (
	SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY type,title,director,casting,country,date_added,release_year,rating,duration,listed_in,description
	) AS row_id
	FROM netflix
)
SELECT * 
FROM dup
WHERE row_id >1;

DELETE FROM netflix
WHERE show_id = 5967
	OR show_id = 5966
	OR show_id = 5965;

SELECT * 
FROM netflix;

CREATE TEMP TABLE IF NOT EXISTS netflix1 AS 
SELECT * FROM netflix;

SELECT *
FROM netflix1;

--Correcting date column
ALTER TABLE netflix1
ALTER COLUMN date_added TYPE date
USING date_added::date;

SELECT *
FROM netflix1;


SELECT *
FROM netflix1
WHERE director LIKE 'Tiller%';

CREATE TABLE IF NOT EXISTS netflix2 AS
TABLE netflix1;

SELECT * FROM netflix2;

SELECT *
FROM netflix1
WHERE director LIKE 'Tiller%';

--Populating Unknown country field where the same director has a country assigned and Unknown
WITH cte3 AS (
	SELECT n1.director, n1.country, n2.director AS dir, n2.country AS coun FROM netflix1 AS n1
	LEFT JOIN netflix1 AS n2
	ON n1.director = n2.director
WHERE n1.country LIKE 'Unknown'
	AND n2.country NOT LIKE 'Unknown'
	AND n1.director NOT LIKE 'Unknown'
)

UPDATE netflix1 AS n
SET country = cte3.coun
FROM cte3
WHERE n.director = cte3.director
	AND n.country LIKE 'Unknown'
	AND n.director NOT LIKE 'Unknown';

SELECT * FROM netflix1;

SELECT country, split_part(country, ',',1)
FROM netflix1;

UPDATE netflix1
SET country = split_part(country, ',',1);

--Description is not needed for visualization
--ALTER TABLE netflix1
--DROP COLUMN description;

SELECT * FROM netflix1;

CREATE TABLE IF NOT EXISTS netflix2 AS
TABLE netflix1;

SELECT * FROM netflix1;

