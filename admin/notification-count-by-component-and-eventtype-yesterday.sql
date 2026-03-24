SELECT
 component AS 'Component',
 eventtype AS 'Event Type',
 COUNT(*) AS 'Total Notifications'
FROM prefix_notifications
WHERE timecreated >= UNIX_TIMESTAMP(CURDATE() - INTERVAL 1 DAY)
AND timecreated < UNIX_TIMESTAMP(CURDATE())
GROUP BY component, eventtype
ORDER BY COUNT(*) DESC
