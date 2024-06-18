SELECT * 
FROM january_jobs;

SELECT * 
FROM february_jobs;

SELECT * 
FROM march_jobs;

/* union eg : Both tables should have same amount of columns and 
datatype must match. Gets rid of all duplicate rowa

format 

SELECT column_name
from table_one

union  --combine the two tables

SELECT column_name
from table_two*/

-- get jobs and companies from january
SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

-- get jobs from february
SELECT 
    job_title_short,
    company_id,
    job_location
FROM february_jobs

UNION ALL
-- get jobs from march
SELECT 
    job_title_short,
    company_id,
    job_location
FROM march_jobs

/* UNION ALL : Same as union but does not remove duplicate rows. 
Returns all rows including duplicates*/

/* pratice question 1*/

/* QUESTION: Get the corresponding skill and skill type for each job posting in Q1
 Include those without any skills too

 Look at the skills and the type for each job in the first quarter that 
 has salary > 70000*/

 /* Practice problem 8:

Find job postings from the first quarter that have 
a salary greater than 70K. 
- Combine job posting tables from the first quarter of 2023(Jan-Mar)
- Gets job postings with an avg yearly salary > 70000*/

SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::date,
    salary_year_avg
FROM( -- making the union function into a subquery

SELECT * 
FROM january_jobs

UNION ALL

SELECT * 
FROM february_jobs 

UNION ALL

SELECT * 
FROM march_jobs
 ) AS quarter1
WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY quarter1.salary_year_avg DESC
