--Adv SQL project--Spotify Datasets

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
--EDA
select count (*) from spotify ;

select count(distinct artist) from spotify;

select distinct album_type from spotify;

select max(duration_min) from spotify;

select min(duration_min) from spotify;

select * from spotify 
where duration_min = 0;

DELETE FROM spotify
where duration_min = 0;

select * from spotify 
where duration_min = 0;

select distinct channel from spotify;

--EASY LEVEL PROBLEMS
/*
1.Retrieve the names of all tracks that have more than 1 billion streams.
2.List all albums along with their respective artists.
3.Get the total number of comments for tracks where licensed = TRUE.
4.Find all tracks that belong to the album type single.
5.Count the total number of tracks by each artist.*/

--Q1.Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify
WHERE stream > 1000000000

--Q2.List all albums along with their respective artists.

SELECT 
	DISTINCT album,
	artist 
FROM spotify
ORDER BY 1

--Q3.Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(comments) as total_comments
FROM SPOTIFY
WHERE 
	licensed = 'TRUE'

--Q4.Find all tracks that belong to the album type single.

SELECT track,album_type FROM spotify
WHERE	
	album_type = 'single'

--Q5.Count the total number of tracks by each artist.

SELECT artist,count(album) as total_number_of_tracks 
FROM spotify
group by artist
ORDER BY 2

/*MEDIUM LEVEL PROBLEMS
6.Calculate the average danceability of tracks in each album.
7.Find the top 5 tracks with the highest energy values.
8.List all tracks along with their views and likes where official_video = TRUE.
9.For each album, calculate the total views of all associated tracks.
10.Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

--Q6.Calculate the average danceability of tracks in each album.

SELECT 
track ,
avg(danceability)
FROM spotify
group by 1


--Q7.Find the top 5 tracks with the highest energy values.

SELECT 
	track,	
	max(energy)
FROM Spotify
group by 1
order by 2 DESC
LIMIT 5


--Q8.List all tracks along with their views and likes where official_video = TRUE.

SELECT 
	track,
	max (views) as total_views,
	max (likes) as total_likes
FROM Spotify
WHERE official_video = 'true' 
group by 1
order by 2 DESC



--Q9.For each album, calculate the total views of all associated tracks.

SELECT 
	album,
	track,
	sum(views) as total_views
FROM Spotify
group by 1,2
order by 3 DESC

--Q10.Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM (
SELECT 
	track ,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify
FROM SPOTIFY
GROUP BY 1
) as t1
WHERE 
	 streamed_on_spotify > streamed_on_youtube
	 AND
	 streamed_on_youtube <> 0
	


/*HARD LEVEL PROBLEMS
11.Find the top 3 most-viewed tracks for each artist using window functions.
12.Write a query to find tracks where the liveness score is above the average.
13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
*/

--Q11.Find the top 3 most-viewed tracks for each artist using window functions.


WITH ranking_artist 
as(
SELECT 
	artist,
	track,
	SUM(views) as total_view,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views)DESC) AS rank
FROM spotify
group by 1,2
order by 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3 


--Q12.Write a query to find tracks where the liveness score is above the average.

SELECT 
track,
artist,
liveness
FROM spotify
WHERE  liveness > (SELECT AVG(liveness)from spotify) 


--Q13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energy as energy_dif
FROM cte
ORDER BY 2 DESC