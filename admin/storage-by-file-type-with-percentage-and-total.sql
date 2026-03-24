WITH FileStorage AS (
 SELECT
 CASE
 WHEN f.component = 'assignsubmission_file' AND f.filearea = 'submission_files' THEN 'Assignment Submissions'
 WHEN f.component = 'assignfeedback_file' AND f.filearea = 'feedback_files' THEN 'Assignment Feedback Files'
 WHEN f.component = 'assignfeedback_editpdf' THEN 'Assignment PDF Conversions'
 ELSE CONCAT(f.component, ':', f.filearea)
 END AS File_Type,
 COUNT(*) AS File_Count,
 SUM(f.filesize) AS Total_Bytes
 FROM
 prefix_files f
 WHERE
 f.filesize > 0
 GROUP BY
 File_Type
),
TotalStorage AS (
 SELECT SUM(Total_Bytes) AS Overall_Bytes FROM FileStorage
),
DetailedReport AS (
 SELECT
 fs.File_Type,
 fs.File_Count,
 ROUND(fs.Total_Bytes / (1024 * 1024 * 1024), 2) AS Total_Storage_GB,
 ROUND((fs.Total_Bytes / ts.Overall_Bytes) * 100, 2) AS Percentage,
 0 AS Sort_Order
 FROM
 FileStorage fs,
 TotalStorage ts
),
TotalReport AS (
 SELECT
 'Total' AS File_Type,
 SUM(fs.File_Count) AS File_Count,
 ROUND(SUM(fs.Total_Bytes) / (1024 * 1024 * 1024), 2) AS Total_Storage_GB,
 100.00 AS Percentage,
 1 AS Sort_Order
 FROM
 FileStorage fs
)
SELECT
 File_Type,
 File_Count,
 Total_Storage_GB,
 Percentage
FROM (
 SELECT * FROM DetailedReport
 UNION ALL
 SELECT * FROM TotalReport
) AS Combined
ORDER BY
 Sort_Order, Total_Storage_GB DESC
