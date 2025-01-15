-- From the breakdown data from Python, I highlighted a couple of Analysis with SQL
-- (1) Yearly Insights: Averages by Demographic Groups
-- (1.1) Average Wage between Women vs Men
SELECT gender, AVG (value) AS Average_Wage
FROM wage_by_education_US_tidy_data
GROUP BY gender
ORDER BY AVG(value) DESC;
	-- Men generates more wage compare to Women

-- (1.2) Average Wage between race
SELECT race, AVG (value) AS Average_Wage
FROM wage_by_education_US_tidy_data
GROUP BY race
ORDER BY AVG(value);
	-- White people generate more wage compare to Black and Hispanic. Additionally Black and Hispanic has a slightly different wage

-- (1.3) Average Wage between Education Level
SELECT education, AVG (value) AS Average_Wage
FROM wage_by_education_US_tidy_data
GROUP BY education
ORDER BY AVG(value);
	-- As I predicted that people who has less than high school education has the lowest income and the ones who has advanced degree has the highest


-- (2) Highest and Lowest Wage based on Demographics
-- (2.1) Highest Wage
SELECT TOP 1 gender, race, education, AVG(value) AS Average_Wage
FROM wage_by_education_US_tidy_data
GROUP BY education, gender, race
ORDER BY AVG(value) DESC;
	--White Men with Advance Degree has the highest wage 

-- (2.2) Lowest Wage
SELECT TOP 1 gender, race, education, AVG(value) AS Average_Wage
FROM wage_by_education_US_tidy_data
GROUP BY education, gender, race
ORDER BY AVG(value); 
	--Black Women with Less than HS degree  has the lowest wage 


--(3) Yearly Insight: Growth Wage Overtime by Demographics
--(3.1) Yearly Wage Growth Overtime
SELECT 
    a.year,
    a.education,
	a.gender,
	a.race,
	AVG(a.value) AS current_wage,
    AVG(b.value) AS previous_wage,
    (AVG(a.value) - AVG(b.value)) AS wage_growth,
    ((AVG(a.value) - AVG(b.value)) / AVG(b.value)) * 100 AS growth_rate_pct
FROM wage_by_education_US_tidy_data a
LEFT JOIN wage_by_education_US_tidy_data b
ON a.year = b.year + 1
AND a.education = b.education
AND a.race = b.race
AND a.gender = b.gender
GROUP BY a.year, a.education, a.race, a.gender
ORDER BY a.year;

--(3.1) The Peak Year of Men's Wage Growth
SELECT 
    a.year,
    a.gender,
    AVG(a.value) AS current_wage,
    AVG(b.value) AS previous_wage,
    (AVG(a.value) - AVG(b.value)) AS wage_growth,
    ((AVG(a.value) - AVG(b.value)) / AVG(b.value)) * 100 AS growth_rate_pct
FROM wage_by_education_US_tidy_data a
LEFT JOIN wage_by_education_US_tidy_data b
ON a.gender = b.gender 
AND a.year = b.year + 1
WHERE a.gender = 'men'
GROUP BY a.year, a.gender
ORDER BY ((AVG(a.value) - AVG(b.value)) / AVG(b.value)) * 100 DESC;

--(3.2) The Peak Year of Women's Wage Growth
SELECT 
    a.year,
    a.gender,
    AVG(a.value) AS current_wage,
    AVG(b.value) AS previous_wage,
    (AVG(a.value) - AVG(b.value)) AS wage_growth,
    ((AVG(a.value) - AVG(b.value)) / AVG(b.value)) * 100 AS growth_rate_pct
FROM wage_by_education_US_tidy_data a
LEFT JOIN wage_by_education_US_tidy_data b
ON a.gender = b.gender 
AND a.year = b.year + 1
WHERE a.gender = 'women'
GROUP BY a.year, a.gender
ORDER BY ((AVG(a.value) - AVG(b.value)) / AVG(b.value)) * 100 DESC;
	--In 2020, both men's and women's income growth reached their highest levels

--(3.3) The Peak Year of Wage Growth by Race
SELECT 
    a.year,
    a.race,
	AVG(a.value) AS current_wage,
    AVG(b.value) AS previous_wage,
    (AVG(a.value) - AVG(b.value)) AS wage_growth,
    ((AVG(a.value) - AVG(b.value)) / AVG(b.value)) * 100 AS growth_rate_pct
FROM wage_by_education_US_tidy_data a
LEFT JOIN wage_by_education_US_tidy_data b
ON a.year = b.year + 1
AND a.race = b.race
GROUP BY a.year, a.race
ORDER BY ((AVG(a.value) - AVG(b.value)) / AVG(b.value)) * 100 DESC;
  -- In 1976, income growth for Hispanic community reached their highest levels up to 8.4%

-- (4) Wage Gap Over Time by Demographics Overtime
-- (4.1) Gap by Gender
SELECT 
    year,
    ROUND(AVG(CASE WHEN gender = 'men' THEN value END) - AVG(CASE WHEN gender = 'women' THEN value END),2) AS wage_gap,
    ROUND(((AVG(CASE WHEN gender = 'men' THEN value END) - AVG(CASE WHEN gender = 'women' THEN value END)) /
         AVG(CASE WHEN gender = 'women' THEN value END)) * 100, 2) AS wage_gap_percentage
FROM [Wage US].[dbo].[wage_by_education_US_tidy_data]
GROUP BY year
ORDER BY year;
  -- Throughout the years, women have consistently been paid less than men, with the wage gap reaching its highest level in 2022 at $8.06, reflecting a 31.62% disparity in earnings.


-- (4.2) Gap by Race
SELECT 
    year,
    ROUND(
        ((AVG(CASE WHEN race = 'white' THEN value END) - AVG(CASE WHEN race = 'black' THEN value END)) /
         AVG(CASE WHEN race = 'black' THEN value END)) * 100, 
        2
    ) AS white_black_gap_percentage,
    ROUND(
        ((AVG(CASE WHEN race = 'white' THEN value END) - AVG(CASE WHEN race = 'hispanic' THEN value END)) /
         AVG(CASE WHEN race = 'hispanic' THEN value END)) * 100, 
        2
    ) AS white_hispanic_gap_percentage,
    ROUND(
        ((AVG(CASE WHEN race = 'black' THEN value END) - AVG(CASE WHEN race = 'hispanic' THEN value END)) /
         AVG(CASE WHEN race = 'hispanic' THEN value END)) * 100, 
        2
    ) AS black_hispanic_gap_percentage
FROM [Wage US].[dbo].[wage_by_education_US_tidy_data]
GROUP BY year
ORDER BY year;
	--The wage gap analysis reveals persistent disparities between White, Black, and Hispanic workers, with White workers consistently earning more than Black and Hispanic workers




