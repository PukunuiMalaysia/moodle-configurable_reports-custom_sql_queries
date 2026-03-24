SELECT 
 CONCAT('<a href="%%WWWROOT%%/user/profile.php?id=', u.id, '">', u.firstname, ' ', u.lastname, '</a>') AS user_name,
 ROUND(SUM(f.filesize) / (1024 * 1024 * 1024), 2) AS total_private_files_gb
FROM 
 prefix_user u
JOIN 
 prefix_files f ON u.id = f.userid
WHERE 
 f.component = 'user'
GROUP BY 
 u.id, u.firstname, u.lastname
ORDER BY 
 total_private_files_gb DESC
