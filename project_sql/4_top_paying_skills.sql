/* What are the top skills based on salary?
- Look at the average salary associated with each skill for Data analyst position
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data analysts 
and helps identify the most financially rewarding skills to acquire or improve

- THOUGHT PROCESS TO FOLLOW: Similar to the last query, we need the skills name,
and additionally the salary, so we need both skills_dim and job_postings_fact tables

- Then perform agggregation of these salaries with the AVG function*/

SELECT 
    skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0 )AS average_salary
FROM job_postings_fact
INNER JOIN skillS_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY skills
ORDER BY average_salary DESC
LIMIT  25;


/* 


Here are some quick insights into the top-paying skills for data analysts based on the provided list:

Trends in Top-Paying Skills:
Big Data and Cloud Computing:

PySpark (Average Salary: $208,172) and Databricks (Average Salary: $141,907) indicate a high demand for big data processing and analytics skills.
GCP (Google Cloud Platform, Average Salary: $122,500) shows the importance of cloud computing expertise.
Data Management and Storage:

Couchbase (Average Salary: $160,515) and Elasticsearch (Average Salary: $145,000) highlight the need for expertise in database management and search engine technologies.
Version Control and Collaboration Tools:

Bitbucket (Average Salary: $189,155), GitLab (Average Salary: $154,500), and Jenkins (Average Salary: $125,436) reflect the importance of version control and CI/CD (Continuous Integration/Continuous Deployment) tools in data projects.
Programming and Scripting Languages:

Swift (Average Salary: $153,750), Golang (Average Salary: $145,000), Scala (Average Salary: $124,903), and Python libraries like Pandas ($151,821) and Numpy ($143,513) show that proficiency in various programming languages is highly valued.
Machine Learning and AI:

Watson (Average Salary: $160,515), DataRobot (Average Salary: $155,486), and scikit-learn (Average Salary: $125,781) emphasize the increasing significance of machine learning and AI skills.
Data Visualization and Notebook Tools:

Jupyter (Average Salary: $152,777) and Notion (Average Salary: $125,000) suggest a demand for skills in data visualization and collaborative documentation.
DevOps and Automation:

Kubernetes (Average Salary: $132,500) and Airflow (Average Salary: $126,103) highlight the importance of container orchestration and workflow automation.
Business Intelligence:

MicroStrategy (Average Salary: $121,619) shows the value placed on BI tools for data analysis and reporting.*/

