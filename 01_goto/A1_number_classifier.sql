-- =====================================================================
-- A1 - Number Classifier (uses GOTO)
-- Classifies each number as POSITIVE / NEGATIVE / ZERO and EVEN / ODD.
-- Rules respected: every GOTO jumps to a label in the SAME block level
-- (or an enclosing one), never INTO an IF/LOOP, and every label is
-- followed by an executable statement.
-- =====================================================================
SET SERVEROUTPUT ON

DECLARE
  TYPE t_nums IS TABLE OF NUMBER;
  v_tests  t_nums := t_nums(7, -4, 0, 10, -3, 2.5);   -- change/add values to test
  v_num    NUMBER;
  v_sign   VARCHAR2(10);
  v_parity VARCHAR2(20);
BEGIN
  FOR i IN 1 .. v_tests.COUNT LOOP
    v_num := v_tests(i);

    -- Step 1: decide the sign using GOTO
    IF v_num = 0 THEN
      GOTO is_zero;
    END IF;
    IF v_num > 0 THEN
      GOTO is_positive;
    END IF;
    GOTO is_negative;

    <<is_zero>>
    v_sign := 'ZERO';
    GOTO check_parity;

    <<is_positive>>
    v_sign := 'POSITIVE';
    GOTO check_parity;

    <<is_negative>>
    v_sign := 'NEGATIVE';
    GOTO check_parity;

    -- Step 2: even / odd
    <<check_parity>>
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
