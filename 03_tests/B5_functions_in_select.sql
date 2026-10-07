-- =====================================================================
-- B5 - Functions used inside SQL
-- Demonstrates stored functions in the SELECT list, WHERE and ORDER BY.
-- Requires B1-B4 to be compiled.
-- =====================================================================
SET LINESIZE 200
SET PAGESIZE 50
COLUMN emp_name FORMAT A18
COLUMN department FORMAT A24

PROMPT === 1. Functions in the SELECT list ===
SELECT e.emp_id,
       e.emp_name,
       fn_dept_name(e.department_id)   AS department,
       e.salary                        AS monthly_salary,
       fn_annual_salary(e.emp_id)      AS annual_salary,
       fn_years_of_service(e.emp_id)   AS years_service,
       fn_calculate_tax(e.salary)      AS monthly_tax
  FROM employees e
 ORDER BY e.emp_id;

PROMPT === 2. Function in WHERE: employees paying more than 10,000 tax ===
SELECT emp_id, emp_name, salary, fn_calculate_tax(salary) AS monthly_tax
  FROM employees
 WHERE fn_calculate_tax(salary) > 10000
 ORDER BY monthly_tax DESC;

PROMPT === 3. Function in ORDER BY / GROUP BY: payroll per department ===
SELECT fn_dept_name(department_id) AS department,
       COUNT(*)                    AS headcount,
       SUM(fn_annual_salary(emp_id)) AS total_annual_payroll
  FROM employees
 GROUP BY fn_dept_name(department_id)
 ORDER BY total_annual_payroll DESC NULLS LAST;
