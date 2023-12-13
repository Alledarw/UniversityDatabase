-- Create basic_information View
CREATE VIEW basic_information AS
SELECT s.idnr, CONCAT(s.first_name, ' ', s.last_name) AS name, p.program_name AS program, b.name AS branch
FROM students s
JOIN programs p ON s.program_code = p.program_code
LEFT JOIN student_branches sb ON s.idnr = sb.student_idnr
LEFT JOIN branches b ON sb.branch_code = b.branch_code;

SELECT * FROM basic_information;

-- Create finished_courses View
CREATE VIEW finished_courses AS
SELECT t.student_idnr AS student, t.course_code AS course, t.grade, c.credits
FROM taken t
JOIN courses c ON t.course_code = c.course_code
WHERE t.grade IS NOT NULL;

SELECT * FROM finished_courses;

-- Create passed_courses View
CREATE VIEW passed_courses AS
SELECT t.student_idnr AS student, t.course_code AS course, c.credits
FROM taken t
JOIN courses c ON t.course_code = c.course_code
WHERE t.grade IN ('A', 'B', 'C', 'D', 'E');

SELECT * FROM passed_courses;

-- Create registrations View
CREATE VIEW registrations AS
SELECT r.student_idnr AS student, r.course_code AS course, 'registered' AS status
FROM registered r
UNION
SELECT w.student_idnr AS student, w.course_code AS course, 'waiting' AS status
FROM waiting_list w;

SELECT * FROM registrations;

-- Create unread_mandatory View
CREATE VIEW unread_mandatory AS
SELECT s.idnr AS student, mb.course_code AS course
FROM students s
JOIN mandatory_program mp ON s.program_code = mp.program_code
JOIN mandatory_branch mb ON mp.program_code = mb.program_code
WHERE NOT EXISTS (
    SELECT 1
    FROM taken t
    WHERE t.student_idnr = s.idnr AND t.course_code = mb.course_code
);

SELECT * FROM unread_mandatory;

-- Create course_queue_position View
CREATE VIEW course_queue_position AS
SELECT w.student_idnr AS student,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       CONCAT(c.name, ' (', c.course_code, ')') AS course,
       ROW_NUMBER() OVER (PARTITION BY w.course_code ORDER BY w.created_date) AS place,
       w.created_date
FROM waiting_list w
LEFT JOIN courses c ON w.course_code = c.course_code
LEFT JOIN students s ON w.student_idnr = s.idnr
WHERE c.is_opening = TRUE -- only opening registered, comment out if you want to include all
ORDER BY w.course_code, w.created_date;

SELECT * FROM course_queue_position;


-- FRONTEND, search by student number and get course and grade