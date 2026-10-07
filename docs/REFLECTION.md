# C2 - Reflection

**Student:** Michel GIRINSHUTI | **ID:** 29055


## 1. What I learned about GOTO
A `GOTO` jumps to a label written as `<<label_name>>`. In A1 and A2 it worked, but the code became hard to follow, because I had to trace labels up and down the block to understand the flow. While doing A3 I learned the main restrictions:
- A GOTO cannot jump **into** an IF, CASE, LOOP or nested block. It produces `PLS-00375`.
- A GOTO cannot jump from an exception handler back into the block's executable section.
- A label must be followed by an executable statement (I used `NULL;` where needed).

In A4, IF/ELSIF/CASE gave the same output with simpler code, so I would normally avoid GOTO.

## 2. Where GOTO can still be reasonable
In C1, a single `GOTO invalid_payroll` exit label avoided repeating the "return an invalid message" code in every validation check. It is acceptable when it jumps forward to one clean exit point, but the same thing can be done with early `RETURN` statements.

## 3. What I learned about functions
- A function always **returns one value**, so it can be used in expressions and in SQL, unlike a procedure.
- Small single-purpose functions (B1 to B4) are easy to test and could be reused. C1 reuses four of them.
- I handled `NO_DATA_FOUND` by returning `NULL` (or a label) so a query over many rows does not fail because of one missing record. I used `RAISE_APPLICATION_ERROR` for truly invalid input such as a negative salary.

## 4. Functions in SQL (B5)
Functions can appear in SELECT, WHERE, GROUP BY and ORDER BY. Because a function that queries a table runs once per row, it can be slow on large tables, and a function called from SQL should not perform DML. `fn_calculate_tax` does no table access, so I marked it `DETERMINISTIC`.

## 5. Challenges
###1. Tablespace quota issue (ORA-01950)
This was the most serious technical roadblock:

My user MICHEL_PLSQLAUCA_29055 had its default tablespace set to SYSTEM
SYSTEM had no storage quota, so CREATE TABLE succeeded but every INSERT failed
My A2 script printed only the header, no rows — AI initially thought it was a GOTO bug, but I correctly pushed back and diagnosed it as a storage issue
I then discovered MY PDB had no USERS tablespace at all — only SYSTEM, SYSAUX, TEMP, UNDOTBS1

Fix required:

Creating a USERS tablespace as SYSDBA
ALTER USER ... QUOTA UNLIMITED ON USERS
ALTER USER ... DEFAULT TABLESPACE USERS
Dropping empty tables and re-running setup

###2. The ORA-03405: End of query reached error
Caused by inline -- comments at the end of INSERT statements
SQL*Plus @ script parser choked on them
Fix: moved comments to their own lines above the INSERTs

###3. GOTO statement semantics
The A2 code had a structural problem where GOTO jumps inside the loop weren't producing output
I had to iterate on the logic and restructure the GOTO structure so it actually executed
I learned that GOTO can't jump into an IF block or a loop body — only out of one
## 6. How I would improve this
- Store tax bands in a table instead of hard-coding them.
- Add a package that groups the functions together.
- Replace the string returned by C1 with a record type or error code.
