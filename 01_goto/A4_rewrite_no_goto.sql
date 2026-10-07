-- =====================================================================
-- A4 - Rewrite Without GOTO
-- The A1 (number classifier) and A2 (salary review) programs rewritten
-- with structured IF / ELSIF / CASE. Output is identical to the GOTO
-- versions but the control flow is readable top-to-bottom.
-- =====================================================================
SET SERVEROUTPUT ON

PROMPT === A1 rewritten: Number Classifier ===
DECLARE
  TYPE t_nums IS TABLE OF NUMBER;
  v_tests  t_nums := t_nums(7, -4, 0, 10, -3, 2.5);
  v_num    NUMBER;
  v_sign   VARCHAR2(10);
  v_parity VARCHAR2(20);
BEGIN
  FOR i IN 1 .. v_tests.COUNT LOOP
    v_num := v_tests(i);

    v_sign := CASE
                WHEN v_num = 0 THEN 'ZERO'
                WHEN v_num > 0 THEN 'POSITIVE'
                ELSE 'NEGATIVE'
              END;

    IF v_num <> TRUNC(v_num) THEN
      v_parity := 'NOT AN INTEGER';
    ELSIF MOD(v_num, 2) = 0 THEN
      v_parity := 'EVEN';
    ELSE
      v_parity := 'ODD';
    END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD(TO_CHAR(v_num), 6) || ' -> ' || RPAD(v_sign, 9) || ' | ' || v_parity);
  END LOOP;
END;
/

PROMPT === A2 rewritten: Salary Review ===
DECLARE
  v_pct  NUMBER;
  v_band VARCHAR2(10);
  v_new  NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('EMP', 18) || RPAD('BAND', 8) || RPAD('OLD', 11) || RPAD('RAISE', 7) || 'NEW');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));

  FOR r IN (SELECT emp_id, emp_name, salary FROM employees ORDER BY emp_id) LOOP
    IF r.salary IS NULL OR r.salary <= 0 THEN
      DBMS_OUTPUT.PUT_LINE(RPAD(r.emp_name, 18) || 'INVALID SALARY - manual review required');
    ELSE
      IF r.salary < 100000 THEN
        v_band := 'Low';  v_pct := 10;
      ELSIF r.salary < 500000 THEN
        v_band := 'Mid';  v_pct := 5;
      ELSE
        v_band := 'High'; v_pct := 0;
      END IF;

      v_new := r.salary * (1 + v_pct / 100);
      DBMS_OUTPUT.PUT_LINE(RPAD(r.emp_name, 18) || RPAD(v_band, 8) || RPAD(r.salary, 11)
                           || RPAD(v_pct || '%', 7) || v_new);
    END IF;
  END LOOP;
END;
/
