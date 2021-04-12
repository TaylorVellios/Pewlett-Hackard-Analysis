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

