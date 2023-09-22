#---- Number of songs on Spotify for each artist -----

SELECT artist_name, COUNT(*) AS Number_of_Songs FROM Spotify GROUP BY artist_name ORDER BY COUNT(*) DESC;

# -------------------- Top 10 songs based on popularity ---------------------------------
select * from spotify;
select track_name ,track_popularity , album ,album from spotify order by track_popularity desc limit 10;

#-------------------------- Total number of songs on spotify based on year -----------------------------------

select `year` track_name , count(track_name) as song_count from spotify group by `year` order by `year` desc;

## Top song for each year (2000-2022) based on popularity

select `year` , track_id,track_name,track_popularity as popularity from (
select `year` , track_id,track_name,track_popularity, row_number() over(partition by `year` order by track_popularity desc ) as `rank` from spotify) as song_rank
where `rank` =1;
# ------------------Another way to achive that with cte ----------------------------------
with RankedSongsas as (select year , track_name , track_popularity,
row_number() over(partition by year order by track_popularity desc) as `rank`
from spotify where year between 2000 and 2022
)

select year,
    track_name AS top_song,
    track_popularity from RankedSongsas where `rank` =1 order by track_popularity desc;

#---------------------------- Analysis based on Tempo ----------------------------

select round(avg(tempo)) from spotify;

select track_name,tempo ,
(case
 when tempo >121 then "Above average Tempo"
 when tempo =121 then "Average Tempo"
 when tempo <121 then "Below Average Tempo"
 end) as avg_tempo from spotify order by avg_tempo desc;

# ------------- Songs with Highest Tempo -------------------

 select track_name , tempo from spotify  order by tempo desc limit 10 offset 0;
 
 #---------------------- Number of Songs for different Tempo Range ------------------------------
 
 select distinct tempo , min(tempo) , max(tempo) from spotify order by tempo desc;

select
SUM(CASE WHEN (TEMPO between 60.00 and 100.00) THEN 1 ELSE 0 END) AS CLASSIC_NUSIC,
SUM(CASE WHEN (TEMPO between 100.00 and 120.00) THEN 1 ELSE 0 END)AS MODERN_MUSIC,
SUM(CASE WHEN (TEMPO between 120.00 and 150.00) THEN 1 ELSE 0 END)AS DANCE_MUSIC,
SUM(CASE WHEN (TEMPO < 150.01) THEN 1 ELSE 0 END) AS HighTempo_Music
FROM spotify;


#----------------------------- Energy Analysis ----------------

SELECT ENERGY FROM spotify where energy>1;
SELECT ROUND(avg(ENERGY)) FROM spotify order by energy DESC;
 SELECT
    track_name,
    energy,
    avg_energy
    from
    (
SELECT
    track_name,
    energy,
    (CASE
        WHEN round(energy) > 1 THEN 'Above average Tempo'
        WHEN round(energy) = 1 THEN 'Average Tempo'
        WHEN round(energy) < 1 THEN 'Below Average Tempo'
     END) AS avg_energy
FROM
    spotify ) as energy_categories where avg_energy =  'Average Tempo';

 #----------------------Analyse Artist popularity---------------------
    
     select min(artist_popularity) , max(artist_popularity), AVG(artist_popularity) from spotify;

    select artist_popularity,
    (
    CASE
        WHEN artist_popularity between 25 AND 50 THEN "LESS POPULAR"
	    WHEN artist_popularity between 51 AND 75 THEN "AVERAGE POPULAR"
        WHEN artist_popularity between 76 AND 90 THEN "ABOVE AVERAGE POPULAR"
        WHEN artist_popularity  >90 THEN  "POPULAR"
           END)
    AS artist_pop from spotify order by artist_pop desc;


select NTILE(6) OVER (PARTITION BY artist_popularity ) AS bucket from spotify;
