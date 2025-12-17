
-- games dataset

CREATE TABLE games (
    title TEXT NOT NULL,
    release_date DATE,
    team TEXT,
    rating NUMERIC(3, 2),
    times_listed INTEGER,
    number_of_reviews INTEGER,
    genres TEXT,
    summary TEXT,
    plays INTEGER,
    playing INTEGER,
    backlogs INTEGER,
    wishlist INTEGER
);

select * from games;

select title, genres
from games
where genres like '%Indie%';


-- 1) 🌟 What are the top-rated games by user reviews?

create view top_rated_games_by_user_reviews as
select title, rating
from games
order by rating desc;

select * from top_rated_games_by_user_reviews;



-- 2) 🧑‍🤝‍🧑 Which developers (Teams) have the highest average ratings?

create view Teams_with_highest_average_ratings as
select team, avg(rating) as avg_ratings
from games
group by team
order by avg_ratings desc;

select * from Teams_with_highest_average_ratings;



-- 3) 🧩 What are the most common genres in the dataset?

create view most_common_genres as
SELECT genres, COUNT(genres) AS genre_count
FROM games
GROUP BY genres
ORDER BY genre_count DESC;

select * from most_common_genres;

-- 4) ⏳ Which games have the highest backlog compared to wishlist?

create view games_having_highest_backlog_compared_to_wishlist as
SELECT title, backlogs, wishlist,
       CAST(backlogs AS FLOAT) / NULLIF(wishlist, 0) AS backlog_wishlist_ratio
FROM games
ORDER BY backlog_wishlist_ratio DESC;

select * from games_having_highest_backlog_compared_to_wishlist;

-- 5) 🗓️ What is the game release trend across years?

create view game_release_trend_across_years as
select extract(year from release_date) as release_year, count(*) as number_of_games
from games
group by release_year
order by  release_year desc;

select * from game_release_trend_across_years;



-- 6) 🔎 What is the distribution of user ratings?

create view distribution_of_user_ratings as
SELECT rating, COUNT(*) AS games_count
FROM games
GROUP BY rating
ORDER BY rating;

select * from distribution_of_user_ratings;


-- 7) 🧑 What are the top 10 most wishlisted games?

create view top_10_most_wishlisted_games as 
select title, wishlist
from games
order by wishlist desc
limit 10;

select * from top_10_most_wishlisted_games;



-- 8) 🔬 What’s the average number of plays per genre?


create view avg_number_of_plays_per_genre as
SELECT
    TRIM(genre) AS genre,
    AVG(plays) AS average_plays
FROM
    games,
    unnest(string_to_array(genres, ',')) AS genre
WHERE
    genres IS NOT NULL AND genres != ''
GROUP BY
    TRIM(genre)
ORDER BY
    average_plays DESC;
	
select * from avg_number_of_plays_per_genre;

-- 9) 🏢 Which developer studios are the most productive and impactful?

create view most_productive_and_impactful_developer_studios as
SELECT team,
       COUNT(*) AS games_count,
       AVG(rating) AS avg_rating,
       SUM(number_of_reviews) AS total_reviews
FROM games
GROUP BY team
ORDER BY games_count DESC, avg_rating DESC;

select * from most_productive_and_impactful_developer_studios;





-- sales dataset


CREATE TABLE vgsales (
    rank INTEGER NOT NULL,
    name VARCHAR(150) NOT NULL,
    platform VARCHAR(10) NOT NULL,
    year DECIMAL(4,0),
    genre VARCHAR(15) NOT NULL,
    publisher VARCHAR(50) NOT NULL,
    na_sales DECIMAL(6,2) NOT NULL,
    eu_sales DECIMAL(6,2) NOT NULL,
    jp_sales DECIMAL(6,2) NOT NULL,
    other_sales DECIMAL(6,2) NOT NULL,
    global_sales DECIMAL(6,2) NOT NULL
);

select * from vgsales;

-- 1) 🌍 Which region generates the most game sales?

create view sales_in_each_region as
select 'North America' as region, sum(na_sales) as total_sales_in_millions from vgsales
union all
select 'European Union' as region, sum(eu_sales) as total_sales_in_millions from vgsales
union all
select 'Japan' as region, sum(jp_sales) as total_sales_in_millions from vgsales
union all
select 'Other' as region, sum(other_sales) as total_sales_in_millions from vgsales
order by total_sales_in_millions desc;

select * from sales_in_each_region;



-- 2) 🕹️ What are the best-selling platforms?

create view best_selling_platforms as
select platform, sum(global_sales) as total_global_sales
from vgsales
group by platform
order by total_global_sales desc;

select * from best_selling_platforms;



-- 3) 📅 What’s the trend of game releases and sales over years?

create view trend_of_game_releases_and_sales_over_years as
select year, sum(global_sales) as yearly_global_sales
from vgsales
group by year
order by yearly_global_sales desc;

select * from trend_of_game_releases_and_sales_over_years;



-- 4) 🏢 Who are the top publishers by sales?

create view top_publishers_by_sales as
select publisher, sum(global_sales) as total_global_sales
from vgsales
group by publisher
order by total_global_sales desc;

select * from top_publishers_by_sales;



-- 5) 🔝 Which games are the top 10 best-sellers globally?

create view top_10_best_sellers_globally as
select name as games, sum(global_sales) as total_global_sales
from vgsales
group by games
order by total_global_sales desc
limit 10;

select * from top_10_best_sellers_globally;



-- 6) 🧭 How do regional sales compare for specific platforms?

create view regional_sales_for_specific_platforms as
select platform, 
	   sum(na_sales) as total_na_sales,
	   sum(eu_sales) as total_eu_sales,
	   sum(jp_sales) as total_jp_sales,
	   sum(other_sales) as total_other_sales
from vgsales	   
group by platform;

select * from regional_sales_for_specific_platforms;



-- 7) 📈 How has the market evolved by platform over time?

create view market_evolution_by_platform_over_time as
select year, platform, sum(global_sales) as total_global_sales
from vgsales
group by year, platform
order by year asc;

select * from market_evolution_by_platform_over_time;



-- 8) 📍 What are the regional genre preferences?

create view regional_genre_preferences as
SELECT 'North America' AS region, genre, total_sales FROM (
    SELECT genre, SUM(na_sales) AS total_sales
    FROM vgsales
    GROUP BY genre
    ORDER BY total_sales DESC
    LIMIT 1
)
UNION ALL
SELECT 'Europe', genre, total_sales FROM (
    SELECT genre, SUM(eu_sales) AS total_sales
    FROM vgsales
    GROUP BY genre
    ORDER BY total_sales DESC
    LIMIT 1
)
UNION ALL
SELECT 'Japan', genre, total_sales FROM (
    SELECT genre, SUM(jp_sales) AS total_sales
    FROM vgsales
    GROUP BY genre
    ORDER BY total_sales DESC
    LIMIT 1
)
UNION ALL
SELECT 'Other', genre, total_sales FROM (
    SELECT genre, SUM(other_sales) AS total_sales
    FROM vgsales
    GROUP BY genre
    ORDER BY total_sales DESC
    LIMIT 1
);

select * from regional_genre_preferences;
	  




-- 9) 🔄 What’s the yearly sales change per region?

create view yearly_sales_change_per_region as
WITH YearlySales AS (
    select year,
		   sum(na_sales) as na_sales,
		   sum(eu_sales) as eu_sales,
		   sum(jp_sales) as jp_sales,
		   sum(other_sales) as other_sales
	from vgsales
	group by year
	order by year desc
)
SELECT
    year,
    na_sales - LAG(na_sales, 1, 0) OVER (ORDER BY year) AS na_sales_change,
    eu_sales - LAG(eu_sales, 1, 0) OVER (ORDER BY year) AS eu_sales_change,
    jp_sales - LAG(jp_sales, 1, 0) OVER (ORDER BY year) AS jp_sales_change,
    other_sales - LAG(other_sales, 1, 0) OVER (ORDER BY year) AS other_sales_change
FROM
    YearlySales;

select * from yearly_sales_change_per_region;



-- 10) 🧮 What is the average sales per publisher?

create view average_sales_per_publisher as
select publisher, avg(global_sales) as avg_sales, count(name) as number_of_games
from vgsales
group by publisher
order by avg_sales desc;

select * from average_sales_per_publisher;



-- 11) 🏆 What are the top 5 best-selling games per platform?

create view top_5_best_selling_games_per_platform as
with rankNumber as(
	select name,
	   platform,
	   global_sales,
	   row_number() over(partition by platform order by global_sales desc) as rn
	from vgsales
)
select name, platform, global_sales
from rankNumber
where rn <= 5
order by platform, global_sales desc;

select * from top_5_best_selling_games_per_platform;















-- 🔁 Merged Dataset (Sales + Engagement + Ratings)


-- 1) 🎮 Which game genres generate the most global sales?

create view games_generating_most_global_sales as
select vgsales.genre, sum(vgsales.global_sales) as total_global_sales
from vgsales
group by vgsales.genre
order by total_global_sales desc;

select * from games_generating_most_global_sales;


-- 2) 🎯 How does user rating affect global sales?

create view effect_of_rating_on_global_view as
select g.rating, avg(global_sales) as avg_global_sales, count(*) as num_games
from games g
join vgsales v 
on lower(g.title) = lower(v.name)
group by g.rating
order by g.rating desc;

select * from effect_of_rating_on_global_view;


-- 3) 🕹️ Which platforms have the most games with high ratings (e.g., above 4)?


create view platforms_having_most_games_with_high_ratings as
select v.platform, count(*) as num_high_rated_games
from games g
join vgsales v
on lower(g.title) = lower(v.name)
where g.rating > 4.0
group by v.platform
order by num_high_rated_games desc;

select * from platforms_having_most_games_with_high_ratings;


-- 4) 📈 What’s the trend of releases and sales over time?

create view trend_of_releases_and_sales_over_time as
select extract(year from g.release_date) as release_year,
	   count(distinct g.title) as num_releases,
	   sum(v.global_sales) as total_global_sales
from games g
join vgsales v
on lower(g.title) = lower(v.name)
group by release_year
order by release_year asc;

select * from trend_of_releases_and_sales_over_time;


-- 5) 🧍 Do highly wishlisted games lead to more sales?

create view highly_wishlisted_games_vs_sales as
select
	  case when g.wishlist >= 2000 then 'Highly wishlisted' else 'others' end as wishlist_group,
	  avg(v.global_sales) as avg_global_sales,
	  count(*) as num_games
from games g
join vgsales v
on lower(g.title) = lower(v.name)
group by wishlist_group;

select * from highly_wishlisted_games_vs_sales;


-- 6) 🎮 Which genres have the highest engagement but lowest sales?

create view genres_with_highest_engagement_but_lowest_sales as
select 
	v.genre,
	avg(g.plays + g.playing + g.backlogs + g.wishlist) as avg_engagement,
	avg(v.global_sales) as avg_global_sales
from games g
join vgsales v
on lower(g.title) = lower(v.name)
group by v.genre
order by avg_engagement desc, avg_global_sales asc;

select * from genres_with_highest_engagement_but_lowest_sales;


-- 7) 🧠 Do highly listed games (wishlist/backlogs) correlate with better ratings?

create view highly_listed_games_vs_better_ratings as
select
	  case when g.wishlist + g.backlogs >= 2000 then 'Highly listed' else 'Others' end as listed_group,
	  avg(g.rating) as avg_rating,
	  count(*) as num_games
from games g
join vgsales v
on lower(g.title) = lower(v.name)
group by listed_group;

select * from highly_listed_games_vs_better_ratings;


-- 8) 🏷️ How does user engagement differ across genres?

create view user_engagement_across_genres as
select 
	  v.genre,
	  avg(g.plays + g.playing + g.backlogs + g.wishlist) as total_avg_engagement
from games g
join vgsales v
on lower(g.title) = lower(v.name)
group by v.genre
order by total_avg_engagement;

select * from user_engagement_across_genres;


-- 9) 🎉 What are the top-performing combinations of Genre + Platform?

create view top_performing_combinations_of_Genre_and_Platform as
select v.platform, v.genre, sum(v.global_sales) as total_global_sales
from vgsales as v
group by v.platform, v.genre
order by total_global_sales desc;

select * from top_performing_combinations_of_Genre_and_Platform;


-- 10) 🌐 What does a regional sales heatmap by genre reveal?

create view regional_sales_heatmap_by_genre as
select
	  v.genre,
	  sum(v.na_sales) as na_sales,
	  sum(v.eu_sales) as eu_sales,
	  sum(v.jp_sales) as jp_sales,
	  sum(v.other_sales) as other_sales
from vgsales as v
group by v.genre
order by v.genre;
		
select * from regional_sales_heatmap_by_genre;
		
		
		
		
		
