-- :: is used for casting, meaning converting
-- value from one datatype to another

-- example
SELECT
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'TRUE'::BOOLEAN,
    '3.14'::REAL;



SELECT 
job_title_short AS title,
job_location AS location,
job_posted_date::DATE AS date --On casting the column as DATE, timestamps are removed
FROM job_postings_fact;

-- AT TIME ZONE: to convert timestamps in different timezones
-- can be used on timestamps iwth or without timezone information

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date_time
FROM job_postings_fact
LIMIT 5;

/* for data that comes with timezones, they
are stored as per UTC in each query
AT TIME ZONE converts UTC to the specified timezone correctly */

/* query for the sql_course dataset that has no 
timezone specified
Here we specify the timezone for the dataset, then convert
to the desired timezone*/

SELECT
    job_title_short AS job_title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time
FROM job_postings_fact
LIMIT 5;

/* function:  EXTRACT
used to extract specific details from the date
gets field(eg year, month, day) from date/time value*/

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM job_postings_fact
LIMIT 5;

/* query question: how job postings vary from month to month*/

SELECT 
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY job_posted_count DESC ;

-- practice problem 1

SELECT 
    job_schedule_type,
    AVG(salary_year_avg ) AS yearly_avg,
    AVG(salary_hour_avg ) AS hourly_avg 
FROM job_postings_fact
WHERE job_posted_date::DATE  >='2023-06-01'
GROUP BY job_schedule_type;

-- practice problem 2
SELECT
    COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'EST') AS month_year
FROM job_postings_fact
WHERE job_posted_date > '2022-12-31'
GROUP BY month_year
ORDER BY month_year ASC ;

-- practice problem 3
SELECT 
    DISTINCT(company_dim.name),
    job_postings_fact.job_health_insurance,
    COUNT(job_postings_fact.job_id),
    EXTRACT(MONTH FROM job_posted_date ) BETWEEN 5 AND 8   AS may_to_aug_post
FROM job_postings_fact
LEFT JOIN company_dim
ON company_dim.company_id = job_postings_fact.company_id
GROUP BY may_to_aug_post, company_dim.name
HAVING job_postings_fact.job_health_insurance = TRUE;

