--
--

-- arrays
SELECT ('python','sql','r') AS skills_array;


WITH skills AS (
    SELECT 'Python' AS skill
    UNION ALL 
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
FROM skills
)
SELECT 
    skills(1) AS first_skill,
    skills(2) AS second_skill,
    skills(3) AS third_skill
FROM skills_array;
--



--Struct
SELECT{skill: 'python', type: 'programming'} AS skill_struct;

WITH skill_struct AS(
    SELECT
        STRUCT_PACK(
            skill := 'python',
            type:= 'programming'
    ) AS s
)
SELECT 
    s.skill,
    s.type
FROM skill_struct;


WITH skill_table AS (
    SELECT 'Python' AS skills, 'programming' AS types
    UNION ALL 
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r','programming';
)
SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;


--array of structs

SELECT[
    {skill:'Python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
 ] AS skills_aray_of_structs;


WITH skill_table AS (
    SELECT 'Python' AS skills, 'programming' AS types
    UNION ALL 
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r','programming';
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        )
    )
FROM skill_table;

--creating maps
WITH skill_map AS(
SELECT MAP{'skill' : 'python','type': 'programming'} as skill_type
)
SELECT
    skill_type['skill']
FROM
     skill_map;

--parse json

WITH raw_skill_json AS(
SELECT
    '{"skill":"python","type":"programming"}'::JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;












