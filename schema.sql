DROP TABLE IF EXISTS manages;
DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS employee;


CREATE TABLE IF NOT EXISTS employee (
    employee_name VARCHAR(50) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS works (
    employee_name VARCHAR(50),
    company_name VARCHAR(50),
    salary DECIMAL(10, 2),
    PRIMARY KEY (employee_name, company_name),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);


CREATE TABLE IF NOT EXISTS company (
    company_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS manages (
    employee_name VARCHAR(50),
    manager_name VARCHAR(50),
    PRIMARY KEY (employee_name, manager_name),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name),
    FOREIGN KEY (manager_name) REFERENCES employee(employee_name)
);


TRUNCATE TABLE manages, works, company, employee CASCADE;


INSERT INTO employee (employee_name, street, city) VALUES
('Alice', '123 Main St', 'New York'),
('Bob', '456 Maple Ave', 'Los Angeles'),
('Charlie', '789 Oak St', 'Chicago'),
('David', '321 Pine Rd', 'New York'),
('Eve', '654 Elm St', 'San Francisco'),
('Frank', '987 Cedar St', 'Chicago');


INSERT INTO works (employee_name, company_name, salary) VALUES
('Alice', 'First Bank Corporation', 12000.00),
('Bob', 'Small Bank Corporation', 9000.00),
('Charlie', 'First Bank Corporation', 15000.00),
('David', 'First Bank Corporation', 9500.00),
('Eve', 'Small Bank Corporation', 11000.00),
('Frank', 'Big Tech Inc', 13000.00);


INSERT INTO company (company_name, city) VALUES
('First Bank Corporation', 'New York'),
('Small Bank Corporation', 'Los Angeles'),
('Big Tech Inc', 'Chicago');


INSERT INTO manages (employee_name, manager_name) VALUES
('Alice', 'Charlie'),
('Bob', 'Eve'),
('Charlie', 'Alice'),
('David', 'Charlie'),
('Eve', 'Bob');




-- a) Find the names and cities of residence of all employees who work for 'First Bank Corporation'.
SELECT e.employee_name, e.city
FROM employee e
JOIN works w ON e.employee_name = w.employee_name
WHERE w.company_name = 'First Bank Corporation';

-- b) Find the names, street addresses, and cities of residence of all employees who work for 'First Bank Corporation' and earn more than $10,000.
SELECT e.employee_name, e.street, e.city
FROM employee e
JOIN works w ON e.employee_name = w.employee_name
WHERE w.company_name = 'First Bank Corporation' AND w.salary > 10000;

-- c) Find all employees in the database who live in the same city as the company 'Small Bank Corporation'.
SELECT e.employee_name
FROM employee e
WHERE e.city = (
    SELECT c.city
    FROM company c
    WHERE c.company_name = 'Small Bank Corporation'
);

-- d) Find all employees in the database who do not work for 'First Bank Corporation'.
SELECT e.employee_name
FROM employee e
WHERE e.employee_name NOT IN (
    SELECT w.employee_name
    FROM works w
    WHERE w.company_name = 'First Bank Corporation'
);

-- e) Assume that the companies may be located in several cities. Find all employees who earn more than each employee of 'Small Bank Corporation'.
SELECT e.employee_name
FROM works e
WHERE e.salary > ALL (
    SELECT w.salary
    FROM works w
    WHERE w.company_name = 'Small Bank Corporation'
);

-- f) Find the company that has the most employees.
SELECT w.company_name
FROM works w
GROUP BY w.company_name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- g) Find those companies whose employees earn a higher salary, on average, than the average salary at 'First Bank Corporation'.
SELECT w.company_name
FROM works w
GROUP BY w.company_name
HAVING AVG(w.salary) > (
    SELECT AVG(w.salary)
    FROM works w
    WHERE w.company_name = 'First Bank Corporation'
);