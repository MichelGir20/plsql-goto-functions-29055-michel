-- =====================================================================
-- test_validate_payroll.sql - tests for C1
-- Expected: 101-105 VALID; 106 no department; 107 zero salary;
--           108 future hire date; 999 not found.
-- =====================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

BEGIN
  FOR r IN (SELECT emp_id, emp_name FROM employees ORDER BY emp_id) LOOP
    DBMS_OUTPUT.PUT_LINE(r.emp_id || ' ' || RPAD(r.emp_name, 16) || fn_validate_payroll(r.emp_id));
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('999 ' || RPAD('(no such emp)', 16) || fn_validate_payroll(999));
END;
/

-- Same check from plain SQL
SELECT emp_id, emp_name, fn_validate_payroll(emp_id) AS payroll_status
  FROM employees
 ORDER BY emp_id;
