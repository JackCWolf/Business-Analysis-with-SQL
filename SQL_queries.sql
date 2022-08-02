SELECT name 
FROM Facilities 
WHERE membercost > 0;

SELECT COUNT(*)
FROM Facilities
WHERE membercost = 0;

SELECT facid, 
       name,
       membercost,
       monthlymaintenance
FROM Facilities
WHERE membercost > 0
      AND membercost < 0.2 * monthlymaintenance;

SELECT *
FROM Facilities
WHERE facid IN (1,5);

SELECT firstname, 
       surname
FROM Members
WHERE joindate = (SELECT MAX(joindate)
                  FROM Members);

SELECT name,
       monthlymaintenance,
       CASE WHEN monthlymaintenance < 100 THEN 'cheap'
            ELSE 'expensive' END AS cost
FROM Facilities;

SELECT surname || ' ' || firstname || ' ' || 
       CASE WHEN facid = 0 THEN 'Tennis Court 1' 
            WHEN facid = 1 THEN 'Tennis Court 2' END AS name_and_court 
FROM Bookings
LEFT JOIN Members
On Bookings.memid = Members.memid
WHERE Bookings.facid IN (0,1)
GROUP BY Members.memid
ORDER BY surname, firstname;

SELECT f.name,
       CASE WHEN m.memid != 0 THEN m.firstname || ' ' || m.surname
            ELSE  m.firstname END AS name,
        CASE WHEN m.memid != 0 THEN slots*membercost 
            ELSE slots*guestcost END AS cost
FROM Bookings AS b
LEFT JOIN Facilities AS f
ON b.facid = f.facid
LEFT JOIN Members AS m
ON b.memid = m.memid
WHERE strftime('%Y%m%d', starttime)='20120914' AND
      cost>30
ORDER BY cost DESC;

SELECT facility_name,
       name,
       cost
FROM (SELECT name AS facility_name,
      CASE WHEN m.memid != 0 THEN surname || ' ' || firstname 
      ELSE "GUEST" END AS name,b.facid,
      b.starttime,
      b.memid,
      CASE WHEN m.memid != 0 THEN slots*membercost 
      ELSE slots*guestcost END AS cost
      FROM Bookings AS b
      INNER JOIN Members AS m
      ON b.memid = m.memid
      INNER JOIN Facilities AS f
      ON b.facid = f.facid) AS b
WHERE strftime('%Y%m%d', starttime)='20120914' AND
      cost>30
ORDER BY cost DESC;

SELECT cost,
       name
FROM (SELECT ROUND(SUM(CASE WHEN b.memid != 0 THEN slots*membercost
                             ELSE slots*guestcost END),2) AS cost,
             name
      FROM Bookings AS b
      LEFT JOIN Facilities AS f
      ON b.facid = f.facid
      GROUP BY f.facid) AS f
WHERE cost < 1000
GROUP BY name
ORDER BY cost DESC;

SELECT m1.surname AS surname,
       m1.firstname AS firstname,
       m2.surname AS recommender_surname,
       m2.firstname AS recommender_firstname
FROM Members AS m1
LEFT JOIN Members AS m2
ON m1.recommendedby = m2.memid
ORDER BY surname, firstname;

SELECT COUNT(CASE WHEN b.memid != 0 AND b.memid IS NOT NULL THEN 1
                  ELSE 0 END),
       f.name
FROM facilities AS f
LEFT JOIN Bookings AS b
ON b.facid = f.facid
GROUP BY b.facid;

SELECT COUNT(CASE WHEN b.memid != 0 AND b.memid IS NOT NULL THEN 1
                  ELSE 0 END),
       strftime('%m', starttime) AS month,
       f.name
FROM facilities AS f
LEFT OUTER JOIN Bookings AS b
ON b.facid = f.facid
GROUP BY month, f.name;
