# Pewlett Hackard Analysis
#### Using postreSQL with pgAdmin to comb through a database of employee data.
<br>

## Overview
A database was built in pgAdmin based on 6 .CSV files containing employee data.<br>

![EmployeeDB](https://user-images.githubusercontent.com/14188580/114931574-079d4980-9dfc-11eb-81a1-e57a517d7c28.png)

<br>
Our goal is to use queries on a large database to find the size and members of the available workforce that are eligible for retirement.<br>
By finding that information, the next goal is to determine what steps will be needed to ensure a smooth transition of labor in the event of a mass retirement.<br><br>


## Results
The First stop on the road to finding useful information is through collection.<br>
With our first query, we will do the following:<br>
* Join the Employees and Titles tables
* Create a new table to filter further
* Supply a conditional to the birth_date column to find only those eligible for retirement.
<br></br>
![pic1](https://user-images.githubusercontent.com/14188580/114931239-9a89b400-9dfb-11eb-8c9d-2101b3e4b060.PNG)
<br></br>

* Using DISTINCT ON, we can further filter the table above to only include the most recent title given to an employee.
<br></br>
![pic2](https://user-images.githubusercontent.com/14188580/114931256-9eb5d180-9dfb-11eb-86f6-baf1046618ee.PNG)
<br></br>

* Using COUNT on the table results from above, it is apparent which titles will be the most impacted by the upcoming 'silver-tsunami'.
* Please keep in mind this query requested of us does not filter out former employees. The numbers below are not a true indication of those who are eligible for retirement, but it is a good jumping-off point.
<br></br>
![pic3](https://user-images.githubusercontent.com/14188580/114931268-a37a8580-9dfb-11eb-8a3d-19dd5364b4de.PNG)
<br></br>

Due to the large numbers we are seeing in the results of retiring employees, we need to write a query to find the pool of employees who meet the company's criteria to fill a mentorship role, overseeing the younger workforce.
~~~~
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
~~~~
<br></br>
![pic4](https://user-images.githubusercontent.com/14188580/114931282-a7a6a300-9dfb-11eb-8e2f-f82cda6d3db1.PNG)
<br></br>

#### Key Takeaways:
* There is still a large subset of employees unaccounted for outside of these two separate tables.
* The count of titles for those eligible to retire include former employees, we will deal with this in a moment.
* Without a comparative metric for total employees against those nearing retirement, we have no way to determine the significance of the data above.
* The tables requested above are less about telling a story and more about creating a solid organizational foundation from where we can begin to dig into the data.
<br></br>

## Summary: 

Based on the information above, I created 4 new tables in an effort to tell a more concrete story in regards to this "silver tsunami".<br>
They have been joined together to create the following image:<br></br>

![ALLCOUNTS](https://user-images.githubusercontent.com/14188580/114931298-ad03ed80-9dfb-11eb-9541-a2c3155c637f.PNG)

<br>
The image above is an accumulation of all job-title counts for 4 different categorizations:<br>
* Total Current Employees
* Retiring Count - All Current Employees Eligible for Retirement in the Next Few Years
* Mentorship Eligible Count - Current Employees who Fall Into the Age range of Those Eligible for Mentoring
* All Others - All Current Employees Who are Not Eligible for Retirement or Mentorship
<br>

#### What Does This Tell Us?

If you are noticing a difference in the counts between the eligible retirees in the Results section and the Summary section, you have a keen eye.<br>
The combination table above is based on queries returning ONLY current employees.<br>
While the population of employees eligible for mentorship is significantly smaller than those retiring, there is still a huge workforce available.<br>
I would highly recommend moving the current system of mentorship eligibility away from it's current criteria.<br>
Age is not a reliable indicator of an individual's experience, which is why the huge number of incoming retirees is not too concerning so long as we look at the broader pool of talent that we already have available to fill upper positions.<br>

<br>
As it currently stands, for each title there would be about 1 mentor per 100 other employees.<br>
Simply put, that is not enough manpower. It is not a great idea to limit mentors to those born within a single year.



