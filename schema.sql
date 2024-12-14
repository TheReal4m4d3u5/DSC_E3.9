-- Drop tables if they exist
DROP TABLE IF EXISTS depositor;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS borrower;
DROP TABLE IF EXISTS loan;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS branch;

-- Create branch table
CREATE TABLE branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets DECIMAL(15, 2)
);

INSERT INTO branch VALUES ('Downtown', 'New York', 1000000.00);
INSERT INTO branch VALUES ('Uptown', 'Los Angeles', 500000.00);
INSERT INTO branch VALUES ('Suburbia', 'Harrison', 750000.00);

-- Create customer table
CREATE TABLE customer (
    customer_name VARCHAR(50) PRIMARY KEY,
    customer_street VARCHAR(50),
    customer_city VARCHAR(50)
);

INSERT INTO customer VALUES ('Smith', 'Main St', 'New York');
INSERT INTO customer VALUES ('Johnson', 'Pine St', 'Los Angeles');
INSERT INTO customer VALUES ('Williams', 'Oak St', 'Harrison');
INSERT INTO customer VALUES ('Brown', 'Maple St', 'New York');
INSERT INTO customer VALUES ('Miller', 'Pine St', 'Harrison');  -- Added Miller here

-- Create loan table
CREATE TABLE loan (
    loan_number VARCHAR(20) PRIMARY KEY,
    branch_name VARCHAR(50),
    amount DECIMAL(15, 2),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

INSERT INTO loan VALUES ('L1', 'Downtown', 5000.00);
INSERT INTO loan VALUES ('L2', 'Uptown', 3000.00);

-- Create borrower table
CREATE TABLE borrower (
    customer_name VARCHAR(50),
    loan_number VARCHAR(20),
    PRIMARY KEY (customer_name, loan_number),
    FOREIGN KEY (customer_name) REFERENCES customer(customer_name),
    FOREIGN KEY (loan_number) REFERENCES loan(loan_number)
);

INSERT INTO borrower VALUES ('Smith', 'L1');
INSERT INTO borrower VALUES ('Miller', 'L2');  -- Miller exists now

-- Create account table
CREATE TABLE account (
    account_number VARCHAR(20) PRIMARY KEY,
    branch_name VARCHAR(50),
    balance DECIMAL(15, 2),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

INSERT INTO account VALUES ('A1', 'Downtown', 2000.00);
INSERT INTO account VALUES ('A2', 'Suburbia', 1500.00);
INSERT INTO account VALUES ('A3', 'Uptown', 3000.00);
INSERT INTO account VALUES ('A4', 'Suburbia', 3000.00);

-- Create depositor table
CREATE TABLE depositor (
    customer_name VARCHAR(50),
    account_number VARCHAR(20),
    PRIMARY KEY (customer_name, account_number),
    FOREIGN KEY (customer_name) REFERENCES customer(customer_name),
    FOREIGN KEY (account_number) REFERENCES account(account_number)
);

INSERT INTO depositor VALUES ('Smith', 'A1');
INSERT INTO depositor VALUES ('Williams', 'A2');
INSERT INTO depositor VALUES ('Brown', 'A3');
INSERT INTO depositor VALUES ('Johnson', 'A4');


--  a. Find all customers of the bank who have an account but not a loan.
SELECT DISTINCT d.customer_name
FROM depositor d
WHERE d.customer_name NOT IN (
    SELECT b.customer_name
    FROM borrower b
);

-- b. Find the names of all customers who live on the same street and in the same city as “Smith”.
SELECT DISTINCT c.customer_name
FROM customer c
WHERE c.customer_street = (
    SELECT customer_street
    FROM customer
    WHERE customer_name = 'Smith'
)
AND c.customer_city = (
    SELECT customer_city
    FROM customer
    WHERE customer_name = 'Smith'
)
AND c.customer_name != 'Smith';

-- c. Find the names of all branches with customers who have an account in the bank and who live in “Harrison”.
SELECT DISTINCT a.branch_name
FROM account a
JOIN depositor d ON a.account_number = d.account_number
JOIN customer c ON d.customer_name = c.customer_name
WHERE c.customer_city = 'Harrison';