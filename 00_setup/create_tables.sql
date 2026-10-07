-- =====================================================================
-- 00_setup/create_tables.sql
-- Purpose : Create and populate the tables used by every other script.
-- Run     : FIRST. Safe to re-run (drops old tables if they exist).
-- Currency: Amounts are monthly salaries in RWF.
-- =====================================================================
SET SERVEROUTPUT ON

-- Drop old objects safely (ORA-00942 = table does not exist -> ignore)
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE employees PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE departments PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE departments (
  dept_id    NUMBER(4)     CONSTRAINT pk_departments PRIMARY KEY,
  dept_name  VARCHAR2(50)  NOT NULL
);

CREATE TABLE employees (
  emp_id         NUMBER(6)     CONSTRAINT pk_employees PRIMARY KEY,
  emp_name       VARCHAR2(60)  NOT NULL,
  department_id  NUMBER(4)     CONSTRAINT fk_emp_dept REFERENCES departments(dept_id),
  salary         NUMBER(12,2),
  hire_date      DATE
);

INSERT INTO departments VALUES (10, 'Finance');
INSERT INTO departments VALUES (20, 'Information Technology');
INSERT INTO departments VALUES (30, 'Human Resources');
INSERT INTO departments VALUES (40, 'Sales');

-- Normal employees
INSERT INTO employees VALUES (101, 'Alice Uwase',      20, 850000, DATE '2015-03-15');
INSERT INTO employees VALUES (102, 'Eric Niyonzima',   10, 450000, DATE '2018-07-01');
INSERT INTO employees VALUES (103, 'Grace Mukamana',   30, 180000, DATE '2021-01-10');
INSERT INTO employees VALUES (104, 'Jean Habimana',    40,  95000, DATE '2022-09-05');
INSERT INTO employees VALUES (105, 'Diane Ingabire',   20,  55000, DATE '2024-02-20');

-- Deliberately "bad" rows used by the payroll validator (Task C1)
-- 106: no department | 107: zero salary | 108: hire date in future
INSERT INTO employees VALUES (106, 'Patrick Nshuti',   NULL, 300000, DATE '2019-06-12');
INSERT INTO employees VALUES (107, 'Sandra Uwimana',   10,       0, DATE '2020-05-01');
INSERT INTO employees VALUES (108, 'Kevin Mugisha',    30,  250000, DATE '2030-01-01');
COMMIT;

SELECT * FROM departments ORDER BY dept_id;
SELECT * FROM employees   ORDER BY emp_id;