-- count rows aggregation only

SELECT 
    COUNT(*) 
FROM 
    job_postings_fact;



-- count rows -- window function

SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
            PARTITION BY job_title_short, company_id
    ) --entire data set preforming agg on avg column
FROM
    job_postings_fact
WHERE  
    salary_hour_avg IS NOT NULL
ORDER BY random()
LIMIT 10;

--order by -- ranking window function
--rank hour salary column
--
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        ORDER BY salary_hour_avg DESC
    ) AS rank_hour_avg


FROM
    job_postings_fact
WHERE  
    salary_hour_avg IS NOT NULL
ORDER BY salary_hour_avg DESC
LIMIT 10;

--partition and order by
-- running avg of hourly salary

SELECT
    job_posted_date,
    job_title_short,
    ROUND(salary_hour_avg,2) AS salary_hour_avg,
    ROUND(AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ),2) AS running_avg_hourly_by_title
FROM
    job_postings_fact
WHERE  
    salary_hour_avg IS NOT NULL
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10;



--
--partition by and order by -- ranking by job_title-short

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC   
    ) AS rank_hour_avg
FROM
    job_postings_fact
WHERE  
    salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;


--
--aggregate functions
--

SELECT
    job_posted_date,
    job_title_short,
    ROUND(salary_hour_avg,2) AS salary_hour_avg,
    ROUND(MAX(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ),2) AS running_avg_hourly_by_title
FROM
    job_postings_fact
WHERE  
    salary_hour_avg IS NOT NULL
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10;


--
--ranking function RANK() vs dense_rank

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_RANK() OVER(
        ORDER BY salary_hour_avg DESC
    ) AS rank_hour_avg


FROM
    job_postings_fact
WHERE  
    salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC
LIMIT 140;




--row number() - providing a new job-id
SELECT *,
ROW_NUMBER() OVER(
        ORDER BY job_posted_date
    )
FROM 
    job_postings_fact
ORDER BY    
    job_posted_date
LIMIT 20;



--
--navigation functions
--lag and lead

SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary,
    salary_year_avg -LAG(salary_year_avg) OVER(
    PARTITION BY company_id
    ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;




