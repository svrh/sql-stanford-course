-- Q1 - It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM highschooler
WHERE grade = 12

-- Q2 - If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM likes
WHERE likes.id1 IN 
(SELECT f.id2 FROM friend f WHERE f.id1 = likes.id2) AND likes.id2 IN 
(SELECT l1.id2 FROM likes l1 WHERE l1.id1 = likes.id1) AND likes.id1 NOT IN
(SELECT l2.id2 FROM likes l2 WHERE l2.id1 = likes.id2)

-- Q3 - For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)
INSERT INTO friend(id1, id2)
SELECT DISTINCT a.id1, c.id2
FROM friend a, friend c
WHERE a.id2 = c.id1 AND a.id1 != c.id2 AND c.id2 NOT IN (SELECT id2 FROM friend f WHERE f.id1 = a.id1)
