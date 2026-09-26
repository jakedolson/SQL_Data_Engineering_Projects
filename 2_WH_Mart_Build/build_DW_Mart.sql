-- to run script paste in terminal  
-- duckdb dw_marts.duckdb -c ".read build_DW_Mart.sql"

--Step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW - load data from CSV files into tables
.read 02_load_schema_dw.sql

-- Step 3: DW - create flat mart
.read 03_create_flat_mart.sql

-- Step 4: DW - create skills demand mart
.read 04_create_skills_mart.sql