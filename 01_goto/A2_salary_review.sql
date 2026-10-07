-- =====================================================================
-- A2 - Salary Review (uses GOTO)
-- Review rules (monthly salary, RWF):
--   salary < 100,000            -> 10% increase  (Low band)
--   100,000 <= salary < 500,000 ->  5% increase  (Mid band)
--   salary >= 500,000           ->  0% increase  (High band)
--   NULL or <= 0                -> flagged for manual review
-- Display only: no UPDATE is executed.
-- =====================================================================
SET SERVEROUTPUT ON

DECLARE
  v_pct  NUMBER;
  v_band VARCHAR2(10);
  v_new  NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('EMP', 22) || RPAD('BAND', 8) || RPAD('OLD', 12) || RPAD('RAISE', 8) || 'NEW');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 62, '-'));

  FOR r IN (SELECT emp_id, emp_name, salary FROM employees ORDER BY emp_id) LOOP

    v_pct  := NULL;
    v_band := NULL;

    -- Validate salary first
    IF r.salary IS NULL OR r.salary <= 0 THEN
      DBMS_OUTPUT.PUT_LINE(RPAD(r.emp_name, 22) || 'INVALID SALARY - manual review required');
      CONTINUE;   -- skip to next iteration; no GOTO needed
    END IF;

    -- Classify salary using GOTO
    IF r.salary < 100000 THEN
      GOTO band_low;
    ELSIF r.salary < 500000 THEN
      GOTO band_mid;
    ELSE
      GOTO band_high;
    END IF;

    <<band_low>>
    v_band := 'Low';
    v_pct  := 10;
    GOTO show_result;

    <<band_mid>>
    v_band := 'Mid';
    v_pct  := 5;
    GOTO show_result;

    <<band_high>>
    v_band := 'High';
    v_pct  := 0;
    GOTO show_result;

    <<show_result>>
    v_new := r.salary * (1 + v_pct / 100);
    DBMS_OUTPUT.PUT_LINE(
        RPAD(r.emp_name, 22) ||
        RPAD(v_band, 8)      ||
        RPAD(TO_CHAR(r.salary, '999,999,999'), 12) ||
        RPAD(v_pct || '%', 8) ||
        TO_CHAR(v_new, '999,999,999')
    );

  END LOOP;
END;
/