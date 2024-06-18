/* We want to make separate tables for each month's data */
SELECT * FROM job_postings_fact LIMIT 10;

/* STEP 1: create filter to separate data having only january in job_posted_date*/
CREATE TABLE january_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1;

-- Create table for February jobs
CREATE TABLE february_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- Create table for March jobs
CREATE TABLE march_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

/* STEP 2: create table for this separate january data*/

/* step 3 : check for correctness*/

/* CASE: Case expression is used to apply conditional logic within sql queries.*/

-- reclassify where the job is located at


/* Want to create a new column for specifying locations as follows
if ''Anywhere' label as 'remote'
if 'New York,NY' label as 'Local'
Otherwise "onsite"*/

SELECT
    COUNT(job_id) AS number_of_jobs,
        CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;

-- practice problem for CASE EXPRESSION

SELECT
    COUNT(job_id) AS num_of_jobs,
    CASE
    WHEN salary_year_avg >= 50000 THEN 'High'
    WHEN salary_year_avg< 50000 AND salary_year_avg>40000 THEN 'Average'
    ELSE 'Low'
END AS salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY salary_category
ORDER BY salary_category DESC;

/* Subqueries: Query nested inside a larger query
SUbqueries are usually used for simpler queries*/

-- Subqueries can be used in SELECT, FROM AND WHERE clauses

SELECT * 
FROM ( -- subquery starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)= 1
    )AS january_jobs;
-- subquery ends here

/* Common table expressions: Define a temporary result set
that you can reference

Can refernece within a SELECT, INSERT, UPDATE OR DELETE statement

Defined with WITH */

WITH january_jobs AS ( -- CTE definition starts here
    SELECT* 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) 
    = 1) -- CTE definition ends here

SELECT * FROM january_jobs;

--------------HARDER PRACTICE PROBLEM-----------------

-----NOTES-------
/* Subqueries Can be used in several places in main query
such as SELECT, FROM, WHERE, OR HAVING clauses

-- It is executed first and the results are passed to the outer query

eg, It is used when you want to perform a calculation before 
the main query can complete its calculation*/

/* eg; find a list of companies that offer jobs without the requirement of 
-- a degree*/

SELECT name AS company_name,
    company_id
FROM company_dim
WHERE company_id IN( --start of subquery
SELECT
    company_id
FROM job_postings_fact
WHERE job_no_degree_mention = true
ORDER BY company_id
)

/* CTEs example:*/

/* eg: finding the companies that have the most job openings.

- get the total number of job postings per company id(job_postings_fact)
- return the total number of jobs with the company name(company_dim)*/

WITH company_job_count AS(
SELECT 
    company_id,
    COUNT(*) AS total_jobs
FROM 
    job_postings_fact
GROUP BY company_id)

SELECT company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC

------PRACTICE PROBLEM 1

-- RIGHT ANSWER--
SELECT 
    skills_dim.skills,
    cs.counting_skills AS highest_count
FROM (SELECT skill_id,
            COUNT(skill_id) AS counting_skills
            FROM skills_job_dim 
            GROUP BY skill_id
            ORDER BY counting_skills DESC
            LIMIT 20) cs
LEFT JOIN skills_dim 
ON cs.skill_id = skills_dim.skill_id
ORDER BY highest_count DESC;

------ PRACTICE PROBLEM 2-----

SELECT 
    company_dim.name,
    COUNT(num_of_postings) 
    CASE
        WHEN num_of_postings < 10 THEN 'Small'
        WHEN num_of_postings BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_sizes
    GROUP BY company_dim.name
FROM (SELECT 
    company_dim.name,
    cid.num_of_jobs AS num_of_postings
    FROM (SELECT
    company_id,
    COUNT(job_id) AS num_of_jobs
    FROM job_postings_fact 
    GROUP BY company_id
    ORDER BY num_of_jobs DESC
    LIMIT 10) cid
LEFT JOIN company_dim
ON cid.company_id = company_dim.company_id);


SELECT * FROM company_dim LIMIT 10;

-- Practice problem 7:  CTEs example 

/* Find the count of the number of remote job postings per skill 
 - display the top 5 skills by their demandin remote jobs
 - include skill ID, name and count of postings requiring the skill*/


WITH remote_job_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skills_to_job 
    INNER JOIN job_postings_fact AS job_postings
        ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = True AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY skill_id)

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
 FROM remote_job_skills 
INNER JOIN skills_dim  AS skills 
ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;