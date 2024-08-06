USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
-- Used 'https://www.dpriver.com/pp/sqlformat.htm' for query formatting.

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) AS Total_Movies
FROM   movie;
-- No. of rows : 7997

SELECT COUNT(*) AS director_mapping_count
FROM   director_mapping;
-- No. of rows : 3867

SELECT COUNT(*) AS Total_Ratings
FROM   ratings;
-- No. of rows : 7997

SELECT COUNT(*) AS role_mapping_count
FROM   role_mapping;
-- No. of rows : 15615

SELECT COUNT(*) AS Total_Names
FROM   names;
-- No. of rows : 25735

SELECT Count(*) AS genres
FROM   genre; 
-- No. of rows : 14662


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS Id_null_count,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worldwide_gross_income_null_count,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count
FROM 
	movie;
    
/*
The columns that have null values in movie table are:
	1. country
    2. worlwide_gross_income
    3. languages
    4. production_company
*/


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- FIRST PART
SELECT year,
       COUNT(id) AS number_of_movies
FROM   movie
GROUP  BY year; 

/* OUTPUT
year	number_of_movies
2017	3052
2018	2944
2019	2001

*INSIGHTS*
The maximum movies were produced in the year 2017.
The number of movies reduced over a period of years.
*/

-- SECOND PART
SELECT Month(date_published) AS month_num,
       COUNT(id)             AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY Month(date_published); 

/* OUTPUT
month_num	number_of_movies
1			804
2			640
3			824
4			680
5			625
6			580
7			493
8			678
9			809
10			801
11			625
12			438

*INSIGHTS*
The numbers indicate the month starting from January.
We can clearly see that the max movies produced were 
in March considering all the years.
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(title) AS number_of_movies,
       year
FROM   movie
WHERE  ( country LIKE "%usa%"
          OR country LIKE "%india%" )
       AND year = 2019
GROUP  BY year; 

/* OUTPUT - Movies were produced in the USA or India in the year 2019
number_of_movies	year
1059				2019

*INSIGHTS*
Total movies produced in the year 2019 in USA and India together is : 1059
----
Used LIKE instead of '=' as it will take all the countries even if 
there are multiple entries.
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/


-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM   genre
ORDER  BY genre; 

/* OUTPUT - List of genres present in the dataset
genre	|
--------|
Action
Adventure
Comedy
Crime
Drama
Family
Fantasy
Horror
Mystery
Others
Romance
Sci-Fi
Thriller
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */


-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre,
       COUNT(movie_id) AS num_of_movies
FROM   genre
GROUP  BY genre
ORDER  BY COUNT(movie_id) DESC
LIMIT  1; 

/* OUTPUT - The genre which had the highest number of movies produced overall
genre	num_of_movies
Drama	4285

*INSIGHTS*
The genre which had the highest number of movies produced 
overall is Drama with movie_count 4285.
----
Used Group by clause on genre and order by on the column 
Count(movie_id) in descending order with limit of 
1 because we want only one genre with highest no. of movies produced.
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/


-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH one_genre
     AS (SELECT movie_id,
                COUNT(DISTINCT genre) AS n_genre
         FROM   genre
         GROUP  BY movie_id
         HAVING n_genre = 1)
SELECT COUNT(n_genre) AS one_genre_movies_count
FROM   one_genre; 

/* OUTPUT - Total number movies with only one genre
one_genre_movies_count
3289

*INSIGHTS*
The total number movies with only one genre is 3289.
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/


-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:
+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre,
       ROUND(AVG(m.duration), 2) AS avg_duration
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
GROUP  BY g.genre
ORDER  BY avg_duration DESC; 

/* OUTPUT - Average duration of movies in each genre
genre		avg_duration
Action		112.88
Romance		109.53
Crime		107.05
Drama		106.77
Fantasy		105.14
Comedy		102.62
Adventure	101.87
Mystery		101.80
Thriller	101.58
Family		100.97
Others		100.16
Sci-Fi		97.94
Horror		92.72

*INSIGHTS*
Action genre has the highest average duration among all genres.
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/


-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_summary
     AS (SELECT genre,
                COUNT(movie_id)                    AS movie_count,
                RANK()
                  OVER(
                    ORDER BY COUNT(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_summary
WHERE  genre = "thriller"; 

/* OUTPUT - Rank of thriller movies in terms of movies produced
genre		movie_count		genre_rank
Thriller	1484			3

*INSIGHTS*
Rank of Thriller movies is 3rd (third) among all the genres.
----
Used Common Table Expression CTE to make the query easier to understand.
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating)    AS min_avg_rating,
       MAX(avg_rating)    AS max_avg_rating,
       MIN(total_votes)   AS min_total_votes,
       MAX(total_votes)   AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM   ratings; 

/* OUTPUT - Minimum and maximum values in  each column of the ratings table
min_avg_rating		max_avg_rating		min_total_votes		max_total_votes		min_median_rating
1.0					10.0				100					725138				1		
max_median_rating
10
*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/


-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH movie_ranking
     AS (SELECT title,
                avg_rating,
                RANK()
                  OVER(
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id)
SELECT *
FROM   movie_ranking
WHERE  movie_rank <= 10; 


/* OUTPUT - Top 10 movies based on average rating
title							avg_rating	movie_rank
Kirket								10.0	1
Love in Kilnerry					10.0	1
Gini Helida Kathe					9.8		3
Runam								9.7		4
Fan									9.6		5
Android Kunjappan Version 5.25		9.6		5
Yeh Suhaagraat Impossible			9.5		7
Safe								9.5		7
The Brighton Miracle				9.5		7
Shibu								9.4		10
Our Little Haven					9.4		10
Zana								9.4		10
Family of Thakurganj				9.4		10
Ananthu V/S Nusrath					9.4		10

*INSIGHTS*
Kirket and Love in Kilnery stands at first position when compared on 
the basis of average rating.
----
Used CTE along with RANK() window function.
Then used the temporarily created table and applied WHERE condition.
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/


-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

/* OUTPUT 
median_rating	movie_count
7				2257
6				1975
8				1030
5				985
4				479
9				429
10				346
3				283
2				119
1				94

*INSIGHTS*
Movies with a median rating of 7 is highest in number. 
----
Summarising the movie counts means knwoing the total movies wrt the 
median rating. 
So got the COUNT(movie_id) in one column.
Grouped them by median rating and ordered them by movie count.
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/


-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH hit_movies_summary
     AS (SELECT production_company,
                COUNT(movie_id)                     AS movie_count,
                RANK()
                  OVER(
                    ORDER BY COUNT(movie_id) DESC ) AS prod_company_rank
         FROM   ratings AS r
                INNER JOIN movie AS m
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   hit_movies_summary
WHERE  prod_company_rank = 1; 

/* OUTPUT
production_company		movie_count		prod_company_rank
Dream Warrior Pictures	3				1
National Theatre Live	3				1

*INSIGHTS*
The production company Dream Warrior Pictures and National Theatre Live has 
produced the most number of hit movies having average rating > 8.
----
We needed production company name, movie count as well as the avreage rating to rank the 
production companies. 
Hence, used JOINS and applied conditions.
Also made use of RANK() window function.
If we use Dense_rank the output will still be the same.
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:
+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre,
       COUNT(g.movie_id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON g.movie_id = r.movie_id
WHERE  Month(m.date_published) = 3
       AND Year(m.date_published) = 2017
       AND country LIKE '%USA%'
       AND r.total_votes > 1000
GROUP  BY g.genre
ORDER  BY movie_count DESC; 
    
/* OUTPUT - Movies released in each genre during March 2017 in the USA had more than 1,000 votes
genre		movie_count
Drama		24
Comedy		9
Action		8
Thriller	8
Sci-Fi		7
Crime		6
Horror		6
Mystery		4
Romance		4
Fantasy		3
Adventure	3
Family		1

*INSIGHTS*
Most movies released in March 2017 was from Drama genre.
----
Since we needed month, year, genre, total votes which are in 
three different table, we used joins
and grouped themby genre and ordered them by movie count in desc order 
due to which we were able to tell that max movies were released were from 
drama genre in March 2017.
*/


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.title,
       r.avg_rating,
       g.genre
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  title LIKE 'The%'
       AND avg_rating > 8
ORDER  BY avg_rating DESC; 

/* OUTPUT
title									avg_rating		genre
The Brighton Miracle					9.5				Drama
The Colour of Darkness					9.1				Drama
The Blue Elephant 2						8.8				Drama
The Blue Elephant 2						8.8				Horror
The Blue Elephant 2						8.8				Mystery
The Irishman							8.7				Crime
The Irishman							8.7				Drama
The Mystery of Godliness: The Sequel	8.5				Drama
The Gambinos							8.4				Crime
The Gambinos							8.4				Drama
Theeran Adhigaaram Ondru				8.3				Action
Theeran Adhigaaram Ondru				8.3				Crime
Theeran Adhigaaram Ondru				8.3				Thriller
The King and I							8.2				Drama
The King and I							8.2				Romance
*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(movie_id) AS movie_count
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND median_rating = 8
ORDER  BY movie_count DESC; 

/* OUTPUT
Movies published between 1st April 2018 to 
1st April 2019 having median rating 8 : 361
*/


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
WITH votes_summary
     AS (SELECT languages,
                SUM(total_votes) AS VOTES
         FROM   movie m
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%Italian%'
         UNION
         SELECT languages,
                SUM(total_votes) AS VOTES
         FROM   movie m
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%GERMAN%')
SELECT *
FROM   votes_summary; 

/* OUTPUT - Total vote count for Italian and German movies according to language
Italian	2559540
German	4421525

*INSIGHTS*
By looking at the total vote count in the output, we can confirm that 
the German movies get more votes than Italian movies.
----
Used sum of total votes and gave the condition of languages.
We can also use the country column and get the output where we can apply 
condition country LIKE '%Germany%' AND '%Italy%'.
*/

-- Answer is Yes


/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT SUM(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       SUM(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       SUM(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       SUM(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 
 
/* OUTPUT - Null count in each row of names table
name_nulls	height_nulls	date_of_birth_nulls		known_for_movies_nulls
0			17335			13431					15226

Insights
All columns have null values except for name columns in the table names.
----
Used SUM and CASE statements to get the null values by giving alias to new columns.
*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/


-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:
+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_3_genres AS
(
           SELECT     genre,
                      COUNT(m.id)                            AS movie_count ,
                      RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name,
           COUNT(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre g
using      (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using      (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   name
ORDER BY   movie_count DESC 
LIMIT 3;

/* OUTPUT - Top 3 directors with average rating > 8 according to genre
director_name	movie_count
James Mangold	4
Anthony Russo	3
Soubin Shahir	3

*INSIGHTS*
The top three directors in the top three genres whose movies have an average rating > 8 are:
1. James Mangold
2. Anthony Russo
3. Soubin Shahir
----
Using CTE, got new temporary table top_3_genres.
Used JOINS for joining 5 tables.
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/


-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT name              AS actor_name,
       COUNT(r.movie_id) AS movie_count
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON m.id = rm.movie_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  median_rating >= 8
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 

/* OUTPUT - Top 2 actors where median rating for movies >= 8
actor_name	movie_count
Mammootty	8
Mohanlal	5

*INSIGHTS*
Top two actors whose movies have a median rating >= 8 are:
1. Mammootty
2. Mohanlal
----
We needed four tables to get the desired output 
ie.  names, role_mapping, movie and ratings table.
So we used JOINS to get the required output.
Grouped them by actor names and ordered them using movie count.
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/


-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     production_company,
           SUM(total_votes)                            AS vote_count,
           RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
GROUP BY   production_company
ORDER BY   prod_comp_rank 
LIMIT 3;
    
/* OUTPUT
production_company		vote_count		prod_comp_rank
Marvel Studios			2656967			1
Twentieth Century Fox	2411163			2
Warner Bros.			2396057			3

*INSIGHTS*
Top three production houses based on the number of votes:
1. Marvel Studios
2. Twentieth Century Fox
3. Warner Bros.
----
Used window functions to get the desired output of ranks of production 
companies based on sum of total votes.
*/

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/


-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_summary AS
(
           SELECT     n.NAME AS actor_name,
                      total_votes,
                      COUNT(r.movie_id)                                          AS movie_count,
                      ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating
           FROM       movie m
           INNER JOIN ratings r
           ON         m.id = r.movie_id
           INNER JOIN role_mapping rm
           ON         m.id = rm.movie_id
           INNER JOIN names n
           ON         rm.name_id = n.id
           WHERE      category = 'actor'
           AND        country = "India"
           GROUP BY   NAME
           HAVING     movie_count >= 5)
SELECT   *,
         RANK() OVER( ORDER BY actor_avg_rating DESC) AS actor_rank
FROM     actor_summary 
LIMIT 10;

/* OUTPUT - List of Top 10 Indian actors based on average rating:
actor_name			total_votes		movie_count		actor_avg_rating	actor_rank
Vijay Sethupathi	20364			5				8.42				1
Fahadh Faasil		3684			5				7.99				2
Yogi Babu			223				11				7.83				3
Joju George			413				5				7.58				4
Ammy Virk			169				6				7.55				5
Dileesh Pothan		1115			5				7.52				6
Kunchacko Boban		3684			6				7.48				7
Pankaj Tripathi		13723			5				7.44				8
Rajkummar Rao		8320			6				7.37				9
Dulquer Salmaan		2432			5				7.30				10

*INSIGHTS*
Vijay Sethupathi is the Top actor in Indian movies followed by Fadadh Faasil at rank 2.
----
Used CTE for ease of querying. 
RANK() for ranking the actors based on actor average rating.
*/

-- Top actor is Vijay Sethupathi


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_summary AS
(
           SELECT     n.name AS actress_name,
                      total_votes,
                      COUNT(r.movie_id)                                          AS movie_count,
                      ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating
           FROM       movie m
           INNER JOIN ratings r
           ON         m.id = r.movie_id
           INNER JOIN role_mapping rm
           ON         m.id = rm.movie_id
           INNER JOIN names n
           ON         rm.name_id = n.id
           WHERE      category = "actress"
           AND        languages LIKE "%Hindi%"
           AND        country = "India"
           GROUP BY   NAME
           HAVING     movie_count >= 3)
SELECT   *,
         RANK() OVER( ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     actress_summary 
LIMIT 5;

/* OUTPUT - Top 5 Actresses in Hindi based on their average rating
actress_name	total_votes	movie_count actress_avg_rating	actrees_rank
Taapsee Pannu	2269		3			7.74				1
Kriti Sanon		14978		3			7.05				2
Divya Dutta		345			3			6.88				3
Shraddha Kapoor	3349		3			6.63				4
Kriti Kharbanda	1280		3			4.80				5

*INSIGHTS*
The top 5 actresses in Hindi movies in India are:
1. Taapsee Pannu
2. Kriti Sanon
3. Divya Dutta
4. Shraddha Kapoor
5. Kriti Kharbanda
----
Used RANK() windows function for ranking the actresses on the basis of actress average 
rating. Also used CTE for less complexity in the code.
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
WITH thriller_movies
     AS (SELECT m.title AS thriller_movies,
                r.avg_rating
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN genre g
                        ON r.movie_id = g.movie_id
         WHERE  genre = 'Thriller')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movie'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movie'
         WHEN avg_rating < 5 THEN 'Flop movie'
       END AS rating_category
FROM   thriller_movies
ORDER  BY avg_rating DESC; 

/* 
*INSIGHTS*
Safe remains the top Superhit movie with the average rating 9.5 in thriller movies.
----
Created CTE using genres and movie table by giving condition as 
genre = 'thriller'.
After that used CASE function to apply multiple condition 
to one column to create new column.
*/


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/




-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
       ROUND(AVG(duration), 2)                         AS avg_duration,
       SUM(ROUND(AVG(duration), 2))
         OVER(
           ORDER BY genre ROWS UNBOUNDED PRECEDING)    AS running_total_duration
       ,
       ROUND(AVG(AVG(duration))
               OVER (
                 ORDER BY genre ROWS 10 PRECEDING), 2) AS moving_avg_duration
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 

/* OUTPUT - Genre-wise running total and moving average of the average movie duration
genre		avg_duration	running_total_duration	moving_avg_duration
Action		112.88			112.88					112.88
Adventure	101.87			214.75					107.38
Comedy		102.62			317.37					105.79
Crime		107.05			424.42					106.11
Drama		106.77			531.19					106.24
Family		100.97			632.16					105.36
Fantasy		105.14			737.30					105.33
Horror		92.72			830.02					103.75
Mystery		101.80			931.82					103.54
Others		100.16			1031.98					103.20
Romance		109.53			1141.51					103.78
Sci-Fi		97.94			1239.45					102.42
Thriller	101.58			1341.03					102.39

*INSIGHTS*
While comparing the average duration with genre we can 
see that Action Movies have the highest average duration and 
Horror Movies having Minimum average duration.
The moving average remains consistent with small trends 
playing around pprox 105 minutes.
----
For getting the running total we used the windows function SUM and rounded along with 
using condition ROWS UNBOUNDED PRECEDING so that it will take a sum from the starting row 
to the current row.
For moving average we used the windows function AVG and as well rounded it 
along with using condition ROWS 10 PRECEDING so that it will take average of 
10 preceding rows from current row. If there are less than 10 rows then the 
function will take only those rows for average calculation.
*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.
-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top3_genres AS
(
           SELECT     g.genre,
                      COUNT(m.id)                            AS movie_count ,
                      DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
           FROM       movie m
           INNER JOIN genre g
           ON         g.movie_id = m.id
           GROUP BY   g.genre LIMIT 3 ), movie_summary AS
(
           SELECT     genre,
                      m.year,
                      title                                                                                                                                        AS movie_name,
                      CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10))                                                       AS worlwide_gross_income ,
                      DENSE_RANK() OVER(PARTITION BY m.year ORDER BY CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) DESC ) AS movie_rank
           FROM       movie m
           INNER JOIN genre g
           ON         m.id = g.movie_id
           WHERE      genre IN
                      (
                             SELECT genre
                             FROM   top3_genres) )
SELECT   *
FROM     movie_summary
WHERE    movie_rank <= 5
ORDER BY year;

/* OUTPUT - Top 5 movies of each year with top 3 genres
genre		year	movie_name						worlwide_gross_income	movie_rank
Thriller	2017	The Fate of the Furious			1236005118				1
Comedy		2017	Despicable Me 3					1034799409				2
Comedy		2017	Jumanji: Welcome to the Jungle	962102237				3
Drama		2017	Zhan lang II					870325439				4
Thriller	2017	Zhan lang II					870325439				4
Comedy		2017	Guardians of the Galaxy Vol. 2	863756051				5
Thriller	2018	The Villain						1300000000				1
Drama		2018	Bohemian Rhapsody				903655259				2
Thriller	2018	Venom							856085151				3
Thriller	2018	Mission: Impossible - Fallout	791115104				4
Comedy		2018	Deadpool 2						785046920				5
Drama		2019	Avengers: Endgame				2797800564				1
Drama		2019	The Lion King					1655156910				2
Comedy		2019	Toy Story 4						1073168585				3
Drama		2019	Joker							995064593				4
Thriller	2019	Joker							995064593				4
Thriller	2019	Ne Zha zhi mo tong jiang shi	700547754				5

*INSIGHTS*
By comapring with the other years, the year 2019, the movie 
made the highest worldwide_gross and the genre was drama.
So we can make out that with as the time passes (in years) the gross_income 
is increasing for RSVP Movies.
----
Using CTE, we first created a temporary table with top 3 genres and 
named it as top3_genres. Created one more temporary table named 
movie_summary where we treated the null values in the column by 
replacing them and changing the datatype from varchar to decimal of the 
values already present in the table.
Used the windows function DENSE_RANK() to rank the movies based on 
worldwide_gross_income.
*/


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     production_company,
           COUNT(m.id)                             AS movie_count,
           RANK() OVER (ORDER BY Count(m.id) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
WHERE      median_rating >= 8
AND        production_company IS NOT NULL
AND        POSITION(',' IN languages) > 0
GROUP BY   production_company
ORDER BY   movie_count DESC 
LIMIT 2;

/* OUTPUT - Top 2 production_companies with median rating >= 8 among multilingual movies
production_company		movie_count		prod_comp_rank
Star Cinema				7				1
Twentieth Century Fox	4				2

*INSIGHTS*
Star Cinema and Twentieth Centruy Fox are the top 2 production 
companies with the given condition of multilingual movies and 
median rating >= 8.
----
In this query we need to take care of null values in the column 
production_company as it might affect the output.
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_summary AS
(
           SELECT     n.NAME                                                     AS actress_name,
                      SUM(total_votes)                                           AS total_votes,
                      COUNT(r.movie_id)                                          AS movie_count,
                      ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating
           FROM       movie                                                      AS m
           INNER JOIN ratings r
           ON         m.id = r.movie_id
           INNER JOIN genre g
           ON         g.movie_id = r.movie_id
           INNER JOIN role_mapping rm
           ON         m.id = rm.movie_id
           INNER JOIN names n
           ON         rm.name_id = n.id
           WHERE      category = 'actress'
           AND        genre = "Drama"
           AND        avg_rating > 8
           GROUP BY   NAME)
SELECT   *,
         RANK() OVER( ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary 
LIMIT 3;

/* OUTPUT - TOP 3 actresses based on movies with average rating > 8
actress_name		total_votes		movie_count	actress_avg_rating		actress_rank
Parvathy Thiruvothu	4974			2			8.25					1
Susan Brown			656				2			8.94					1
Amanda Lawrence		656				2			8.94					1

*INSIGHTS*
We can see that the top 3 actresses are Parvathy Thiruvothu
										Susan Brown
                                        Amanda Lawrence
----
But here we have not used DENSE_RANK as well as we can make out that
these actress's ranks are clashing. To get a more better output,
we can use DENSE_RANK and also apply WHERE condition wherein we
can mention that actress having Rank <= 3.
 
But still it will give us an output where we won't have a clear
answer to the question as it will give us the names of more than 3
actresses.
 */


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations
Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      name,
                      d.movie_id,
                      duration,
                      avg_rating,
                      total_votes,
                      m.date_published,
                      LEAD(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping d
           INNER JOIN names n
           ON         n.id = d.name_id
           INNER JOIN movie m
           ON         m.id = d.movie_id
           INNER JOIN ratings r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              DATEDIFF(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         COUNT(movie_id)               AS number_of_movies,
         ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
         ROUND(AVG(avg_rating),2)      AS avg_rating,
         SUM(total_votes)              AS total_votes,
         MIN(avg_rating)               AS min_rating,
         MAX(avg_rating)               AS max_rating,
         SUM(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC 
LIMIT 9;

/* OUTPUT - Top 9 Directors and thier info based on movie count
director_id	director_name		number_of_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration
nm2096009	Andrew Jones		5					190.75					3.02		1989		2.7			3.2			432
nm1777967	A.L. Vijay			5					176.75					5.42		1754		3.7			6.9			613
nm0814469	Sion Sono			4					331.00					6.03		2972		5.4			6.4			502
nm0831321	Chris Stokes		4					198.33					4.33		3664		4.0			4.6			352
nm0515005	Sam Liu				4					260.33					6.23		28557		5.8			6.7			312
nm0001752	Steven Soderbergh	4					254.33					6.48		171684		6.2			7.0			401
nm0425364	Jesse V. Johnson	4					299.00					5.45		14778		4.2			6.5			383
nm2691863	Justin Price		4					315.00					4.50		5343		3.0			5.8			346
nm6356309	Özgür Bakar			4					112.00					3.75		1092		3.1			4.9			374

*INSIGHTS*
From the ouput above we get to know who the top 9 directors are with Andrew Jones 
and A.L. Vijay being the top 2 directors based on the max number of
movies they directed.
----
But if we are checking it on the basis of total votes including the 
min_rating and max_rating we can clearly see from the output that 
Steven Soderbergh tops the directors with max votes and max_rating 7.0.
*/