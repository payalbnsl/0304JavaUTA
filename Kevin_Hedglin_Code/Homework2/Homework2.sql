--Kevin Hedglin SQL LAB

--2.1

SELECT * FROM Employee;
SELECT * FROM Employee WHERE LASTNAME = 'King';
SELECT * FROM Employee WHERE FIRSTNAME = 'Andrew' AND REPORTSTO IS NULL;

--2.2
SELECT TITLE FROM Album ORDER BY TITLE DESC;
SELECT FIRSTNAME FROM Customer ORDER BY CITY ASC;

--2.3
INSERT INTO Genre (GENREID, NAME) VALUES (26, 'Action');
INSERT INTO Genre (GENREID, NAME) VALUES (27, 'Adventure');

SELECT * FROM GENRE;

INSERT INTO Employee (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, BIRTHDATE, HIREDATE, ADDRESS) VALUES (9, 'Smith', 'BOB', 'IT Staff', DATE'1967-12-17', DATE'2003-10-14', '68 Winthrop St.');
INSERT INTO Employee (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, BIRTHDATE, HIREDATE, ADDRESS) VALUES (10, 'Cooper', 'Randall', 'IT Staff', DATE'1974-1-14', DATE'2007-12-22', '4567 Walters St.');

SELECT * FROM EMPLOYEE;

INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, COMPANY, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, EMAIL) VALUES (60, 'Jerry', 'Robertson', 'Amazon', '512 bob street', 'Chicago', 'IL', 'USA', '56754', 'bob@gmail.com');
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, COMPANY, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, EMAIL) VALUES (61, 'Salim', 'Chesterton', 'Amazon', '513 jim street', 'Salt Lake City', 'UT', 'USA', '75654', 'daniel@gmail.com');

SELECT * FROM CUSTOMER;

--2.4
UPDATE Customer SET FIRSTNAME = 'Robert', LASTNAME = 'Walter' WHERE FIRSTNAME = 'Aaron' AND LASTNAME = 'Mitchell'; 
UPDATE Artist SET NAME = 'CCR' WHERE NAME = 'Creedence Clearwater Revival';

SELECT * FROM CUSTOMER WHERE FIRSTNAME = 'Robert';
SELECT * FROM ARTIST WHERE NAME = 'CCR';

--2.5
SELECT * FROM INVOICE WHERE BILLINGADDRESS LIKE 'T%';

--2.6
SELECT * FROM INVOICE WHERE TOTAL BETWEEN 15 AND 30;
SELECT * FROM EMPLOYEE WHERE HIREDATE BETWEEN DATE'2003-06-01' AND DATE'2004-03-01';

--2.7
ALTER TABLE INVOICE DISABLE CONSTRAINT FK_INVOICECUSTOMERID;
DELETE FROM CUSTOMER WHERE FIRSTNAME = 'Robert' AND LASTNAME = 'Walter';

SELECT * FROM CUSTOMER;

--3.1
CREATE OR REPLACE FUNCTION get_current_time
RETURN TIMESTAMP
IS
    current_time TIMESTAMP;
BEGIN
    SELECT LOCALTIMESTAMP
    INTO current_time
    FROM dual;
    RETURN current_time;
END;
/

DECLARE
    current_time TIMESTAMP;
BEGIN 
    current_time := get_current_time();
    DBMS_OUTPUT.PUT_LINE('Time:' || current_time);
END;
/

CREATE OR REPLACE FUNCTION get_mediatype_name_length(media_type_id IN NUMBER)
RETURN NUMBER
IS
    media_name VARCHAR2(100);
    media_name_length NUMBER;
BEGIN
    SELECT NAME INTO media_name
    FROM MEDIATYPE
    WHERE MEDIATYPEID = media_type_id;
    
    media_name_length := LENGTH(media_name);
    RETURN media_name_length;
END;
/

DECLARE
    name_length NUMBER;
BEGIN 
    name_length := get_mediatype_name_length(1);
    DBMS_OUTPUT.PUT_LINE('TEST: ' || name_length);
END;
/

--3.2
CREATE OR REPLACE FUNCTION get_avg_invoices
RETURN NUMBER
IS
    avg_invoices NUMBER;
BEGIN
    SELECT AVG(TOTAL) INTO avg_invoices
    FROM INVOICE;
    RETURN avg_invoices;
END;
/

DECLARE
    avg_invoices NUMBER;
BEGIN 
    avg_invoices := get_avg_invoices();
    DBMS_OUTPUT.PUT_LINE('TEST: ' || avg_invoices);
END;
/


CREATE OR REPLACE FUNCTION get_most_expensive_track
RETURN VARCHAR2
IS
    most_expensive VARCHAR2(100);
BEGIN
    SELECT * INTO most_expensive
    FROM (SELECT UNITPRICE 
        FROM TRACK ORDER BY UNITPRICE DESC)
    WHERE ROWNUM = 1;
    RETURN most_expensive;
END;
/

DECLARE
    most_expensive VARCHAR2(100);
BEGIN 
    most_expensive := get_most_expensive_track();
    DBMS_OUTPUT.PUT_LINE('TEST: ' || most_expensive);
END;
/

--3.3

CREATE OR REPLACE FUNCTION get_avg_invoiceline_price
RETURN NUMBER
IS
    avg_invoiceline_price NUMBER;
BEGIN
    SELECT AVG(UNITPRICE) INTO avg_invoiceline_price
    FROM INVOICELINE;
    RETURN avg_invoiceline_price;
END;
/

DECLARE
    avg_invoice_price NUMBER;
BEGIN 
    avg_invoice_price := get_avg_invoiceline_price();
    DBMS_OUTPUT.PUT_LINE('TEST: ' || avg_invoice_price);
END;
/

--3.4

CREATE OR REPLACE FUNCTION get_employees_born_after_1968
RETURN SYS_REFCURSOR
IS
    employees SYS_REFCURSOR;
BEGIN
    OPEN employees FOR
    SELECT FIRSTNAME, LASTNAME
    FROM EMPLOYEE
    WHERE BIRTHDATE > '01-JAN-69';
    return employees;
END;
/

SELECT get_employees_born_after_1968 FROM dual;

--4.1
--DBMS_SQL.RETURN_RESULT

CREATE OR REPLACE PROCEDURE employee_names
AS
    employees SYS_REFCURSOR;
BEGIN
    OPEN employees FOR
    SELECT FIRSTNAME, LASTNAME
    FROM EMPLOYEE;
    DBMS_SQL.RETURN_RESULT(employees);
END;
/

EXECUTE employee_names;

--4.2

CREATE OR REPLACE PROCEDURE turn_city_to(new_city IN VARCHAR2)
AS
BEGIN
    UPDATE EMPLOYEE
    SET CITY = new_city
    WHERE EMPLOYEEID = 1;
END;
/

EXECUTE turn_city_to('Seattle');


CREATE OR REPLACE PROCEDURE get_managers(employee_id IN NUMBER)
AS 
    employees SYS_REFCURSOR;
BEGIN
    
    OPEN employees FOR 
    SELECT FIRSTNAME, LASTNAME 
    FROM EMPLOYEE
    WHERE EMPLOYEEID = (SELECT REPORTSTO
                        FROM EMPLOYEE
                        WHERE EMPLOYEEID = employee_id);
    
    DBMS_SQL.RETURN_RESULT(employees);
END;
/

EXECUTE get_managers(4);

--4.3


CREATE OR REPLACE PROCEDURE get_name_and_company(customer_id IN NUMBER)
AS 
    customer_data SYS_REFCURSOR;
BEGIN
    
    OPEN customer_data FOR 
    SELECT FIRSTNAME, LASTNAME, COMPANY
    FROM CUSTOMER
    WHERE CUSTOMERID = customer_id;
    
    DBMS_SQL.RETURN_RESULT(customer_data);
END;
/

EXECUTE get_name_and_company(5);


--5

CREATE OR REPLACE PROCEDURE delete_invoice(invoice_id IN NUMBER)
AS 
BEGIN
    DELETE
    FROM INVOICELINE
    WHERE INVOICEID = invoice_id;
    DELETE
    FROM INVOICE
    WHERE INVOICEID = invoice_id;
END;
/

EXECUTE delete_invoice(5);
SELECT * FROM INVOICE;


CREATE OR REPLACE PROCEDURE insert_to_customer
AS 
BEGIN
    INSERT
    INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, ADDRESS, CITY, COUNTRY, EMAIL)
    VALUES(62, 'John', 'Locke', '5490 Bobbert street.' , 'Boston', 'USA', 'johnlocke@gmail.com');
END;
/

EXECUTE insert_to_customer;
SELECT * FROM CUSTOMER WHERE FIRSTNAME = 'John';

--6.1

CREATE OR REPLACE TRIGGER trigger_for_insert_to_employee
AFTER INSERT
ON EMPLOYEE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee inserted');
END;
/

INSERT INTO Employee (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, BIRTHDATE, HIREDATE, ADDRESS) VALUES (13, 'Franklins', 'Jesus', 'IT Staff', DATE'1945-12-17', DATE'2013-11-14', '43 RockyRoad Way');
commit;

CREATE OR REPLACE TRIGGER trigger_on_update_insert_album
AFTER UPDATE OR INSERT
ON ALBUM
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Album updated/inserted');
END;
/

INSERT INTO ALBUM (ALBUMID, TITLE, ARTISTID) VALUES (400, 'Song Title', 1);
commit;

CREATE OR REPLACE TRIGGER trigger_after_delete_customer
AFTER DELETE
ON CUSTOMER
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Customer deleted.');
END;
/

DELETE FROM CUSTOMER WHERE CUSTOMERID = 1;
commit;

--7.1

SELECT CUSTOMER.FIRSTNAME, CUSTOMER.LASTNAME, INVOICE.INVOICEID FROM CUSTOMER INNER JOIN INVOICE ON INVOICE.CUSTOMERID = CUSTOMER.CUSTOMERID;

--7.2

SELECT CUSTOMER.CUSTOMERID, CUSTOMER.FIRSTNAME, CUSTOMER.LASTNAME, INVOICE.INVOICEID, INVOICE.TOTAL FROM CUSTOMER FULL OUTER JOIN INVOICE ON INVOICE.CUSTOMERID = CUSTOMER.CUSTOMERID;

--7.3

SELECT ARTIST.NAME, ALBUM.TITLE FROM ARTIST RIGHT JOIN ALBUM ON ALBUM.ARTISTID = ARTIST.ARTISTID ORDER BY ARTIST.ARTISTID;

--7.4

SELECT * FROM ARTIST CROSS JOIN ALBUM ORDER BY ARTIST.NAME ASC;

--7.5

SELECT * FROM EMPLOYEE a, EMPLOYEE b WHERE a.REPORTSTO = b.EMPLOYEEID;