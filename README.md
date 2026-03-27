# 🎓 Indian Engineering Student Placement Analysis (Batch 2027)

## 📌 Project Overview
An end-to-end data analysis project identifying the core drivers of placement success among 3rd-year engineering students. This study integrates **Academic Performance**, **Technical Skills**, and **Lifestyle Factors** (Sleep/Stress) to provide a 360-degree view of career readiness.

## 🛠️ Tech Stack
* **SQL (MySQL):** Data cleaning, Joining, and Statistical Correlation.
* **Power BI:** Interactive Dashboarding and AI-driven Root Cause Analysis.
* **Excel:** Initial data exploration.

## 🔍 Key Data Insights (The "So What?")
* **The Internship Premium:** Students with 2+ internships saw a **15% increase** in average salary packages.
* **Skill Gap identified:** A significant delta exists in **Aptitude scores** between placed and unplaced students, suggesting a bottleneck in initial screening rounds.
* **Sustainability Alert:** Data shows a "Burnout" point at Stress Level 9, where placement probability drops by **12%**.

* !<img width="1320" height="737" alt="Screenshot 2026-03-27 172058" src="https://github.com/user-attachments/assets/50ecbb51-9119-4cf6-9915-22b85690069e" />


## 💻 SQL Highlight
I utilized complex JOINs and CASE statements to segment the student body by "Market Readiness":
```sql
-- Query to calculate the 'Institutional Value-Add' Score
SELECT 
    branch, 
    AVG(cgpa - ((tenth_percentage + twelfth_percentage)/20)) AS growth_score 
FROM students 
GROUP BY branch;
PowerBI dashboard
