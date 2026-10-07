-- =====================================================================
-- test_functions.sql - tests for B1-B4 (normal, edge and error cases)
-- Expected values that do not depend on today's date are shown in [].
-- =====================================================================
SET SERVEROUTPUT ON

DECLARE
  PROCEDURE show (p_label IN VARCHAR2, p_val IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD(p_label, 48) || NVL(p_val, 'NULL'));
  END;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- B1 fn_annual_salary ---');
  show('emp 101 (850000 x 12)  [10200000]',   fn_annual_salary(101));
  show('emp 105 (55000 x 12)   [660000]',     fn_annual_salary(105));
  show('emp 999 not found      [NULL]',       fn_annual_salary(999));

  DBMS_OUTPUT.PUT_LINE('--- B2 fn_years_of_service ---');
  show('emp 101 hired 2015-03-15',            fn_years_of_service(101));
  show('emp 105 hired 2024-02-20',            fn_years_of_service(105));
  show('emp 108 hired in future [negative]',  fn_years_of_service(108));
  show('emp 999 not found       [NULL]',      fn_years_of_service(999));

  DBMS_OUTPUT.PUT_LINE('--- B3 fn_calculate_tax ---');
  show('50,000   [0]',      fn_calculate_tax(50000));
  show('60,000   [0]',      fn_calculate_tax(60000));
  show('80,000   [4000]',   fn_calculate_tax(80000));
  show('100,000  [8000]',   fn_calculate_tax(100000));
  show('150,000  [23000]',  fn_calculate_tax(150000));
  show('NULL     [NULL]',   fn_calculate_tax(NULL));
  BEGIN
    show('-5 (should raise ORA-20002)', fn_calculate_tax(-5));
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(RPAD('-5 raised as expected', 48) || SQLERRM);
  END;

  DBMS_OUTPUT.PUT_LINE('--- B4 fn_dept_name ---');
  show('dept 10  [Finance]',                  fn_dept_name(10));
  show('dept 20  [Information Technology]',   fn_dept_name(20));
  show('dept 99  [Unknown Department]',       fn_dept_name(99));
  show('dept NULL [No Department]',           fn_dept_name(NULL));
END;
/
