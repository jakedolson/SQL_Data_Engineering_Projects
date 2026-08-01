--array - final example
--build a flat skill table for co-workers to access job titles, salary info, and skills in one table


CREATE OR REPLACE TEMP TABLE job_skills_aray AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;
    



--from the persepective of a data analyst, analyze the median salary per skill
WITH flat_skills AS(
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type AS skill_type,
        UNNEST(skills_type).skill_name AS skill_name
    FROM
        job_skills_array_struct
)
SELECT 
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_type;


--Array of structs - final example
-- Build a flat skill & type table for co-workers to access job titles, salary info, skills and type in one table
--

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;


--from the persepective of a data anaylst, analyse the median salary per type of skill

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type).skill_type AS skill_type,
    UNNEST(skills_type).skill_name AS skill_name
FROM
    job_skills_array_struct;
















