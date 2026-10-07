-- =====================================================================
-- B1 - fn_annual_salary
-- Returns an employee's annual salary = monthly salary x 12.
-- Returns NULL if the employee does not exist (or has no salary), so the
-- function is safe to call from SELECT statements.
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_annual_salary (
  p_emp_id IN employees.emp_id%TYPE
) RETURN NUMBER
IS
  v_monthly employees.salary%TYPE;
BEGIN
  SELECT salary
    INTO v_monthly
    FROM employees
   WHERE emp_id = p_emp_id;

  RETURN v_monthly * 12;              
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;                     
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001, 'fn_annual_salary failed: ' || SQLERRM);
END fn_annual_salary;
/
SHOW ERRORS FUNCTION fn_annual_salary
