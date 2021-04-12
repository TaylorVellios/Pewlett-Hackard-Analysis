CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);
-- --------------------------------
DROP TABLE departments;
-- --------------------------------

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);
-- --------------------------------
DROP TABLE employees;
-- --------------------------------

CREATE TABLE dept_manager(
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
-- --------------------------------
DROP TABLE dept_manager;
-- --------------------------------

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

-- --------------------------------
DROP TABLE salaries;
-- --------------------------------

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
-- --------------------------------
DROP TABLE dept_emp;
-- --------------------------------

CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES salaries (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);
-- --------------------------------
DROP TABLE titles;
-- --------------------------------

SELECT * FROM departments;



-- DETERMINE RETIREMENT ELIGIBILITY
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-01-01'
-- ------------------------------------------------------
-- FIND ALL EMPLOYEES BORN IN '52'
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31'
-- ------------------------------------------------------
-- FIND ALL EMPLOYEES BORN IN '53'
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31'
-- ------------------------------------------------------
-- FIND ALL EMPLOYEES BORN IN '54'
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31'
-- ------------------------------------------------------
-- FIND ALL EMPLOYEES BORN IN '55'
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31'
-- ------------------------------------------------------


-- RETIREMENT ELIGIBILITY - NARROWED
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- COUNTING THE NUMBER OF RESULTS
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');



-- CREATING NEW TABLES
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT * FROM retirement_info;
DROP TABLE retirement_info;

-- 7.3.2 JOINING TABLES
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- CHECK TABLE
SELECT * FROM retirement_info;

-- 7.3.3 JOINS IN ACTION
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- -----------------------------------------
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- SHORTEN WITH ALIASES -DECLARE THE VARIABLE AFTER THE SELECT STATEMENT - same code as above
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
-- -------------------------------------
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- -------MAKE A NEW TABLE FOR CURRENT EMPLOYEES ONLY WHO ARE ELIGIBLE TO RETIRE------------------------
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- 7.3.4 -- USING GROUPBY/ORDERBY AND COUNT
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no; -- without this line, the dept_no ordering would be seemingly random


-- SKILL DRILL, USING THE CODEBLOCK ABOVE, SET THE OUTPUT TO CREATE A NEW TABLE AND SAVE AS A .CSV FILE
SELECT COUNT(ce.emp_no), de.dept_no
INTO skill_drill734
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no; -- without this line, the dept_no ordering would be seemingly random

-- 7.3.5 -- CREATING A NEW TABLE FROM SCRATCH - 
SELECT * FROM salaries
ORDER BY to_date DESC;
-- -----------------------------
SELECT emp_no,
    first_name,
last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- -----------------------------------------------------------
DROP TABLE emp_info;
-- -----------------------------------------------------------

SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');
-- -----------------------------------------------------------
SELECT * FROM emp_info;
-- -----------------------------------------------------------

-- LIST 2: MANAGEMENT
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
-- LIST 3: DEPARTMENT RETIREES
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
-- SOME EMPLOYEES ARE SHOWING TWICE IN THESE RESULTS, BEFORE WE MAKE A NEW TABLE OUT OF THIS, WE HAVE WORK TO DO

-- 7.3.6 - CREATE A TAILORED LIST
SELECT * FROM dept_info;

--SKILL DRILL (1) 7.3.6
SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	di.dept_name
FROM retirement_info AS ri
LEFT JOIN dept_info AS di
ON (ri.emp_no = di.emp_no)
WHERE (di.dept_name = 'Sales');

-- SKILL DRILL (2) 7.3.6
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	di.dept_name
FROM retirement_info AS ri
LEFT JOIN dept_info AS di
ON ri.emp_no = di.emp_no
WHERE di.dept_name IN ('Sales', 'Development');



















SELECT * FROM retirement_info;