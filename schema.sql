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


INSERT INTO employee (employee_name, street, city) VALUES ('Jones', '789 Pine St', 'Oldtown');


-- a. Modify the database so that “Jones” now lives in “Newtown”.

UPDATE employee
SET city = 'Newtown'
WHERE employee_name = 'Jones';



-- b. Give all managers of “First Bank Corporation” a 10 percent raise 
--    unless the salary becomes greater than $100,000; in such cases, 
--    give only a 3 percent raise.

UPDATE works
SET salary = 
    CASE 
        WHEN salary * 1.10 <= 100000 THEN salary * 1.10
        ELSE salary * 1.03
    END
WHERE employee_name IN (
    SELECT DISTINCT m.manager_name
    FROM manages m
    JOIN works w ON m.manager_name = w.employee_name
    WHERE w.company_name = 'First Bank Corporation'
);