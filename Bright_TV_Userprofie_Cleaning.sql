-- Databricks notebook source
 SELECT *
 from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
 limit 10;
---------- checking duplicates------
 SELECT COUNT(*),
       UserID
FROM userprofiles.brighttvdatasets.user_profile_dataset
GROUP BY UserID
HAVING COUNT (*) > 1;

----------Chender checks------
SELECT DISTINCT `Gender`
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
;

SELECT DISTINCT
CASE
WHEN Gender IS NULL THEN 'Unknown'
WHEN Gender ='None' THEN 'Unknown'
WHEN Gender = ' ' THEN 'Unknown'
ELSE Gender
END AS Sex
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset` 
 ;

 SELECT *
 from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
 limit 10;

----------------Race checks--------------------
SELECT DISTINCT `Race`
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
;

SELECT DISTINCT
CASE
when Race IS NULL THEN 'Unknown'
WHEN Race ='None' THEN 'Unknown'
WHEN Race = ' ' THEN 'Unknown'
WHEN Race = 'other' THEN 'Unknown'
ELSE Race
 END AS Ethnicity
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset` 
 ;
------ understading our race data------------
SELECT COUNT (DISTINCT UserID) AS Subs,

CASE
when Race IS NULL THEN 'Unknown'
WHEN Race ='None' THEN 'Unknown'
WHEN Race = ' ' THEN 'Unknown'
WHEN Race = 'other' THEN 'Unknown'
ELSE Race
 END AS Ethnicity
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset` 
 GROUP BY Ethnicity
 ;

SELECT *
 from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
 limit 10;
-----------------------Age checks--------------------
SELECT DISTINCT `Age`
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
;

SELECT MIN (Age) AS min_age,
    MAX(Age) AS max_age,
    AVG(Age) AS mean_age
 from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
;

SELECT DISTINCT
CASE
    when Age = 0 THEN 'Infant'
    WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
    WHEN Age BETWEEN 13 AND 17 THEN 'Youth'
    WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult'
    WHEN Age BETWEEN 36 AND 50 THEN 'Adult'
    WHEN Age > 50 AND AGE <=60 THEN 'Elder'
    WHEN Age > 60 THEN 'Pensioner'
    END AS Age_group
 from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
;
SELECT *
 from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
 limit 10;

---------------------Province checks------------------
SELECT DISTINCT `Province`
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
;

SELECT DISTINCT
CASE
when Province = 'NULL' THEN 'Unknown'
WHEN Province ='None' THEN 'Unknown'
WHEN Province= ' ' THEN 'Unknown'
ELSE Province
 END AS Region
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset` 
 ;
--------- Social media handle and email check-------
SELECT DISTINCT `Email`
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
;
SELECT 
     UserID,
     CASE 
     when Email IS NOT NULL
     AND TRIM (Email) != ''
     AND LOWER (TRIM(Email)) NOT IN ('none','other','unknown')
     THEN 1
     ELSE 0
     END AS email_flag,

 CASE
     WHEN `Social Media Handle` IS NOT NULL
     AND `Social Media Handle` != ''
     AND `Social Media Handle` NOT IN ('None')
     THEN 1
     ELSE 0 
     END AS sm_flag
from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
;
 
 SELECT *
 from `userprofiles`.`brighttvdatasets`.`user_profile_dataset`
 limit 5; 

SELECT DISTINCT `Social Media Handle`
FROM userprofiles.brighttvdatasets.user_profile_dataset;

-------checking size of the data--------
SELECT COUNT(*) AS number_of_rows,
COUNT(DISTINCT UserID) AS number_subs
From userprofiles.brighttvdatasets.user_profile_dataset;

----------Checking where UserID is NULL------

SELECT COUNT (*) AS cnt
FROM userprofiles.brighttvdatasets.user_profile_dataset
WHERE UserID IS NULL;

SELECT DISTINCT UserID
FROM userprofiles.brighttvdatasets.user_profile_dataset;

---------------Creating a clean table--------------

CREATE OR REPLACE TABLE userprofiles.brighttvdatasets.cleaned_user_profile
TBLPROPERTIES ('delta.columnMapping.mode' = 'name')
AS
SELECT
    UserID,
    Name,
    Surname,

    CASE
        WHEN Gender IN ('NULL','None','') THEN 'Unknown'
        ELSE Gender
    END AS Sex,

    CASE
        WHEN Race IN ('NULL','None','','other') THEN 'Unknown'
        ELSE Race
    END AS Ethnicity,

    CASE
        WHEN Province IN ('NULL','None','') THEN 'Unknown'
        ELSE Province
    END AS Region,
Age,
    CASE
        WHEN Age = 0 THEN 'Infant'
        WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
        WHEN Age BETWEEN 13 AND 17 THEN 'Youth'
        WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult'
        WHEN Age BETWEEN 36 AND 50 THEN 'Adult'
        WHEN Age BETWEEN 51 AND 60 THEN 'Elder'
        ELSE 'Pensioner'
    END AS Age_Group,

    CASE
        WHEN Email IS NOT NULL
         AND TRIM(Email) != ''
         AND LOWER(TRIM(Email)) NOT IN ('none','unknown','other')
        THEN 1
        ELSE 0
    END AS Email_Flag,

    CASE
        WHEN `Social Media Handle` IS NOT NULL
         AND TRIM(`Social Media Handle`) != ''
         AND LOWER(TRIM(`Social Media Handle`)) NOT IN ('none','unknown')
        THEN 1
        ELSE 0
    END AS SM_Flag

FROM userprofiles.brighttvdatasets.user_profile_dataset;
--------showing our newly created table---------------
SELECT *
FROM userprofiles.brighttvdatasets.cleaned_user_profile;
