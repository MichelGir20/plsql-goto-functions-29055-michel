# C2 - Reflection

**Student:** <Michel GIRINSHUTI> | **ID:** <29055>

> DRAFT: rewrite this in your own words and replace the generic parts with what you actually experienced.

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
- <Write something real: e.g. getting DBMS_OUTPUT to display, the compile error in A3, understanding label placement, designing the validator order.>

## 6. How I would improve this
- Store tax bands in a table instead of hard-coding them.
- Add a package that groups the functions together.
- Replace the string returned by C1 with a record type or error code.
