-- Q1 - Find the titles of all movies directed by Steven Spielberg.
SELECT title
FROM movie
WHERE director = "Steven Spielberg";


-- Q2 - Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT distinct year
FROM movie join rating
ON movie.mid = rating.mid
WHERE stars >= 4
ORDER BY year;

-- Q3 - Find the titles of all movies that have no ratings.
SELECT title
FROM movie LEFT JOIN rating
ON movie.mid = rating.mid
WHERE stars IS NULL;

-- Q4 - Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT name
FROM reviewer LEFT JOIN rating
ON reviewer.rid = rating.rid
WHERE rating.ratingDate IS NULL;

-- Q5 - Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
SELECT name, title, stars, ratingDate
FROM (reviewer LEFT JOIN rating
ON reviewer.rid = rating.rid) AS L LEFT JOIN movie
ON L.mid  = movie.mid
ORDER BY name, title, stars;

-- Q6 - For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
SELECT name, title
FROM movie
JOIN rating r1
ON movie.mid= r1.mid
JOIN rating r2
ON r1.rid = r2.rid
JOIN reviewer
ON r2.rid = reviewer.rid
WHERE r1.mId = r2.mId AND r1.ratingDate < r2.ratingDate AND r1.stars < r2.stars;

-- Q7 - For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
SELECT title, MAX(stars)
FROM movie JOIN rating
ON movie.mid = rating.mid
WHERE rating.stars
GROUP BY title;

-- Q8 - For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT title, MAX(stars) - MIN(stars) AS 'rating spread'
FROM movie JOIN rating
ON movie.mid = rating.mid
GROUP BY title
ORDER BY 2 DESC, title;

-- Q9 - Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
SELECT avg(a) - b FROM (
SELECT title, avg(stars) a
FROM movie JOIN rating
ON movie.mid = rating.mid
WHERE year < 1980
GROUP BY title) JOIN (
SELECT avg(b) AS b FROM (
SELECT title, avg(stars) AS b
FROM movie JOIN rating
ON movie.mid = rating.mid
WHERE year > 1980
GROUP BY title)
)
