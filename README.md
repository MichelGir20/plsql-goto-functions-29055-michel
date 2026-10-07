# PL/SQL GOTO Statements and Functions - Individual Assignment III

**Course:** Database Development with PL/SQL (INSY 8311)
**Instructor:** Eric Maniraguha
**Student:** <FULL NAME> | **Student ID:** <STUDENT ID> | **Group:** <GROUP>
**Deadline:** Thursday, 8 October 2026, 11:59 PM

## 1. Overview
This project covers four topics:
- PL/SQL `GOTO` statements, including illegal uses and how to fix them
- Stored functions
- Exception handling
- Using stored functions inside SQL

All scripts use two tables: `departments` and `employees` (monthly salaries in RWF).

## 2. Repository Structure
```
plsql-goto-functions-<studentID>-<firstname>/
├── README.md
├── .gitignore
├── 00_setup/create_tables.sql
├── 01_goto/            A1 number classifier, A2 salary review, A3 illegal GOTO + fix, A4 rewrite without GOTO
├── 02_functions/       B1 annual salary, B2 years of service, B3 tax, B4 department name, C1 payroll validator
├── 03_tests/           B5 functions in SELECT, test_functions, test_validate_payroll
├── screenshots/        A1, A2, A3, A4, B5, C1 output images
└── docs/REFLECTION.md  C2 reflection
```

## 3. Task Summary
| Task | File | What it does |
|------|------|--------------|
| A1 | `01_goto/A1_number_classifier.sql` | Classifies numbers as positive/negative/zero and even/odd using GOTO |
| A2 | `01_goto/A2_salary_review.sql` | Assigns a raise band to each employee using GOTO (display only) |
| A3 | `01_goto/A3_illegal_goto.sql` | Shows a GOTO into an IF block (PLS-00375) and the fixed version |
| A4 | `01_goto/A4_rewrite_no_goto.sql` | A1 and A2 rewritten with IF/ELSIF/CASE |
| B1 | `02_functions/B1_fn_annual_salary.sql` | `fn_annual_salary(emp_id)` = salary x 12 |
| B2 | `02_functions/B2_fn_years_of_service.sql` | `fn_years_of_service(emp_id)` = completed years since hire |
| B3 | `02_functions/B3_fn_calculate_tax.sql` | `fn_calculate_tax(salary)` progressive tax bands |
| B4 | `02_functions/B4_fn_dept_name.sql` | `fn_dept_name(dept_id)` returns the department name |
| B5 | `03_tests/B5_functions_in_select.sql` | Functions in SELECT, WHERE, GROUP BY |
| C1 | `02_functions/C1_fn_validate_payroll.sql` | Validates an employee's payroll record (GOTO + functions + exceptions) |
| C2 | `docs/REFLECTION.md` | Written reflection |

### Business rules used
- **Salary review (A2):** below 100,000 = +10%; 100,000 to 499,999 = +5%; 500,000 and above = 0%; NULL or <= 0 = manual review.
- **Tax (B3), monthly:** 0 to 60,000 = 0%; 60,001 to 100,000 = 20% of the part above 60,000; above 100,000 = 8,000 + 30% of the part above 100,000.
- **Error handling:** functions return `NULL` (or a descriptive label) for unknown records so they are safe in SQL. Invalid arguments raise `ORA-20001` to `ORA-20004` through `RAISE_APPLICATION_ERROR`.
- **Payroll validation (C1):** the employee must exist, have a salary > 0, belong to a real department, and have a hire date that is not in the future.

## 4. How to Run
Use Oracle SQL Developer, SQL*Plus or Live SQL. Run from the repository root.

1. `@00_setup/create_tables.sql`
2. Functions, in this order (C1 depends on the others):
   `@02_functions/B1_fn_annual_salary.sql`, `B2_...`, `B3_...`, `B4_...`, then `C1_fn_validate_payroll.sql`
3. GOTO programs: `@01_goto/A1_number_classifier.sql`, `A2_...`, `A3_...`, `A4_...`
4. Tests: `@03_tests/test_functions.sql`, `@03_tests/B5_functions_in_select.sql`, `@03_tests/test_validate_payroll.sql`
5. Compare the output with the screenshots in `screenshots/`.

> In SQL Developer, enable **View > DBMS Output** to see `DBMS_OUTPUT` results.
> `A3_illegal_goto.sql` is **supposed** to show a compile error for Block 1. Block 2 then runs correctly.

## 5. Screenshots
| File | Shows |
|------|-------|
| `A1_output.png` | Number classifier output |
| `A2_output.png` | Salary review output |
| `A3_error_and_fix.png` | PLS-00375 error and the fixed block's output |
| `A4_output.png` | Non-GOTO rewrites |
| `B5_select_output.png` | SELECT queries using the functions |
| `C1_output.png` | Payroll validator results |

## 6. Notes (AI Assistance Disclosure)
I used an AI assistant (Claude by Anthropic) to help draft the SQL scripts and the documentation for this assignment, as permitted by the assignment's Academic Integrity policy. I then ran the scripts myself in Oracle, reviewed and tested every function, took the screenshots from my own runs, and wrote my reflection in my own words. I understand the code and can explain it.

<!-- STUDENT: edit the paragraph above so it truthfully describes what YOU did. -->
