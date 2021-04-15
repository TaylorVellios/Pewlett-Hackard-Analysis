--Deliverable 1:
-- Part 1------------- GETTING ALL EMPLOYEES QUALIFIED FOR RETIREMENT BASED ON BIRTH_DATE - TABLE NAME: Deliverable_one
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

-- SAME AS ABOVE BUT ONLY CURRENT EMPLOYEES - TABLE NAME: CHECKING_CURRENT
SELECT emp.emp_no,
	emp.first_name,
	emp.last_name,
	tit.title,
	tit.from_date,
	tit.to_date
INTO checking_current
FROM employees as emp
INNER JOIN titles as tit
ON (emp.emp_no = tit.emp_no)
WHERE (emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	 AND (tit.to_date = '9999-01-01')
ORDER BY emp.emp_no;

-- ------------------------------
DROP TABLE checking_current;
SELECT * FROM checking_current;
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

-- Part 3------------------GETTING COUNTS OF ALL TITLES FOR THOSE ELIGIBLE TO RETIRE - TABLE NAME: retiring_titles
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


-- ---------------------COUNTING ONLY THE CURRENT EMPLOYEE TITLES FOR THOSE ELIGIBLE TO RETIRE - TABLE NAME: CURRENT_RETIREES
SELECT COUNT(title),
	title
INTO CURRENT_RETIREES
FROM checking_current
GROUP BY (title)
ORDER BY COUNT(title) DESC;



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




-- ANALYSIS AND SUMMARY
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
-- ----------------

-- FILTERING THE EMPLOYEES - INCLUDES EVERYONE NOT ELIGIBLE FOR RETIREMENT OR MENTORSHIP
SELECT DISTINCT ON (emp.emp_no) emp.emp_no,
	emp.first_name,
	emp.last_name,
	emp.birth_date,
	tit.title,
	tit.from_date,
	tit.to_date
INTO non_retiring_non_mentor
FROM employees as emp
FULL OUTER JOIN titles as tit
ON (emp.emp_no = tit.emp_no)
WHERE (emp.birth_date BETWEEN '1956-01-01' AND '1964-12-31' AND tit.to_date = '9999-01-01')
OR (emp.birth_date >= '1966-01-01') AND (tit.to_date = '9999-01-01')
ORDER BY emp.emp_no;

select * from non_retiring_non_mentor;
drop table non_retiring_non_mentor;


-- GET COUNTS OF TITLES FOR ALL EMPLOYEES NOT INCLUDED IN THE OTHER TWO COUNTS TABLES
SELECT COUNT(ment.title), 
	ment.title
INTO ALL_OTHERS_COUNTS
FROM non_retiring_non_mentor as ment
GROUP BY ment.title
ORDER BY COUNT(ment.title) DESC;

ALTER TABLE ALL_OTHERS_COUNTS
RENAME COLUMN count TO ALL_OTHERS;

SELECT * FROM ALL_OTHERS_COUNTS;

DROP TABLE ALL_OTHERS_COUNTS;

-- GET COUNTS OF TITLES FOR THOSE ELIGIBLE FOR MEMBERSHIP
SELECT COUNT(ment.title), 
	ment.title
INTO MENTORSHIP_COUNTS
FROM MENTORSHIP_ELIGIBILITY as ment
GROUP BY ment.title
ORDER BY COUNT(ment.title) DESC;


INSERT INTO MENTORSHIP_COUNTS(mentorship_eligible_count, title)
VALUES (0,'Manager');

-- GET ALL CURRENT EMPLOYEES
SELECT emp.emp_no,
	tit.title
INTO CURRENT_EMPLOYEES
FROM Employees as emp
LEFT JOIN titles as tit
ON (emp.emp_no = tit.emp_no)
WHERE tit.to_date = '9999-01-01'
ORDER BY emp.emp_no;

SELECT * FROM CURRENT_EMPLOYEE_COUNTS;
DROP TABLE CURRENT_EMPLOYEE_COUNTS;

-- get counts of all current employees
SELECT COUNT(title),
title
INTO CURRENT_EMPLOYEE_COUNTS
FROM CURRENT_EMPLOYEES
GROUP BY title
ORDER BY COUNT(title) desc;

ALTER TABLE CURRENT_EMPLOYEE_COUNTS
RENAME COLUMN count TO total_employees;

-- COUNTS
-- ONLY RETIRING CURRENT EMPLOYEES
SELECT * FROM CURRENT_RETIREES;
-- ONLY CURRENT EMPLOYEES WHO ARE NOT RETIRING OR IN THE MENTORSHIP RANGE
SELECT * FROM ALL_OTHERS_COUNTS;
-- ONLY EMPLOYEES IN THE MENTORSHIP RANGE
SELECT * FROM MENTORSHIP_COUNTS;
-- ALL CURRENT EMPLOYEES
SELECT * FROM CURRENT_EMPLOYEE_COUNTS;

-- combining all counts into one table
SELECT curr.title,
curr.total_employees,
ret.retiring_count,
ment.mentorship_eligible_count,
allothers.all_others
INTO ALL_COUNTS_COMBINED
FROM CURRENT_EMPLOYEE_COUNTS AS curr
LEFT JOIN CURRENT_RETIREES AS ret
ON (curr.title = ret.title)
LEFT JOIN MENTORSHIP_COUNTS AS ment
ON (ret.title = ment.title)
LEFT JOIN ALL_OTHERS_COUNTS AS allothers
ON (ment.title = allothers.title)
ORDER BY CURR.total_employees DESC;



UPDATE ALL_COUNTS_COMBINED
SET all_others = 0
WHERE all_others IS NULL;


SELECT * FROM ALL_COUNTS_COMBINED;
DROP TABLE ALL_COUNTS_COMBINED;
