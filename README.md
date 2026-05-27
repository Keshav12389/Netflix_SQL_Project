# 🎬 Netflix Content Analysis — SQL Project

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

## 📌 Project Overview

This project performs a comprehensive analysis of Netflix's movies and TV shows catalog using **PostgreSQL**. By solving **15 real-world business problems**, the project extracts meaningful insights around content distribution, regional trends, audience ratings, and content safety — the kind of analysis that directly supports data-driven decisions in a streaming business.

**Dataset:** [Netflix Movies and TV Shows — Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)  
**Total Titles Analyzed:** 8,800+  
**Tool Used:** PostgreSQL / pgAdmin  
**Author:** Keshav Meena | IIT Delhi

---

## 🗂️ Database Schema

```sql
CREATE TABLE netflix (
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

---

## 🎯 Business Problems Solved

| # | Business Question | SQL Concepts Used |
|---|---|---|
| 01 | Count of Movies vs TV Shows | GROUP BY, COUNT |
| 02 | Most common rating per content type | RANK(), PARTITION BY, Subquery |
| 03 | All movies released in a specific year | WHERE, Filter |
| 04 | Top 5 countries by content volume | UNNEST, STRING_TO_ARRAY, ORDER BY |
| 05 | Identify the longest movie | MAX(), Subquery |
| 06 | Content added in the last 5 years | TO_DATE, INTERVAL, CURRENT_DATE |
| 07 | All content by director 'Rajiv Chilaka' | ILIKE, Pattern Matching |
| 08 | TV Shows with more than 5 seasons | SPLIT_PART, CAST, Numeric filter |
| 09 | Content count per genre | UNNEST, STRING_TO_ARRAY, GROUP BY |
| 10 | India's average content releases per year | ROUND, Subquery, GROUP BY |
| 11 | All documentary movies | ILIKE |
| 12 | Content with missing director info | IS NULL |
| 13 | Salman Khan movies in last 10 years | ILIKE, EXTRACT, CURRENT_DATE |
| 14 | Top 10 actors in Indian productions | UNNEST, STRING_TO_ARRAY, COUNT |
| 15 | Content categorized by violent keywords | CASE WHEN, ILIKE, Nested Query |

---

## 💡 Key Findings

- **Movies dominate** the platform — roughly 70% Movies vs 30% TV Shows
- **United States** is the top content-producing country, with **India ranking 2nd**
- **TV-MA and TV-14** are the most common ratings, indicating a primarily adult audience
- **2019 was Netflix's peak content addition year** — highest number of titles added in a single year
- **International Movies and Dramas** are the top 2 genres by volume
- Around **30% of content descriptions** contain keywords related to violence or conflict
- Over **2,600 titles** have missing director information — a significant data quality issue
- Indian actor **Anupam Kher** leads the top 10 most-appearing actors in Indian productions

---

## 📁 Repository Structure

```
netflix-content-analysis-sql/
│
├── README.md                  ← Project overview and findings
├── netflix_analysis.sql       ← All 15 queries + 3 bonus queries
└── dataset/
    └── netflix_titles.csv     ← Source data (from Kaggle)
```

---

## 🚀 How to Run This Project

**Step 1 — Set up PostgreSQL**
- Install [PostgreSQL](https://www.postgresql.org/download/) and pgAdmin

**Step 2 — Create the database**
```sql
CREATE DATABASE netflix_db;
```

**Step 3 — Create the table**
- Run the CREATE TABLE query from `netflix_analysis.sql`

**Step 4 — Import the dataset**
```sql
COPY netflix FROM '/your/path/netflix_titles.csv'
DELIMITER ',' CSV HEADER;
```

**Step 5 — Run the queries**
- Open `netflix_analysis.sql` in pgAdmin
- Run each query section by section

---

## 🛠️ SQL Techniques Demonstrated

- **Window Functions** — RANK(), DENSE_RANK(), PARTITION BY, ORDER BY
- **String Operations** — UNNEST(), STRING_TO_ARRAY(), SPLIT_PART(), ILIKE, TRIM()
- **Date Functions** — TO_DATE(), EXTRACT(), CURRENT_DATE, INTERVAL
- **Conditional Logic** — CASE WHEN / THEN / ELSE
- **Subqueries** — Scalar subqueries and inline views
- **Aggregations** — COUNT(), MAX(), ROUND(), GROUP BY, HAVING
- **Data Cleaning** — IS NULL checks, pattern matching with regex (~)

---

## 📊 Sample Query — Most Common Rating per Content Type

```sql
SELECT type, rating
FROM (
    SELECT
        type,
        rating,
        COUNT(*),
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY 1, 2
) AS t1
WHERE ranking = 1;
```

---

## 📊 Sample Query — Top 10 Indian Actors on Netflix

```sql
SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
    COUNT(*) AS total_appearances
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

---

## 🔗 Connect with Me

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/keshav-meena-629b93223/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Keshav12389)

---

*This project is part of my data analytics portfolio. Feel free to fork, star, or raise issues!*
