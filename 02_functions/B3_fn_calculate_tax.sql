-- =====================================================================
-- B3 - fn_calculate_tax
-- Progressive monthly income tax (PAYE-style bands, RWF):
--     0       -  60,000  : 0%
--     60,001  - 100,000  : 20% of the part above 60,000
--     above     100,000  : 8,000 + 30% of the part above 100,000
-- NULL input -> NULL.  Negative input -> ORA-20002 (invalid argument).
-- Pure computation (no table access, no DML) so it is DETERMINISTIC and
-- safe to use inside SQL.
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_calculate_tax (
  p_salary IN NUMBER
) RETURN NUMBER DETERMINISTIC
IS
  c_band1 CONSTANT NUMBER := 60000;
  c_band2 CONSTANT NUMBER := 100000;
  v_tax   NUMBER := 0;
BEGIN
  IF p_salary IS NULL THEN
    RETURN NULL;
  END IF;

  IF p_salary < 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be negative: ' || p_salary);
  END IF;

  IF p_salary <= c_band1 THEN
    v_tax := 0;
  ELSIF p_salary <= c_band2 THEN
    v_tax := (p_salary - c_band1) * 0.20;
  ELSE
    v_tax := (c_band2 - c_band1) * 0.20 + (p_salary - c_band2) * 0.30;
  END IF;

  RETURN ROUND(v_tax, 2);
END fn_calculate_tax;
/
SHOW ERRORS FUNCTION fn_calculate_tax
