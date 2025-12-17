# 🎮 Video Game Sales & Engagement Analysis

## 📌 Project Overview
In the competitive gaming industry, sales figures only tell half the story. This project merges **Global Sales Data** with **User Engagement Metrics** (Ratings, Wishlists, and Backlogs) to uncover deeper insights into platform performance and genre trends.

By combining these datasets, the analysis identifies which factors (like critical acclaim or pre-release hype) actually correlate with commercial success.

---

## 🛠️ Tech Stack
- **Database:** PostgreSQL (Advanced Joins, CTEs, and View Creation)
- **Data Preprocessing:** Python (Pandas)
- **Interactive App:** Streamlit (Custom SQL Query Runner)
- **BI Tool:** Power BI (Visual Trend Analysis)

---

## 📂 Project Structure & Files
* **`video_games.sql`**: The core analytical engine containing 10+ complex queries joining sales and engagement data.
* **`app.py`**: A Streamlit web application that provides a UI to interact with the database.
* **`videoGames.pbix`**: Interactive Power BI dashboard for executive-level reporting.
* **`Data/`**: Contains the cleaned datasets for both Sales and Engagement metrics.

---

## 🔍 Key Business Insights
* **Hype vs. Sales:** Analysed if high **Wishlist** counts actually lead to better **Global Sales** performance.
* **Genre Dominance:** Identified top-performing combinations of **Genre + Platform** (e.g., Action games on PS4 vs. RPGs on PC).
* **Engagement Metrics:** Evaluated user "Backlogs" to understand which genres keep players engaged long-term.
* **Developer Benchmarking:** Ranked "Teams" (Developers) based on their average user ratings and review volume.

---

## 🚀 How to Run the Project

### 1. Database Setup
Execute the schema and queries in `video_games.sql` to create the structured tables and analytical views.

### 2. Streamlit Web Dashboard
Launch the interactive portal to run live SQL queries against the dataset:
```bash
pip install requirements.txt
streamlit run app.py
