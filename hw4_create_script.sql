-- ============================================================
-- COMPANY database: schema + seed data
-- Works on MySQL, PostgreSQL, and SQL Server (standard SQL).
--
-- EMPLOYEE and DEPARTMENT reference each other (DNO <-> MGRSSN),
-- and EMPLOYEE references itself (SUPERSSN). To avoid ordering
-- problems, tables are created first, data is loaded, and the
-- foreign keys are added at the end.
-- ============================================================
 
-- ---------- Tables ----------
 
CREATE TABLE EMPLOYEE (
    FNAME      VARCHAR(15)   NOT NULL,
    MINIT      CHAR(1),
    LNAME      VARCHAR(15)   NOT NULL,
    SSN        CHAR(9)       NOT NULL,
    BDATE      DATE,
    ADDRESS    VARCHAR(30),
    SEX        CHAR(1),
    SALARY     DECIMAL(10,2),
    SUPERSSN `  CHAR(9),
    DNO        INT           NOT NULL,
    CONSTRAINT PK_EMPLOYEE PRIMARY KEY (SSN)
);
 
CREATE TABLE DEPARTMENT (
    DNAME         VARCHAR(15) NOT NULL,
    DNUMBER       INT         NOT NULL,
    MGRSSN        CHAR(9)     NOT NULL,
    MGRSTARTDATE  DATE,
    CONSTRAINT PK_DEPARTMENT PRIMARY KEY (DNUMBER),
    CONSTRAINT UQ_DEPARTMENT_DNAME UNIQUE (DNAME)
);
 
CREATE TABLE DEPT_LOCATIONS (
    DNUMBER    INT         NOT NULL,
    DLOCATION  VARCHAR(15) NOT NULL,
    CONSTRAINT PK_DEPT_LOCATIONS PRIMARY KEY (DNUMBER, DLOCATION)
);
 
CREATE TABLE PROJECT (
    PNAME      VARCHAR(15) NOT NULL,
    PNUMBER    INT         NOT NULL,
    PLOCATION  VARCHAR(15),
    DNUM       INT         NOT NULL,
    CONSTRAINT PK_PROJECT PRIMARY KEY (PNUMBER),
    CONSTRAINT UQ_PROJECT_PNAME UNIQUE (PNAME)
);
 
CREATE TABLE WORKS_ON (
    ESSN   CHAR(9)      NOT NULL,
    PNO    INT          NOT NULL,
    HOURS  DECIMAL(3,1),
    CONSTRAINT PK_WORKS_ON PRIMARY KEY (ESSN, PNO)
);
 
CREATE TABLE DEPENDENT (
    ESSN            CHAR(9)     NOT NULL,
    DEPENDENT_NAME  VARCHAR(15) NOT NULL,
    SEX             CHAR(1),
    BDATE           DATE,
    RELATIONSHIP    VARCHAR(8),
    CONSTRAINT PK_DEPENDENT PRIMARY KEY (ESSN, DEPENDENT_NAME)
);
 
-- ---------- Seed data ----------
 
INSERT INTO EMPLOYEE (FNAME, MINIT, LNAME, SSN, BDATE, ADDRESS, SEX, SALARY, SUPERSSN, DNO) VALUES
('John',     'B', 'Smith',   '123456789', '1965-01-09', '731 Fondren, Houston, TX',  'M', 30000, '333445555', 5),
('Franklin', 'T', 'Wong',    '333445555', '1955-12-08', '638 Voss, Houston, TX',     'M', 40000, '888665555', 5),
('Alicia',   'J', 'Zelaya',  '999887777', '1968-07-19', '3321 Castle, Spring, TX',   'F', 25000, '987654321', 4),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire, TX',   'F', 43000, '888665555', 4),
('Ramesh',   'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble, TX',  'M', 38000, '333445555', 5),
('Joyce',    'A', 'English', '453453453', '1972-07-31', '5631 Rice, Houston, TX',    'F', 25000, '333445555', 5),
('Ahmad',    'V', 'Jabbar',  '987987987', '1969-03-29', '980 Dallas, Houston, TX',   'M', 25000, '987654321', 4),
('James',    'E', 'Borg',    '888665555', '1937-11-10', '450 Stone, Houston, TX',    'M', 55000, NULL,        1);
 
INSERT INTO DEPARTMENT (DNAME, DNUMBER, MGRSSN, MGRSTARTDATE) VALUES
('Research',       5, '333445555', '1988-05-22'),
('Administration', 4, '987654321', '1995-01-01'),
('Headquarters',   1, '888665555', '1981-06-19');
 
INSERT INTO DEPT_LOCATIONS (DNUMBER, DLOCATION) VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');
 
INSERT INTO PROJECT (PNAME, PNUMBER, PLOCATION, DNUM) VALUES
('ProductX',        1,  'Bellaire',  5),
('ProductY',        2,  'Sugarland', 5),
('ProductZ',        3,  'Houston',   5),
('Computerization', 10, 'Stafford',  4),
('Reorganization',  20, 'Houston',   1),
('Newbenefits',     30, 'Stafford',  4);
 
INSERT INTO WORKS_ON (ESSN, PNO, HOURS) VALUES
('123456789', 1,  32.5),
('123456789', 2,  7.5),
('666884444', 3,  40.0),
('453453453', 1,  20.0),
('453453453', 2,  20.0),
('333445555', 2,  10.0),
('333445555', 3,  10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, NULL);
 
INSERT INTO DEPENDENT (ESSN, DEPENDENT_NAME, SEX, BDATE, RELATIONSHIP) VALUES
('333445555', 'Alice',     'F', '1986-04-05', 'DAUGHTER'),
('333445555', 'Theodore',  'M', '1983-10-25', 'SON'),
('333445555', 'Joy',       'F', '1958-05-03', 'SPOUSE'),
('987654321', 'Abner',     'M', '1942-02-28', 'SPOUSE'),
('123456789', 'Michael',   'M', '1988-01-04', 'SON'),
('123456789', 'Alice',     'F', '1988-12-30', 'DAUGHTER'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'SPOUSE');
 
-- ---------- Foreign keys ----------
 
ALTER TABLE EMPLOYEE
    ADD CONSTRAINT FK_EMPLOYEE_SUPER FOREIGN KEY (SUPERSSN) REFERENCES EMPLOYEE (SSN);
 
ALTER TABLE EMPLOYEE
    ADD CONSTRAINT FK_EMPLOYEE_DEPT FOREIGN KEY (DNO) REFERENCES DEPARTMENT (DNUMBER);
 
ALTER TABLE DEPARTMENT
    ADD CONSTRAINT FK_DEPARTMENT_MGR FOREIGN KEY (MGRSSN) REFERENCES EMPLOYEE (SSN);
 
ALTER TABLE DEPT_LOCATIONS
    ADD CONSTRAINT FK_DEPTLOC_DEPT FOREIGN KEY (DNUMBER) REFERENCES DEPARTMENT (DNUMBER);
 
ALTER TABLE PROJECT
    ADD CONSTRAINT FK_PROJECT_DEPT FOREIGN KEY (DNUM) REFERENCES DEPARTMENT (DNUMBER);
 
ALTER TABLE WORKS_ON
    ADD CONSTRAINT FK_WORKSON_EMP  FOREIGN KEY (ESSN) REFERENCES EMPLOYEE (SSN);
 
ALTER TABLE WORKS_ON
    ADD CONSTRAINT FK_WORKSON_PROJ FOREIGN KEY (PNO)  REFERENCES PROJECT (PNUMBER);
 
ALTER TABLE DEPENDENT
    ADD CONSTRAINT FK_DEPENDENT_EMP FOREIGN KEY (ESSN) REFERENCES EMPLOYEE (SSN);