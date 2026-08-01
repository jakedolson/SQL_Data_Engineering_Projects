--subquery
SELECT *
FROM(
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)
LIMIT 10;

--CTE
--define temp result set at the beginning of the query. using the WITH key word

WITH valid_salaries AS (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries;


-- #1 show each job salary next to the overall market median:
SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    )   AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL LIMIT 10;

-- #2 subquery in FROM
-- stage only jobs that are remote before aggregating to determine remote median salary per job:

SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    )   AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM    
        job_postings_fact
        WHERE job_work_from_home = TRUE 
) AS clean_jobs
GROUP BY job_title_short
LIMIT 10;


-- #3 subquery in HAVING
--keep only job titles whose median salary is above the overall media:

SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    )   AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM    
        job_postings_fact
        WHERE job_work_from_home = TRUE 
) AS clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
)
LIMIT 10;


--CTE
-- a temporary retult set that you can reference within:
-- FROM,JOIN,other CTEs, and main statement (SELECT/INSERT/UPDATE/DELETE)
--WITH keyword used to define CTE at beginning of query

--CTE example
--compare how much more (or less) remote roles pay compared to onsite roles for each job title.
--use a CTE to calculate the emdian salary by title and work arrangement, then compare those medians.

WITH title_median AS (
    SELECT 
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY 
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o ON
    r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
  AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;


--sub query
--source and target table
-- where exists (keep rows with a match in source = target)
-- where not exists (opposite)

SELECT *
FROM range(3) AS src(key);

SELECT *
FROM range(2) AS tgt(key);

--where exists
SELECT *
FROM range(3) AS src(key)
WHERE EXISTS(
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);

--where not exists
SELECT *
FROM range(3) AS src(key)
WHERE NOT EXISTS(
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);

--final example
--itentify job postings that have no associated skills before loading them into a data mart

SELECT * 
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;


SELECT *
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;




SELECT * 
FROM job_postings_fact AS tgt
WHERE NOT EXISTS(
    SELECT 1
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;
