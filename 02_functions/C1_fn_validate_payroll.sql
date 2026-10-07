-- =====================================================================
-- C1 - fn_validate_payroll  (combined task: GOTO + functions + exceptions)
-- Returns 'VALID: ...' or 'INVALID: <reason>' for one employee.
-- Checks, in order (first failure wins):
--   1. employee exists
--   2. salary is present and > 0
--   3. employee is assigned to an existing department
--   4. hire date is not in the future
-- Uses B1-B4, so compile those first.
--
-- GOTO design note: failures set v_msg then jump to ONE exit label.
-- The NO_DATA_FOUND case is detected with a flag instead of a GOTO
-- inside the exception handler (jumping from a handler back into the
-- block is illegal - see A3).
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_validate_payroll (
  p_emp_id IN employees.emp_id%TYPE
) RETURN VARCHAR2
IS
  v_salary  employees.salary%TYPE;
  v_dept_id employees.department_id%TYPE;
  v_dname   VARCHAR2(60);
  v_annual  NUMBER;
  v_tax     NUMBER;
  v_years   NUMBER;
  v_msg     VARCHAR2(200);
BEGIN
  -- Check 1: employee exists
  BEGIN
    SELECT salary, department_id
      INTO v_salary, v_dept_id
      FROM employees
     WHERE emp_id = p_emp_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_msg := 'Employee ' || p_emp_id || ' not found';
  END;
  IF v_msg IS NOT NULL THEN
    GOTO invalid_payroll;
  END IF;

  -- Check 2: salary
  IF v_salary IS NULL OR v_salary <= 0 THEN
    v_msg := 'Salary missing or not positive';
    GOTO invalid_payroll;
  END IF;

  -- Check 3: department
  v_dname := fn_dept_name(v_dept_id);
  IF v_dname IN ('No Department', 'Unknown Department') THEN
    v_msg := 'Employee is not assigned to a valid department';
    GOTO invalid_payroll;
  END IF;

  -- Check 4: hire date
  v_years := fn_years_of_service(p_emp_id);
  IF v_years IS NULL THEN
    v_msg := 'Hire date missing';
    GOTO invalid_payroll;
  ELSIF v_years < 0 THEN
    v_msg := 'Hire date is in the future';
    GOTO invalid_payroll;
  END IF;

  -- All checks passed
  v_annual := fn_annual_salary(p_emp_id);
  v_tax    := fn_calculate_tax(v_salary);
  RETURN 'VALID: ' || v_dname || ', annual=' || v_annual
         || ', monthly tax=' || v_tax || ', years=' || v_years;

  <<invalid_payroll>>
  RETURN 'INVALID: ' || v_msg;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 'ERROR: ' || SQLERRM;
END fn_validate_payroll;
/
SHOW ERRORS FUNCTION fn_validate_payroll
