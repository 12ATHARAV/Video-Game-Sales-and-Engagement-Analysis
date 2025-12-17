import streamlit as st
import pandas as pd
import psycopg2


# Database connection
def connect_db():
    return psycopg2.connect(
        host=YOUR_HOST_NAME,
        database=YOUR_DATABASE_NAME,
        user=YOUR_USERNAME,
        passwordYOUR_PASSWORD,
        port=PORT
    )

# SQL Queries
games = {
    "Show all rows": """select * from games""",
    
    "1) 🌟 What are the top-rated games by user reviews?" : """
        select title, rating
        from games
        order by rating desc;
    """,
    
    "2) 🧑‍🤝‍🧑 Which developers (Teams) have the highest average ratings?":"""
        select team, avg(rating) as avg_ratings
        from games
        group by team
        order by avg_ratings desc;
    """,
    
    "3) 🧩 What are the most common genres in the dataset?":"""
    
    """,
    
    "4) ⏳ Which games have the highest backlog compared to wishlist?":"""
    
    """,
    
    "5) 🗓️ What is the game release trend across years?":"""
        select extract(year from release_date) as release_year, count(*) as number_of_games
        from games
        group by release_year
        order by  release_year desc;
    """,
    
    "6) 🔎 What is the distribution of user ratings?":"""
        
    """,
    
    "7) 🧑 What are the top 10 most wishlisted games?":"""
        select title, wishlist
        from games
        order by wishlist desc
        limit 10;
    """,
    
    "8) 🔬 What’s the average number of plays per genre?":"""
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
    """,
    
    "9) 🏢 Which developer studios are the most productive and impactful?":"""
    
    """
}


sales = {
    "Show all rows": """select * from vgsales""",
    
    "1) 🌍 Which region generates the most game sales?":"""
        select 'North America' as region, sum(na_sales) as total_sales_in_millions from vgsales
        union all
        select 'European Union' as region, sum(eu_sales) as total_sales_in_millions from vgsales
        union all
        select 'Japan' as region, sum(jp_sales) as total_sales_in_millions from vgsales
        union all
        select 'Other' as region, sum(other_sales) as total_sales_in_millions from vgsales
        order by total_sales_in_millions desc;
    """,
    
    "2) 🕹️ What are the best-selling platforms?":"""
        select platform, sum(global_sales) as total_global_sales
        from vgsales
        group by platform
        order by total_global_sales desc;
    """,
    
    "3) 📅 What’s the trend of game releases and sales over years?":"""
        select year, sum(global_sales) as yearly_global_sales
        from vgsales
        group by year
        order by yearly_global_sales desc;
    """,
    
    "4) 🏢 Who are the top publishers by sales?":"""
        select publisher, sum(global_sales) as total_global_sales
        from vgsales
        group by publisher
        order by total_global_sales desc;
    """,
    
    "5) 🔝 Which games are the top 10 best-sellers globally?":"""
        select name as games, sum(global_sales) as total_global_sales
        from vgsales
        group by games
        order by total_global_sales desc
        limit 10;
    """,
    
    "6) 🧭 How do regional sales compare for specific platforms?":"""
        select platform, 
            sum(na_sales) as total_na_sales,
            sum(eu_sales) as total_eu_sales,
            sum(jp_sales) as total_jp_sales,
            sum(other_sales) as total_other_sales
        from vgsales	   
        group by platform;
    """,
    
    "7) 📈 How has the market evolved by platform over time?":"""
        select year, platform, sum(global_sales) as total_global_sales
        from vgsales
        group by year, platform
        order by year asc;
    """,
    
    "8) 📍 What are the regional genre preferences?":"""
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
    """,
    
    "9) 🔄 What’s the yearly sales change per region?":"""
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
    """,
    
    "10) 🧮 What is the average sales per publisher?":"""
        select publisher, avg(global_sales) as avg_sales, count(name) as number_of_games
        from vgsales
        group by publisher
        order by avg_sales desc;
    """,
    
    "11) 🏆 What are the top 5 best-selling games per platform?":"""
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
    """
}


merged = {
    "1) 🎮 Which game genres generate the most global sales?": """
        select vgsales.genre, sum(vgsales.global_sales) as total_global_sales
        from vgsales
        group by vgsales.genre
        order by total_global_sales desc;
    """,
    
    "2) 🎯 How does user rating affect global sales?":"""
        select g.rating, avg(global_sales) as avg_global_sales, count(*) as num_games
        from games g
        join vgsales v 
        on lower(g.title) = lower(v.name)
        group by g.rating
        order by g.rating desc;
    """,
    
    "3) 🕹️ Which platforms have the most games with high ratings (e.g., above 4)?":"""
        select v.platform, count(*) as num_high_rated_games
        from games g
        join vgsales v
        on lower(g.title) = lower(v.name)
        where g.rating > 4.0
        group by v.platform
        order by num_high_rated_games desc;
    """,
    
    "4) 📈 What’s the trend of releases and sales over time?":"""
        select extract(year from g.release_date) as release_year,
            count(distinct g.title) as num_releases,
            sum(v.global_sales) as total_global_sales
        from games g
        join vgsales v
        on lower(g.title) = lower(v.name)
        group by release_year
        order by release_year asc;
    """,
    
    "5) 🧍 Do highly wishlisted games lead to more sales?":"""
        select
            case when g.wishlist >= 2000 then 'Highly wishlisted' else 'others' end as wishlist_group,
            avg(v.global_sales) as avg_global_sales,
            count(*) as num_games
        from games g
        join vgsales v
        on lower(g.title) = lower(v.name)
        group by wishlist_group;
    """,
    
    "6) 🎮 Which genres have the highest engagement but lowest sales?":"""
        select 
            v.genre,
            avg(g.plays + g.playing + g.backlogs + g.wishlist) as avg_engagement,
            avg(v.global_sales) as avg_global_sales
        from games g
        join vgsales v
        on lower(g.title) = lower(v.name)
        group by v.genre
        order by avg_engagement desc, avg_global_sales asc;
    """,
    
    "7) 🧠 Do highly listed games (wishlist/backlogs) correlate with better ratings?":"""
        select
            case when g.wishlist + g.backlogs >= 2000 then 'Highly listed' else 'Others' end as listed_group,
            avg(g.rating) as avg_rating,
            count(*) as num_games
        from games g
        join vgsales v
        on lower(g.title) = lower(v.name)
        group by listed_group;
    """,
    
    "8) 🏷️ How does user engagement differ across genres?":"""
        select 
            v.genre,
            avg(g.plays + g.playing + g.backlogs + g.wishlist) as total_avg_engagement
        from games g
        join vgsales v
        on lower(g.title) = lower(v.name)
        group by v.genre
        order by total_avg_engagement;
    """,
    
    "9) 🎉 What are the top-performing combinations of Genre + Platform?":"""
        select v.platform, v.genre, sum(v.global_sales) as total_global_sales
        from vgsales as v
        group by v.platform, v.genre
        order by total_global_sales desc;
    """,
    
    "10) 🌐 What does a regional sales heatmap by genre reveal?":"""
        select
            v.genre,
            sum(v.na_sales) as na_sales,
            sum(v.eu_sales) as eu_sales,
            sum(v.jp_sales) as jp_sales,
            sum(v.other_sales) as other_sales
        from vgsales as v
        group by v.genre
        order by v.genre;
    """
}





st.sidebar.title("📊 Navigation")

if st.sidebar.button("🎮 Games SQL Queries", use_container_width=True):
    st.session_state.page = "Games SQL Queries"
    
if st.sidebar.button("💰 Sales SQL Queries", use_container_width=True):
    st.session_state.page = "Sales SQL Queries"
    
if st.sidebar.button("⭐ Overall SQL Queries", use_container_width=True):
    st.session_state.page = "Overall SQL Queries"    
    
if st.sidebar.button("📈 Data Analysis", use_container_width=True):
    st.session_state.page = "Data Analysis"

# Initialize page if not set
if "page" not in st.session_state:
    st.session_state.page = "Games SQL Queries"  # default page
    
    
page = st.session_state.page

if page == "Games SQL Queries":
    st.title("🎮 Game Metadata - SQL Queries")

    # Query selection
    selected = st.selectbox("Choose a query:", list(games.keys()))

    # Show SQL
    st.code(games[selected], language="sql")

    # Execute button
    if st.button("Run Query"):
        try:
            conn = connect_db()
            df = pd.read_sql(games[selected], conn)
            conn.close()
            
            st.dataframe(df)
            st.success(f"Found {len(df)} rows")
            
        except Exception as e:
            st.error(f"Error: {e}")
            
            
elif page == "Sales SQL Queries":
    st.title("💰 Sales Data - SQL Queries")

    # Query selection
    selected = st.selectbox("Choose a query:", list(sales.keys()))

    # Show SQL
    st.code(sales[selected], language="sql")

    # Execute button
    if st.button("Run Query"):
        try:
            conn = connect_db()
            df = pd.read_sql(sales[selected], conn)
            conn.close()
            
            st.dataframe(df)
            st.success(f"Found {len(df)} rows")
            
        except Exception as e:
            st.error(f"Error: {e}")



elif page == "Overall SQL Queries":
    st.title("⭐ Sales + Engagement + Ratings - SQL Queries")

    # Query selection
    selected = st.selectbox("Choose a query:", list(merged.keys()))

    # Show SQL
    st.code(merged[selected], language="sql")

    # Execute button
    if st.button("Run Query"):
        try:
            conn = connect_db()
            df = pd.read_sql(merged[selected], conn)
            conn.close()
            
            st.dataframe(df)
            st.success(f"Found {len(df)} rows")
            
        except Exception as e:
            st.error(f"Error: {e}")



elif page == "Data Analysis":
    st.title("📈 Power BI Visuals")
    
    powerbi_url = "https://app.powerbi.com/reportEmbed?reportId=ec60c1b8-c158-4721-9817-5b9983dba5df&autoAuth=true&ctid=bbe700f7-d45e-4f28-82a4-7cc82d7d5ebe"
    
    # Embed Power BI via iframe
    st.components.v1.iframe(powerbi_url, width=900, height=573.5)
