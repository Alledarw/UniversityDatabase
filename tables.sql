------------------------------- CREATING TABLES ---------------------------------------

CREATE TABLE classifications (
  classified_code VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50)
);

CREATE TABLE classified (
  classified_code VARCHAR(10) REFERENCES classifications(classified_code),
  course_code VARCHAR(10) REFERENCES courses(course_code),
  PRIMARY KEY (classified_code, course_code)
);

CREATE TABLE branches (
  branch_code VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50),
  program_code VARCHAR(10) REFERENCES programs(program_code)
);

CREATE TABLE limited_courses (
  capacity INT,
  course_code VARCHAR(10) REFERENCES courses(course_code),
  PRIMARY KEY (course_code)
);

CREATE TABLE course_prerequisites (
  course_code VARCHAR(10) REFERENCES courses(course_code),
  prerequisites_course VARCHAR(6) REFERENCES courses(course_code),
  PRIMARY KEY (course_code, prerequisites_course)
);

CREATE TABLE courses (
  course_code VARCHAR(6) PRIMARY KEY,
  name VARCHAR(50),
  credits INT,
  is_opening BOOLEAN,
  is_ended BOOLEAN,
  institution_code VARCHAR(10) REFERENCES institutions(institution_code)
);

CREATE TABLE institutions (
  institution_code VARCHAR(10) PRIMARY KEY,
  institution_name VARCHAR(50)
);

CREATE TABLE institutions_programs_relations (
  institution_code VARCHAR(10) REFERENCES institutions(institution_code),
  program_code VARCHAR(10) REFERENCES programs(program_code),
  PRIMARY KEY (institution_code, program_code)
);

CREATE TABLE programs (
  program_code VARCHAR(10) PRIMARY KEY,
  program_name VARCHAR(50)
);

CREATE TABLE mandatory_branch (
  course_code VARCHAR(10) REFERENCES courses(course_code),
  program_code VARCHAR(10) REFERENCES programs(program_code),
  branch_code VARCHAR(10) REFERENCES branches(branch_code),
  PRIMARY KEY (course_code, program_code, branch_code)
);

CREATE TABLE mandatory_program (
  program_code VARCHAR(10) REFERENCES programs(program_code),
  course_code VARCHAR(10) REFERENCES courses(course_code),
  PRIMARY KEY (program_code, course_code)
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

CREATE TABLE student_credit (
  taken_id SERIAL REFERENCES taken(taken_id),
  score INT,
  PRIMARY KEY (taken_id)
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

CREATE TABLE taken (
  taken_id SERIAL PRIMARY KEY,
  course_code VARCHAR(10) REFERENCES courses(course_code),
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  grade VARCHAR(1)
);

CREATE TABLE waiting_list (
  course_code VARCHAR(10) REFERENCES courses(course_code),
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  created_date TIMESTAMP,
  PRIMARY KEY (course_code, student_idnr)
);


/* Test */
SELECT * FROM students;

---------------------------------- INSERT SAMPLE DATA-----------------------------------

-- Institutions
INSERT INTO institutions (institution_code, institution_name) VALUES
  ('INST-101', 'Computer Science Institution'),
  ('INST-102', 'Electrical Engineering Institution'),
  ('INST-103', 'Mechanical Engineering Institution');

-- Programs
INSERT INTO programs (program_code, program_name) VALUES
  ('PRO-201', 'Bachelor of Software Engineering'),
  ('PRO-202', 'Bachelor of Electrical Systems'),
  ('PRO-203', 'Bachelor of Mechanical Design');

-- Insert data into the institutions_programs_relations table
INSERT INTO institutions_programs_relations (institution_code, program_code)
VALUES
  ('INST-101', 'PRO-201'),
  ('INST-102', 'PRO-202'),
  ('INST-103', 'PRO-203');

-- Branches
INSERT INTO branches (branch_code, name, program_code)
VALUES
  ('BR-301', 'Software Development', 'PRO-201'),
  ('BR-302', 'Electrical Circuits', 'PRO-202'),
  ('BR-303', 'Mechanical Systems', 'PRO-201'),
  ('BR-304', 'Robotics', 'PRO-203'),
  ('BR-305', 'Power Systems', 'PRO-202');

-- Courses
INSERT INTO courses (course_code, name, credits, is_opening, is_ended, institution_code) VALUES
  ('C-401', 'Algorithm Design', 100, TRUE, FALSE, 'INST-101'),
  ('C-402', 'Power Electronics', 100, TRUE, FALSE, 'INST-102'),
  ('C-403', 'Mechanics 101', 100, TRUE, FALSE, 'INST-103'),
  ('C-404', 'Database Systems', 100, TRUE, FALSE, 'INST-101'),
  ('C-405', 'Control Systems', 100, TRUE, FALSE, 'INST-102'),
  ('C-406', 'Thermal Engineering', 100, TRUE, FALSE, 'INST-103');

-- Insert data into the classifications and classified tables
INSERT INTO classifications (classified_code, name) VALUES
    ('MATH', 'mathematical courses'),
    ('RESEARCH', 'research courses'),
    ('SEMINAR', 'seminar courses');

INSERT INTO classified (classified_code, course_code) VALUES
    ('MATH', 'C-401'),
    ('RESEARCH', 'C-402'),
    ('SEMINAR', 'C-403'),
    ('MATH', 'C-404'),
    ('RESEARCH', 'C-405'),
    ('SEMINAR', 'C-406');

-- Limited courses limit 5 students
INSERT INTO limited_courses (capacity, course_code)
VALUES
  (5,'C-401'),
  (5,'C-403'),
  (5,'C-404');

-- Course prerequisites
INSERT INTO course_prerequisites (course_code, prerequisites_course) VALUES
    ('C-403', 'C-401'),
    ('C-403', 'C-402');

-- Students
INSERT INTO students (idnr, first_name, last_name, program_code) VALUES
    ('STD2001', 'John', 'Doe', 'PRO-201'),
    ('STD2002', 'Jane', 'Smith', 'PRO-202'),
    ('STD2003', 'Bob', 'Johnson', 'PRO-203'),
    ('STD2004', 'Alice', 'Williams', 'PRO-201'),
    ('STD2005', 'Charlie', 'Brown', 'PRO-202'),
    ('STD2006', 'Eva', 'Miller', 'PRO-203'),
    ('STD2007', 'Michael', 'Jones', 'PRO-201'),
    ('STD2008', 'Olivia', 'Davis', 'PRO-202'),
    ('STD2009', 'Samuel', 'Taylor', 'PRO-203'),
    ('STD2010', 'Sophia', 'Anderson', 'PRO-201'),
    ('STD2011', 'David', 'Wilson', 'PRO-203'),
    ('STD2012', 'Emma', 'Moore', 'PRO-201'),
    ('STD2013', 'Ryan', 'Jackson', 'PRO-202'),
    ('STD2014', 'Ava', 'White', 'PRO-203'),
    ('STD2015', 'William', 'Smith', 'PRO-201'),
    ('STD2016', 'Isabella', 'Thomas', 'PRO-202'),
    ('STD2017', 'Liam', 'Brown', 'PRO-203'),
    ('STD2018', 'Mia', 'Clark', 'PRO-201'),
    ('STD2019', 'Ethan', 'Hall', 'PRO-202'),
    ('STD2020', 'Sophie', 'Lewis', 'PRO-203');

-- Student branches
INSERT INTO student_branches (student_idnr, program_code, branch_code) VALUES
    ('STD2001', 'PRO-201', 'BR-301'), ('STD2002', 'PRO-202', 'BR-302'),
    ('STD2003', 'PRO-203', 'BR-304'), ('STD2004', 'PRO-201', 'BR-301'),
    ('STD2005', 'PRO-202', 'BR-302'), ('STD2006', 'PRO-203', 'BR-304'),
    ('STD2007', 'PRO-201', 'BR-301'), ('STD2008', 'PRO-202', 'BR-302'),
    ('STD2009', 'PRO-203', 'BR-304'), ('STD2010', 'PRO-201', 'BR-301'),
    ('STD2011', 'PRO-202', 'BR-302'), ('STD2012', 'PRO-203', 'BR-304'),
    ('STD2013', 'PRO-201', 'BR-301'), ('STD2014', 'PRO-202', 'BR-302'),
    ('STD2015', 'PRO-203', 'BR-304'), ('STD2016', 'PRO-201', 'BR-301'),
    ('STD2017', 'PRO-202', 'BR-302'), ('STD2018', 'PRO-203', 'BR-304'),
    ('STD2019', 'PRO-201', 'BR-301'), ('STD2020', 'PRO-202', 'BR-302');


--------------------------------- TESTING QUERIES ------------------------------------------------

-- Query 1: Two branches with the same name but on different programs
SELECT branch_code, name, program_code, COUNT(*)
FROM branches
GROUP BY branch_code, name, program_code
HAVING COUNT(*) > 1;

-- Query 2: A student who has not taken any courses
SELECT s.idnr, s.first_name, s.last_name
FROM students s
LEFT JOIN taken t ON s.idnr = t.student_idnr
WHERE t.taken_id IS NULL;

-- Query 3: A student who has only received failing grades
SELECT s.idnr, s.first_name, s.last_name
FROM students s
INNER JOIN taken t ON s.idnr = t.student_idnr
WHERE t.grade = 'U';

-- Query 4: A student who has not chosen any branch
SELECT s.idnr, s.first_name, s.last_name
FROM students s
LEFT JOIN student_branches sb ON s.idnr = sb.student_idnr
WHERE sb.student_idnr IS NULL;

-- Query 5: A waiting list can only exist for limited courses
SELECT w.course_code, w.student_idnr, c.course_code
FROM waiting_list w
LEFT JOIN limited_courses c ON w.course_code = c.course_code
WHERE c.course_code IS NULL;

-- Query 6: A course prerequisite must be a course that exists
SELECT cp.course_code, cp.prerequisites_course, c.course_code AS prerequisites_exist
FROM course_prerequisites cp
LEFT JOIN courses c ON cp.prerequisites_course = c.course_code
WHERE c.course_code IS NULL;

-- Query 7: A student cannot be registered for a course and on the waiting list simultaneously
SELECT r.course_code, r.student_idnr
FROM registered r
INNER JOIN waiting_list w ON r.course_code = w.course_code AND r.student_idnr = w.student_idnr;
