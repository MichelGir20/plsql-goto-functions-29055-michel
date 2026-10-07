-- =====================================================================
-- B2 - fn_years_of_service
-- Returns the number of COMPLETED years between hire_date and today.
-- NULL for unknown employee or missing hire date.
-- A hire date in the future gives a NEGATIVE value (used by the C1
-- validator to detect bad data).
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_years_of_service (
  p_emp_id IN employees.emp_id%TYPE
) RETURN NUMBER
IS
  v_hire employees.hire_date%TYPE;
BEGIN
  SELECT hire_date
    INTO v_hire
    FROM employees
   WHERE emp_id = p_emp_id;

  IF v_hire IS NULL THEN
    RETURN NULL;
  END IF;

  RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire) / 12);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'fn_years_of_service failed: ' || SQLERRM);
END fn_years_of_service;
/
SHOW ERRORS FUNCTION fn_years_of_service
