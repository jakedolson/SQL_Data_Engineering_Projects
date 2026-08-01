SELECT job_posted_date,
    job_posted_date:: DATE as date,
    job_posted_date:: TIME as time,
    job_posted_date:: TIMESTAMP as timestamp,
    job_posted_date:: TIMESTAMPZ AS timestampz,
FROM job_posting_fact
LIMIT 10;


SELECT
    DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE 
    job_title_short =  'Data Engineer' AND
    EXTRACT(YEAR FROM job_posted_date) = 2024
GROUP BY
    DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;



SELECT  
EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS job_posted_hour,
COUNT(job_id)
FROM 
    job_postings_fact
WHERE   job_location LIKE 'New York, NY'
GROUP BY
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')
ORDER BY job_posted_hour;



--test
SELECT
    job_posted_date,
    DATE_TRUNC('month',job_posted_date)
FROMLIMIT 10;