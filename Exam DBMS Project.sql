
/* Q1: Which are the hardest questions based on levels of questions? */

SELECT *
FROM exampaperdetail
ORDER BY question_level DESC


/* Q2: Which exam centres have the most number of seats? */

SELECT COUNT(seat_id) AS c, examcentre_id 
FROM examcentrealloted
GROUP BY examcentre_id
ORDER BY c DESC


/* Q3: What are top 5 values of number of invigilators? */

SELECT invigilatorno 
FROM examcentredetail
ORDER BY invigilatorno DESC
LIMIT 5


/* Q4: Which state has the most number of invigilaotrs appointed?  
Write a query that returns one state that has the highest sum of invigilator number. 
Return both the centre address & tatal number of invigilators */

SELECT SUM(invigilatorno ) AS Total_invigilators, centre_address
FROM examcentredetail
GROUP BY centre_address
ORDER BY Total_invigilators DESC



/* Q5:  Write a query that returns the address of the exam centre which has the highest number of seats.*/

SELECT examcentredetail.examcentre_id, examcentredetail.centreaddress, COUNT(examcentrealloted.seat_id) AS total_seats
FROM examcentredetail
JOIN examcentrealloted ON examcentrealloted.examcentre_id = examcentredetail.examcentre_id
GROUP BY examcentredetail.examcentre_id
ORDER BY total_seats DESC
LIMIT 1;





/* Q6: Write query to return the examcentre id, , centre address, & caste of all hindu general category students. 
Return your list ordered alphabetically by centre address starting with A. */


SELECT DISTINCT examcentredetail.examcentre_id , examcentredetail.centre_address
FROM examcentredetail
JOIN examcentrealloted ON examcentredetail.examcentre_id = examcentrealloted.examcentre_id
JOIN studentcontact ON examcentrealloted.seat_id = studentcontact.seat_id
WHERE adhaar_id IN(
	SELECT adhaar_id FROM adhaarinfo
	JOIN caste ON adhaarinfo.caste_id = caste.caste_id
	WHERE caste.name LIKE 'hindu general'
)
ORDER BY centre_address;




/* Q7:which city has most number of students with caste as jain
Write a query that returns the top 10 city names and total count of the jain students. */

SELECT studentaddress.address_id, studentaddress.name,COUNT(studentaddress.address_id) AS number_of_students
FROM adhaarinfo
JOIN students ON students.student_id = adhaarinfo.student_id
JOIN studentaddress ON studentaddress.address_id = students.address_id
JOIN caste ON caste.caste_id = adhaarinfo.caste_id
WHERE caste.name LIKE 'jain'
GROUP BY studentaddress.address_id
ORDER BY number_of_students DESC
LIMIT 10;


/* Q8: Return adhaar id and adhaar number of students which have age greater than the average age. 
Order by the age of the students with the elder students first. */

SELECT adhaar_id, adhaar_no
FROM adhaarinfo
WHERE age > (
	SELECT AVG(age) AS avg_age
	FROM adhaarinfo )
ORDER BY age DESC;





/* Q9: Find out exam centres which have most number of students which lives in the city which
have students with most number of attempst*/



WITH most_attempts_city AS (
	SELECT studentaddress.address_id AS address_id, studentaddress.name AS city_name, SUM(studentcontact.noofattempts) AS most_attempts
	FROM studentcontact
	JOIN adhaarinfo ON adhaarinfo.adhaar_id=studentcontact.adhaar_id
	JOIN students ON students.student_id=adhaarinfo.student_id
	JOIN studentaddress ON studentaddress.address_id=students.address_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT e.examcentre_id, e.centre_address,mac.city_name, SUM(noofattempts) 
FROM examcentrealloted
JOIN examcentredetail e  ON e.examcentre_id=examcentrealloted.examcentre_id
JOIN studentcontact sc ON sc.seat_id=examcentrealloted.seat_id
JOIN adhaarinfo ai ON ai.adhaar_id=sc.adhaar_id
JOIN students s ON s.student_id=ai.student_id
JOIN most_attempts_city mac on mac.address_id=s.address_id
GROUP BY 1,2,3
ORDER BY 4 DESC;




/* Thank You :) */