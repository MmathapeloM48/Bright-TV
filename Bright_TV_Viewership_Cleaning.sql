-- Databricks notebook source
SELECT*
FROM userprofiles.brighttvdatasets.viewership_dataset
LIMIT 5;

--------Channel checks-----

SELECT DISTINCT `Channel2`
FROM userprofiles.brighttvdatasets.viewership_dataset;

----------Record date2 checks-------

SELECT DISTINCT `RecordDate2`
FROM userprofiles.brighttvdatasets.viewership_dataset;

SELECT
    UserID0,
    RecordDate2,
    from_utc_timestamp(RecordDate2, 'Africa/Johannesburg') AS RecordDate_SA
FROM userprofiles.brighttvdatasets.viewership_dataset;

-----------------Duplicate checks--------------------
SELECT
    UserID0,
    RecordDate2,
    COUNT(*) AS duplicate_count
FROM userprofiles.brighttvdatasets.viewership_dataset
GROUP BY UserID0, RecordDate2
HAVING COUNT(*) > 1;

-------------------Duration checks-----------------

SELECT DISTINCT `Duration 2`
FROM userprofiles.brighttvdatasets.viewership_dataset;

SELECT
    MIN(`Duration 2`) AS min_duration,
    MAX(`Duration 2`) AS max_duration,
    AVG(`Duration 2`) AS avg_duration
FROM userprofiles.brighttvdatasets.viewership_dataset;

-------------Missing duration checks----------------

SELECT COUNT(*) AS missing_duration
FROM userprofiles.brighttvdatasets.viewership_dataset
WHERE `Duration 2`IS NULL;

---------------------------Duration category--------------

SELECT 
    UserID0,
    `Duration 2`,
    CASE
        WHEN (HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) < 30 THEN 'Short'
        WHEN (HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) BETWEEN 30 AND 60 THEN 'Medium'
        WHEN (HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) > 60 THEN 'Long'
        ELSE 'Unknown'
    END AS Duration_Category
FROM userprofiles.brighttvdatasets.viewership_dataset;

-------------------------Missinf UserID checks------------------

SELECT COUNT(*) AS missing_userid
FROM userprofiles.brighttvdatasets.viewership_dataset
WHERE UserID0 IS NULL;

-------------------------dataset size checks----------------------

SELECT
    COUNT(*) AS number_of_rows,
    COUNT(DISTINCT UserID0) AS unique_users
FROM userprofiles.brighttvdatasets.viewership_dataset;


--------------------------Creating a clean table---------------

CREATE OR REPLACE TABLE userprofiles.brighttvdatasets.cleaned_viewership AS
SELECT
    UserID0 AS UserID,
    Channel2,
    from_utc_timestamp(RecordDate2, 'Africa/Johannesburg') AS RecordDate_SA,
    `Duration 2` AS Duration2
FROM userprofiles.brighttvdatasets.viewership_dataset;

SELECT *
FROM userprofiles.brighttvdatasets.cleaned_viewership
LIMIT 10;
