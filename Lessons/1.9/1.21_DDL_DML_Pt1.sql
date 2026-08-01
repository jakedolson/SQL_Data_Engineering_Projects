USE data_jobs;

--DROP DATABASE IF EXISTS jobs_mart;
--DROP SCHEMA staging;


CREATE DATABASE IF NOT EXISTS jobs_mart;
SHOW DATABASES;


USE jobs_mart; --database specifier
CREATE SCHEMA IF NOT EXISTS staging;

SELECT *
FROM information_schema.schemata;


DROP TABLE staging.priority_roles;

CREATE TABLE IF NOT EXISTS staging.priority_roles(
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

/*
insert update merge
*/
INSERT INTO staging.priority_roles (role_id, role_name)
VALUES
(1, 'Data Engineer'),
(2, 'Senior Data Engineer'),
(3, 'Software Engineer');

SELECT * 
FROM staging.priority_roles;

ALTER TABLE staging.priority_roles
ADD COLUMN priority_role BOOLEAN;

UPDATE staging.priority_roles
SET priority_role = TRUE
WHERE role_id = 1 OR role_id = 2;

UPDATE staging.priority_roles
SET priority_role = FALSE
WHERE role_id = 3;

ALTER TABLE staging.priority_roles
RENAME COLUMN priority_role TO priority_lvl;

ALTER TABLE staging.priority_lvl
ALTER COLUMN priority_lvl TYPE INTEGER;



