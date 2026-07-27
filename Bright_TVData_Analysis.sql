-- Databricks notebook source
SELECT
    u.UserID,
    u.Name,
    u.Surname,
    u.Gender,
    u.Race,
    u.Province,
    u.Age_Group,
    u.Email,
    u.`Social Media Handle`,
    v.Channel2,
    v.RecordDate_SA,
    v.Duration2
FROM userprofiles.brighttvdatasets.cleaned_user_profile u
INNER JOIN userprofiles.brighttvdatasets.cleaned_viewership v
ON u.UserID = v.UserID;

-- COMMAND ----------


