/*
Question: What are the most in-demand skills for data engineers?

- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings

- Why? Retrieves the top 10 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for data engineers seeking remote work

     hr5min35  tutorial

*/

SELECT 
sd.skills,
COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim as sjd 
    ON jpf.job_id = sjd.job_id 
INNER JOIN skills_dim as sd 
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
limit 10;

/*
Skills break down for data engineers:
sql and python are by far the most in-demand skills. Nearly 30,000 postings contain sql and python.
cloud platforms round out our top 5 with AWS at 18,000 Azure with 14,000 and apache spark with 13000.
this highlights the importance of big data engineering and processing skills.

-takeaways
--SQl and Python are foundational skills for data engineering
--cloud platforms are critial for modern data engineering
--big data tools like spark are highly valued
--followed by data pipeline tools (Airflow, Snowflake, Databricks) have demand and are growing
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
*/



