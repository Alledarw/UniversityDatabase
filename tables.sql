CREATE TABLE institutions (
  institution_code VARCHAR(10) PRIMARY KEY,
  institution_name VARCHAR(50)
);

CREATE TABLE programs (
  program_code VARCHAR(10) PRIMARY KEY,
  program_name VARCHAR(50)
);

CREATE TABLE institutions_programs_relations (
  institution_code VARCHAR(10) REFERENCES institutions(institution_code),
  program_code VARCHAR(10) REFERENCES programs(program_code),
  PRIMARY KEY (institution_code, program_code)
);

CREATE TABLE branches (
  branch_code VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50),
  program_code VARCHAR(10) REFERENCES programs(program_code)
);

CREATE TABLE courses (
  course_code VARCHAR(6) PRIMARY KEY,
  name VARCHAR(50),
  credits INT,
  is_opening BOOLEAN,
  is_ended BOOLEAN,
  institution_id VARCHAR(10) REFERENCES institutions(institution_code)
);

CREATE TABLE limited_courses (
  capacity INT,
  course_code VARCHAR(10) REFERENCES courses(course_code),
  PRIMARY KEY (course_code)
);

CREATE TABLE classifications (
  classified_code VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50)
);

CREATE TABLE classified (
  classified_code VARCHAR(10) REFERENCES classifications(classified_code),
  course_code VARCHAR(10) REFERENCES courses(course_code),
  PRIMARY KEY (classified_code, course_code)
);

CREATE TABLE students (
  idnr VARCHAR(10) PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  program_code VARCHAR(10) REFERENCES programs(program_code)
);

CREATE TABLE student_branches (
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  program_code VARCHAR(10) REFERENCES programs(program_code),
  branch_code VARCHAR(10) REFERENCES branches(branch_code),
  PRIMARY KEY (student_idnr, program_code, branch_code)
);

CREATE TABLE mandatory_program (
  program_code VARCHAR(10) REFERENCES programs(program_code),
  course_code VARCHAR(10) REFERENCES courses(course_code),
  PRIMARY KEY (program_code, course_code)
);

CREATE TABLE mandatory_branch (
  course_code VARCHAR(10) REFERENCES courses(course_code),
  program_code VARCHAR(10) REFERENCES programs(program_code),
  branch_code VARCHAR(10) REFERENCES branches(branch_code),
  PRIMARY KEY (course_code, program_code, branch_code)
);

CREATE TABLE recommended_branch (
  course_code VARCHAR(10) REFERENCES courses(course_code),
  program_code VARCHAR(10) REFERENCES programs(program_code),
  branch_code VARCHAR(10) REFERENCES branches(branch_code),
  PRIMARY KEY (course_code, program_code, branch_code)
);

CREATE TABLE registered (
  course_code VARCHAR(10) REFERENCES courses(course_code),
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  PRIMARY KEY (course_code, student_idnr)
);

CREATE TABLE taken (
  taken_code SERIAL PRIMARY KEY,
  course_code VARCHAR(10) REFERENCES courses(course_code),
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  grade VARCHAR(1)
);

CREATE TABLE student_credit (
  taken_code SERIAL REFERENCES taken(taken_code),
  score INT,
  PRIMARY KEY (taken_code)
);

CREATE TABLE course_prerequisites (
  course_code VARCHAR(10) REFERENCES courses(course_code),
  prerequisites_course VARCHAR(6) REFERENCES courses(course_code),
  PRIMARY KEY (course_code, prerequisites_course)
);

CREATE TABLE waiting_list (
  course_code VARCHAR(10) REFERENCES courses(course_code),
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  created_date TIMESTAMP,
  PRIMARY KEY (course_code, student_idnr)
);

/* Test */
SELECT * FROM waiting_list

INSERT INTO institutions (institution_code, institution_name)
VALUES 
    ('ABC123', 'University of ABC'),
    ('DEF456', 'XYZ College'),
    ('GHI789', 'Institute of Technology');

INSERT INTO programs (program_code, program_name)
VALUES 
    ('P001', 'Computer Science'),
    ('P002', 'Engineering'),
    ('P003', 'Business Administration');
    
INSERT INTO programs (program_code, program_name)
VALUES 
    ('P001', 'Computer Science'),
    ('P002', 'Electrical Engineering'),
    ('P003', 'Psychology'),
    ('P004', 'Business Administration'),
    ('P005', 'Mechanical Engineering');

INSERT INTO institutions_programs_relations (institution_code, program_code)
VALUES 
    ('ABC123', 'P001'), -- University of ABC offers Computer Science
    ('DEF456', 'P002'), -- XYZ College offers Electrical Engineering
    ('GHI789', 'P004'), -- Institute of Technology offers Business Administration
    ('ABC123', 'P003'), -- University of ABC offers Psychology
    ('GHI789', 'P005'); -- Institute of Technology offers Mechanical Engineering 

INSERT INTO courses (course_code, name, credits, is_opening, is_ended, institution_id)
VALUES 
    ('C001', 'Introduction to Programming', 3, true, false, 'ABC123'), 
    ('C002', 'Database Management', 4, true, false, 'DEF456'), 
    ('C003', 'Business Ethics', 3, true, false, 'GHI789'), 
    ('C004', 'Mechanical Design', 4, true, false, 'ABC123');

INSERT INTO limited_courses (capacity, course_code)
VALUES 
    (30, 'C001'), -- Introduction to Programming has a capacity of 30 students
    (25, 'C002'), -- Database Management has a capacity of 25 students
    (40, 'C003'); -- Business Ethics has a capacity of 40 students

INSERT INTO classifications (classified_code, name)
VALUES 
    ('CL001', 'Class A'),
    ('CL002', 'Class B'),
    ('CL003', 'Class C'),
    ('CL004', 'Class D'),
    ('CL005', 'Class E');

INSERT INTO classified (classified_code, course_code)
VALUES 
    ('CL001', 'C001'), -- Course C001 is classified as Class A
    ('CL002', 'C002'), -- Course C002 is classified as Class B
    ('CL003', 'C003'), -- Course C003 is classified as Class C
    ('CL004', 'C004'), -- Course C004 is classified as Class D
    ('CL005', 'C001'); -- Course C001 is also classified as Class E

INSERT INTO students (idnr, first_name, last_name, program_code)
VALUES 
    ('S001', 'Alice', 'Smith', 'P001'), -- Alice Smith in the Computer Science program
    ('S002', 'Bob', 'Johnson', 'P002'), -- Bob Johnson in the Electrical Engineering program
    ('S003', 'Eva', 'Garcia', 'P003'), -- Eva Garcia in the Psychology program
    ('S004', 'David', 'Brown', 'P004'), -- David Brown in the Business Administration program
    ('S005', 'Sophia', 'Lee', 'P002'); -- Sophia Lee in the Electrical Engineering program


INSERT INTO student_branches (student_idnr, program_code, branch_code)
VALUES 
    ('S001', 'P001', 'B001'), -- Alice Smith in Computer Science, branch B001
    ('S002', 'P002', 'B002'), -- Bob Johnson in Electrical Engineering, branch B002
    ('S003', 'P003', 'B003'), -- Eva Garcia in Psychology, branch B003
    ('S004', 'P004', 'B004'), -- David Brown in Business Administration, branch B004
    ('S005', 'P002', 'B005'); -- Sophia Lee in Electrical Engineering, branch B005
     
     

INSERT INTO mandatory_program (program_code, course_code)
VALUES 
    ('P001', 'C001'), -- Computer Science program requires Introduction to Programming
    ('P002', 'C002'), -- Electrical Engineering program requires Database Management
    ('P003', 'C003'), -- Psychology program requires Business Ethics
    ('P004', 'C004'), -- Business Administration program requires Mechanical Design
    ('P001', 'C004'); -- Computer Science program also requires Mechanical Design

INSERT INTO mandatory_branch (course_code, program_code, branch_code)
VALUES 
    ('C001', 'P001', 'B001'), -- Introduction to Programming is mandatory in Computer Science, branch B001
    ('C002', 'P002', 'B002'), -- Database Management is mandatory in Electrical Engineering, branch B002
    ('C003', 'P003', 'B003'), -- Business Ethics is mandatory in Psychology, branch B003
    ('C004', 'P004', 'B004'), -- Mechanical Design is mandatory in Business Administration, branch B004
    ('C001', 'P001', 'B005'); -- Introduction to Programming is also mandatory in Computer Science, branch B005

INSERT INTO recommended_branch (course_code, program_code, branch_code)
VALUES 
    ('C001', 'P001', 'B001'), -- Introduction to Programming is recommended in Computer Science, branch B001
    ('C002', 'P002', 'B002'), -- Database Management is recommended in Electrical Engineering, branch B002
    ('C003', 'P003', 'B003'), -- Business Ethics is recommended in Psychology, branch B003
    ('C004', 'P004', 'B004'), -- Mechanical Design is recommended in Business Administration, branch B004
    ('C001', 'P001', 'B005'); -- Introduction to Programming is recommended in Computer Science, branch B005

INSERT INTO registered (course_code, student_idnr)
VALUES 
    ('C001', 'S001'), -- Alice Smith (S001) is registered for Introduction to Programming (C001)
    ('C002', 'S002'), -- Bob Johnson (S002) is registered for Database Management (C002)
    ('C003', 'S003'), -- Eva Garcia (S003) is registered for Business Ethics (C003)
    ('C004', 'S004'), -- David Brown (S004) is registered for Mechanical Design (C004)
    ('C001', 'S005'); -- Sophia Lee (S005) is registered for Introduction to Programming (C001)

INSERT INTO taken (course_code, student_idnr, grade)
VALUES 
    ('C001', 'S001', 'A'), -- Alice Smith (S001) took Introduction to Programming (C001) and got an 'A'
    ('C002', 'S002', 'B'), -- Bob Johnson (S002) took Database Management (C002) and got a 'B'
    ('C003', 'S003', 'B+'), -- Eva Garcia (S003) took Business Ethics (C003) and got a 'B+'
    ('C004', 'S004', 'A-'), -- David Brown (S004) took Mechanical Design (C004) and got an 'A-'
    ('C001', 'S005', 'B'); -- Sophia Lee (S005) took Introduction to Programming (C001) and got a 'B'

INSERT INTO student_credit (taken_code, score)
VALUES 
    (1, 85), -- The taken_code 1 (assuming it refers to a specific taken record) has a score of 85
    (2, 72), -- The taken_code 2 has a score of 72
    (3, 90), -- The taken_code 3 has a score of 90
    (4, 88), -- The taken_code 4 has a score of 88
    (5, 75); -- The taken_code 5 has a score of 75
    
INSERT INTO course_prerequisites (course_code, prerequisites_course)
VALUES 
    ('C002', 'C001'), -- Database Management (C002) has a prerequisite of Introduction to Programming (C001)
    ('C003', 'C002'), -- Business Ethics (C003) has a prerequisite of Database Management (C002)
    ('C004', 'C001'), -- Mechanical Design (C004) has a prerequisite of Introduction to Programming (C001)
    ('C004', 'C002'); -- Mechanical Design (C004) also has a prerequisite of Database Management (C002)


INSERT INTO waiting_list (course_code, student_idnr, created_date)
VALUES 
    ('C001', 'S002', '2023-01-15 09:00:00'), -- Bob Johnson (S002) is on the waiting list for Introduction to Programming (C001) on January 15, 2023, at 9:00 AM
    ('C002', 'S003', '2023-02-20 11:30:00'), -- Eva Garcia (S003) is on the waiting list for Database Management (C002) on February 20, 2023, at 11:30 AM
    ('C003', 'S004', '2023-03-10 13:45:00'), -- David Brown (S004) is on the waiting list for Business Ethics (C003) on March 10, 2023, at 1:45 PM
    ('C001', 'S005', '2023-04-05 10:15:00'); -- Sophia Lee (S005) is on the waiting list for Introduction to Programming (C001) on April 5, 2023, at 10:15 AM


















