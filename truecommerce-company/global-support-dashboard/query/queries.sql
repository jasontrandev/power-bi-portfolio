/* © 2024 Jason Tran. All rights reserved. 
@https://github.com/jasontrandev/
TC-Global-Support-Dashboard
*/
SELECT * FROM dbo.all_cases_closed;

/*------------KPI's------------*/
--1) 

--2) Get Latest Cases Closed
WITH ranked_case_closed AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY InternalID ORDER BY DateClosed DESC) AS row_num
    FROM dbo.all_cases_closed
)
SELECT *
FROM ranked_case_closed
WHERE row_num = 1;

--3) Merge support team latest with case_in
WITH ranked_support_team AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY InternalID ORDER BY [Date] DESC) AS row_num
    FROM dbo.log_case_support_team
),
get_latest_support_team AS (
    SELECT
        [InternalID],
        [Number],
        [NewValue] AS HJSupportTeam
    FROM ranked_support_team
    WHERE row_num = 1
)
SELECT
    C.[InternalID],
    C.[Number],
    L.[HJSupportTeam],
    C.[DateCreated],
    C.[Priority],
    C.[Origin],
    C.[CompanyID],
    C.[ProfileID],
    C.[Product],
    C.[CategoryType],
    C.[Type]
FROM dbo.all_cases_open C
LEFT JOIN get_latest_support_team L ON C.InternalID = L.InternalID