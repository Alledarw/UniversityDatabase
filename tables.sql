CREATE TABLE institutions (
  institution_id VARCHAR(10) PRIMARY KEY,
  institution_name VARCHAR(50)
);

CREATE TABLE programs (
  program_id VARCHAR(10) PRIMARY KEY,
  program_name VARCHAR(50)
);

CREATE TABLE institutions_programs_relations (
  institution_id VARCHAR(10) REFERENCES institutions(institution_id),
  program_id VARCHAR(10) REFERENCES programs(program_id),
  PRIMARY KEY (institution_id, program_id)
);

CREATE TABLE branches (
  branch_id VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50),
  program_id VARCHAR(10) REFERENCES programs(program_id)
);

CREATE TABLE courses (
  course_id VARCHAR(6) PRIMARY KEY,
  name VARCHAR(50),
  credits INT,
  is_opening BOOLEAN,
  is_ended BOOLEAN,
  institution_id VARCHAR(10) REFERENCES institutions(institution_id)
);

CREATE TABLE limited_courses (
  capacity INT,
  course_id VARCHAR(10) REFERENCES courses(course_id),
  PRIMARY KEY (course_id)
);

CREATE TABLE classifications (
  classified_id VARCHAR(10) PRIMARY KEY,
  name VARCHAR(50)
);

CREATE TABLE classified (
  classified_id VARCHAR(10) REFERENCES classifications(classified_id),
  course_id VARCHAR(10) REFERENCES courses(course_id),
  PRIMARY KEY (classified_id, course_id)
);

CREATE TABLE students (
  idnr VARCHAR(10) PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  program_id VARCHAR(10) REFERENCES programs(program_id)
);

CREATE TABLE student_branches (
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  program_id VARCHAR(10) REFERENCES programs(program_id),
  branch_id VARCHAR(10) REFERENCES branches(branch_id),
  PRIMARY KEY (student_idnr, program_id, branch_id)
);

CREATE TABLE mandatory_program (
  program_id VARCHAR(10) REFERENCES programs(program_id),
  course_id VARCHAR(10) REFERENCES courses(course_id),
  PRIMARY KEY (program_id, course_id)
);

CREATE TABLE mandatory_branch (
  course_id VARCHAR(10) REFERENCES courses(course_id),
  program_id VARCHAR(10) REFERENCES programs(program_id),
  branch_id VARCHAR(10) REFERENCES branches(branch_id),
  PRIMARY KEY (course_id, program_id, branch_id)
);

CREATE TABLE recommended_branch (
  course_id VARCHAR(10) REFERENCES courses(course_id),
  program_id VARCHAR(10) REFERENCES programs(program_id),
  branch_id VARCHAR(10) REFERENCES branches(branch_id),
  PRIMARY KEY (course_id, program_id, branch_id)
);

CREATE TABLE registered (
  course_id VARCHAR(10) REFERENCES courses(course_id),
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  PRIMARY KEY (course_id, student_idnr)
);

CREATE TABLE taken (
  taken_id SERIAL PRIMARY KEY,
  course_id VARCHAR(10) REFERENCES courses(course_id),
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  grade VARCHAR(1)
);

CREATE TABLE student_credit (
  taken_id SERIAL REFERENCES taken(taken_id),
  score INT,
  PRIMARY KEY (taken_id)
);

CREATE TABLE course_prerequisites (
  course_id VARCHAR(10) REFERENCES courses(course_id),
  prerequisites_course VARCHAR(6) REFERENCES courses(course_id),
  PRIMARY KEY (course_id, prerequisites_course)
);

CREATE TABLE waiting_list (
  course_id VARCHAR(10) REFERENCES courses(course_id),
  student_idnr VARCHAR(10) REFERENCES students(idnr),
  created_date TIMESTAMP,
  PRIMARY KEY (course_id, student_idnr)
);

/* Test */
SELECT * FROM waiting_list