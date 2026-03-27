RENAME TABLE `placement_targets` TO `results`;
#The "Skill vs. Salary" Matrix
SELECT 
    s.Branch, 
    COUNT(s.Student_ID) AS Total_Students,
    SUM(CASE WHEN r.Placement_Status = 'Placed' THEN 1 ELSE 0 END) AS Placed_Count,
    ROUND((SUM(CASE WHEN r.Placement_Status = 'Placed' THEN 1 ELSE 0 END) / COUNT(s.Student_ID)) * 100, 2) AS Success_Rate_Percentage
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
GROUP BY s.Branch
ORDER BY Success_Rate_Percentage DESC;

#

SELECT 
    s.Internships, 
    COUNT(s.Student_ID) AS Student_Count,
    ROUND(AVG(r.Salary), 0) AS Average_Salary
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
WHERE r.Placement_Status = 'Placed'
GROUP BY s.Internships
ORDER BY s.Internships ASC;
DESCRIBE students;

SELECT 
    CASE 
        WHEN Aptitude_Score > 80 AND Communication_Skills > 80 THEN 'Top Talent (Both 80+)'
        WHEN Aptitude_Score > 80 THEN 'High Logic (Aptitude 80+)'
        WHEN Communication_Skills > 80 THEN 'High Soft Skills (Comm 80+)'
        ELSE 'Standard'
    END AS Student_Profile,
    COUNT(*) AS Student_Count,
    ROUND(AVG(Salary), 0) AS Avg_Package
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
WHERE r.Placement_Status = 'Placed'
GROUP BY Student_Profile
ORDER BY Avg_Package DESC;

#The "Project Threshold"
SELECT 
    Projects_Completed,
    COUNT(*) AS Total_Students,
    SUM(CASE WHEN Placement_Status = 'Placed' THEN 1 ELSE 0 END) AS Placed,
    ROUND((SUM(CASE WHEN Placement_Status = 'Placed' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS Placement_Rate
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
GROUP BY Projects_Completed
ORDER BY Projects_Completed ASC;


#The "Lucknow vs. Neighboring Cities" (Local Context)

SELECT 
    Branch,
    ROUND(AVG(CGPA), 2) AS Avg_CGPA,
    COUNT(*) AS Placed_Count
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
WHERE r.Placement_Status = 'Placed'
GROUP BY Branch
HAVING Avg_CGPA > 7.5; -- Filtering for the high performers

#The "Placement Rate by Branch"
SELECT 
    s.branch, 
    COUNT(s.Student_ID) AS total_students,
    SUM(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) AS placed_count,
    ROUND((SUM(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) / COUNT(s.Student_ID)) * 100, 2) AS placement_percentage
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
GROUP BY s.branch
ORDER BY placement_percentage DESC;

#The "Skill Gap Analysis"
#This query proves exactly why some students are getting left behind by comparing the average skills of both groups.
SELECT 
    r.placement_status,
    ROUND(AVG(s.coding_skill_rating), 2) AS avg_coding,
    ROUND(AVG(s.communication_skill_rating), 2) AS avg_comm,
    ROUND(AVG(s.aptitude_skill_rating), 2) AS avg_aptitude,
    ROUND(AVG(s.cgpa), 2) AS avg_cgpa
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
GROUP BY r.placement_status;

#The "Internship ROI"
#Does more experience lead to more money? This query calculates the average salary based on the number of internships completed.
SELECT 
    s.internships_completed,
    COUNT(s.Student_ID) AS student_count,
    ROUND(AVG(r.salary_lpa), 2) AS avg_package,
    MAX(r.salary_lpa) AS highest_package
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
WHERE r.placement_status = 'Placed'
GROUP BY s.internships_completed
ORDER BY s.internships_completed DESC;

#The "High-Risk Student" List
#. This identifies unplaced students with high backlogs or low coding scores so the college can help them
SELECT 
    s.Student_ID, 
    s.branch, 
    s.cgpa, 
    s.backlogs, 
    s.coding_skill_rating
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
WHERE r.placement_status = 'Not Placed' 
  AND (s.backlogs > 0 OR s.coding_skill_rating < 5)
ORDER BY s.cgpa DESC;


#The "Stress vs. Placement" Analysis
#This query calculates the "Placement Probability" based on a student's stress level.
SELECT 
    s.stress_level,
    COUNT(s.Student_ID) AS total_students,
    SUM(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) AS placed_count,
    ROUND((SUM(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) / COUNT(s.Student_ID)) * 100, 2) AS placement_rate
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
GROUP BY s.stress_level
ORDER BY s.stress_level DESC;

#The "Lifestyle Master" Stress level branch wise , avg salary, avg coding 
SELECT 
    s.branch,
    ROUND(AVG(s.stress_level), 1) AS avg_stress,
    ROUND(AVG(s.sleep_hours), 1) AS avg_sleep,
    ROUND(AVG(r.salary_lpa), 2) AS avg_salary,
    ROUND(AVG(s.coding_skill_rating), 1) AS avg_coding
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
WHERE r.placement_status = 'Placed'
GROUP BY s.branch
ORDER BY avg_salary DESC;

# Extracurricular & Hackathons
#This query calculates the placement rate for each level of extracurricular involvement.

SELECT 
    s.extracurricular_involvement,
    COUNT(s.Student_ID) AS total_students,
    SUM(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) AS placed_count,
    ROUND((SUM(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) / COUNT(s.Student_ID)) * 100, 2) AS placement_rate
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
GROUP BY s.extracurricular_involvement
ORDER BY placement_rate DESC;
# Internship & non internship
#the Placement Rate and the Average Salary for both groups.
SELECT 
    CASE 
        WHEN s.internships_completed > 0 THEN 'With Internship' 
        ELSE 'Without Internship' 
    END AS internship_status,
    COUNT(s.Student_ID) AS student_count,
    ROUND(AVG(r.salary_lpa), 2) AS avg_package,
    SUM(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) AS placed_students,
    ROUND((SUM(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) / COUNT(s.Student_ID)) * 100, 2) AS placement_rate
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
GROUP BY internship_status;

#. The "Experience vs. Grades" 
# Can an internship save a student with a low CGPA? This query checks if students with low CGPA but high internships still get placed.
SELECT 
    CASE WHEN s.cgpa >= 8 THEN 'High CGPA (8+)' ELSE 'Low CGPA (<8)' END AS academic_tier,
    CASE WHEN s.internships_completed > 0 THEN 'Interned' ELSE 'No Internship' END AS exp_tier,
    ROUND(AVG(CASE WHEN r.placement_status = 'Placed' THEN 1 ELSE 0 END) * 100, 2) AS placement_probability
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
GROUP BY academic_tier, exp_tier
ORDER BY academic_tier DESC, exp_tier DESC;

#Does Schooling (10th/12th) vs. College (CGPA) Matter?
#This is the most controversial part of placement.I use a Correlation Query to see which one has a stronger link to the Final Salary.
SELECT 
    CASE 
        WHEN cgpa >= 9 THEN '9+ CGPA'
        WHEN cgpa >= 8 THEN '8-9 CGPA'
        ELSE 'Below 8'
    END AS cgpa_bracket,
    ROUND(AVG(tenth_percentage), 2) AS avg_10th,
    ROUND(AVG(twelfth_percentage), 2) AS avg_12th,
    ROUND(AVG(salary_lpa), 2) AS avg_salary
FROM students s
JOIN results r ON s.Student_ID = r.Student_ID
WHERE r.placement_status = 'Placed'
GROUP BY cgpa_bracket;