--Deliverable 1:
-- Part 1------------------------------------
SELECT emp.emp_no,
	emp.first_name,
	emp.last_name,
	tit.title,
	tit.from_date,
	tit.to_date
INTO Deliverable_one
FROM employees as emp
INNER JOIN titles as tit
ON (emp.emp_no = tit.emp_no)
WHERE (emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp.emp_no;

-- ------------------------------
DROP TABLE Deliverable_one;
SELECT * FROM Deliverable_one;
-- ------------------------------


-- Part 2-----------------------------------
SELECT DISTINCT ON (ret.emp_no) ret.emp_no,
ret.first_name,
ret.last_name,
ret.title

INTO unique_titles
FROM deliverable_one as ret
ORDER BY ret.emp_no ASC, ret.to_date DESC;

-- ------------------------------
SELECT * FROM unique_titles;
DROP TABLE unique_titles;
-- ------------------------------

-- Part 3--------------------------------------
SELECT COUNT(uni.title), 
	uni.title

INTO retiring_titles
FROM unique_titles as uni
GROUP BY uni.title
ORDER BY COUNT(uni.title) DESC;
-- ------------------------------

SELECT * FROM retiring_titles;
DROP TABLE retiring_titles;
-- ------------------------------






-- Deliverable 2: --
SELECT DISTINCT ON (tit.emp_no) emp.emp_no,
	emp.first_name,
	emp.last_name,
	emp.birth_date,
	depemp.from_date,
	depemp.to_date,
	tit.title
INTO mentorship_eligibility
FROM employees as emp
INNER JOIN dept_emp as depemp
ON emp.emp_no = depemp.emp_no
INNER JOIN titles as tit
ON tit.emp_no = emp.emp_no
WHERE (emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	 AND (tit.to_date = '9999-01-01')
ORDER BY tit.emp_no;

SELECT * FROM mentorship_eligibility;
DROP TABLE mentorship_eligibility;








-- For Analysis -- 
-- Additional Tables for Deliverable 3
-- To Find: Number of employees eligible for mentorship vs number of employees retiring
		-- How many roles need to be filled as people start retiring and the mentored move up?


-- Counts of employees eligible for mentorship
SELECT COUNT(ment.title), 
	ment.title

INTO trainees
FROM mentorship_eligibility as ment
GROUP BY ment.title
ORDER BY COUNT(ment.title) DESC;

-- ----------------
SELECT * FROM trainees;
DROP TABLE trainees;


