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