-- Q1 - Find the names of all students who are friends with someone named Gabriel.
SELECT name FROM 
(SELECT friend.id1
FROM friend JOIN highschooler
ON friend.id2 = highschooler.id
WHERE name = "Gabriel") AS Q JOIN highschooler
on Q.id1 = highschooler.id

-- Q2 - For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
SELECT r1.name, r1.grade, r2.name, r2.grade
FROM (highschooler
JOIN likes
ON highschooler.id = likes.id1) AS r1
JOIN highschooler AS r2
ON r1.id2 = r2.id
WHERE r1.grade >= r2.grade + 2

-- Q3 - For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.
SELECT h.name, h.grade , hi.name, hi.grade FROM highschooler h JOIN (
SELECT l1.id1, l1.id2 FROM likes AS l1 JOIN likes AS l2
ON l1.id2 = l2.id1
WHERE l1.id1 = l2.id2) AS m
ON h.id = m.id1
JOIN highschooler hi
ON m.id2 = hi.id
WHERE h.name < hi.name

-- Q4 - Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
SELECT h.name, h.grade
FROM highschooler h
LEFT JOIN likes l1
ON h.id = l1.id1
LEFT JOIN likes l2
ON h.id = l2.id2
WHERE l1.id2 IS NULL AND l2.id1 IS NULL

-- Q5 -  For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
SELECT h.name, h.grade, r.name, r.grade FROM highschooler h JOIN likes l
ON h.id = l.id1 JOIN
(SELECT * FROM highschooler h1 LEFT JOIN likes l1
ON h1.id = l1.id1
WHERE l1.id1 is null) AS r
on l.id2 = r.id

-- Q6 - Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
SELECT DISTINCT h1.name, h1.grade from highschooler h1, friend f, highschooler h2
WHERE h1.id = f.id1 AND h2.id = f.id2 AND h1.id NOT IN
(SELECT DISTINCT h1.id FROM highschooler h1, friend f, highschooler h2
WHERE h1.id = f.id1 AND h2.id = f.id2 AND h1.grade != h2.grade)
ORDER BY h1.grade, h1.name

-- Q7 - For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
SELECT DISTINCT a.name, a.grade, b.name, b.grade, c.name, c.grade
FROM highschooler a, highschooler b, highschooler c, likes l, friend f
WHERE a.id = l.id1 AND b.id = l.id2 AND a.id NOT IN (
SELECT friend.id1 FROM friend WHERE b.id = friend.id2) AND c.id IN (
SELECT friend.id1 FROM friend WHERE a.id = friend.id2) AND c.id in (
SELECT friend.id1 FROM friend WHERE b.id = friend.id2)

-- Q8 - Find the difference between the number of students in the school and the number of different first names.
SELECT count(id) - count(distinct name) FROM highschooler

-- Q9 - Find the name and grade of all students who are liked by more than one other student.
SELECT h.name, h.grade FROM highschooler h
WHERE (SELECT COUNT(likes.id1) FROM likes WHERE likes.id2 = h.id) > 1
