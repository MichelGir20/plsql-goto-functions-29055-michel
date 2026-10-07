-- =====================================================================
-- A3 - Illegal GOTO and Fix
-- Run this whole file. Block 1 FAILS TO COMPILE on purpose (screenshot the
-- error). Block 2 is the corrected version and runs successfully.
--
-- Rule broken: a GOTO cannot jump INTO an IF, CASE, LOOP or sub-block.
-- Other illegal jumps (not run here):
--   * from an exception handler back into the block's executable section
--   * from one IF/ELSE branch into another branch
--   * from outside a subprogram into it
--   * to a label that does not exist (PLS-00201)
-- =====================================================================
SET SERVEROUTPUT ON

PROMPT === BLOCK 1: ILLEGAL (expect PLS-00375: illegal GOTO statement) ===
DECLARE
  v_flag BOOLEAN := TRUE;
BEGIN
  GOTO inside_if;                       -- ILLEGAL: label is inside the IF block

  IF v_flag THEN
    <<inside_if>>
    DBMS_OUTPUT.PUT_LINE('Reached the label inside the IF block');
  END IF;
END;
/

PROMPT === BLOCK 2: FIXED (label moved to the same level as the GOTO) ===
DECLARE
  v_flag BOOLEAN := TRUE;
BEGIN
  IF v_flag THEN
    GOTO show_message;                  -- legal: jumping OUT of an IF to an enclosing level
  END IF;

  DBMS_OUTPUT.PUT_LINE('This line is skipped when v_flag is TRUE');

  <<show_message>>                      -- label sits at the top level of the block
  DBMS_OUTPUT.PUT_LINE('Reached the label legally');
END;
/
