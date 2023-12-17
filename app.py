from flask import Flask, render_template, request
from psycopg2 import connect, DatabaseError
from dotenv import load_dotenv
from psycopg2 import DatabaseError, connect

import os

load_dotenv()

app = Flask(__name__)


def execute_query(query, parameters=None, fetchall=False):
    conn = None
    try:
        conn = connect(
            dbname="universityDB",
            user="postgres",
            host="localhost",
            password=os.getenv("DB_PASSWORD")
        )
        with conn.cursor() as cursor:
            cursor.execute(query, parameters)
            conn.commit()
            if fetchall and cursor.description:
                return cursor.fetchall()
    except DatabaseError as e:
        print(e)
    finally:
        if conn:
            conn.close()


@app.route("/", methods=["GET"])
def render_index():
    return render_template("index.html")


# UNSAFE - Vulnerable to SQL injections
@app.route("/submit", methods=["POST"])
def submit():
    student_idnr = request.form.get("student_idnr")
    query = f"""
    SELECT courses.course_code, courses.name AS course_name, taken.grade
    FROM students
    JOIN taken ON students.idnr = taken.student_idnr
    JOIN courses ON taken.course_code = courses.course_code
    WHERE students.idnr = '{student_idnr}';
    """
    query_result = execute_query(query, fetchall=True)

    # Check if the student ID exists
    if not query_result:
        message = f"No data found for student with ID: {student_idnr}"
        return render_template("index.html", message=message, data=query_result)

    return render_template("index.html", data=query_result)


# SAFE - Safe against SQL injections
#  # Using parameterized queries (like %s) helps prevent SQL injection by automatically escaping and quoting the values.

# @app.route("/submit", methods=["POST"])
# def submit():
#     student_idnr = request.form.get("student_idnr")
#
#     # SQL query using parameterized query
#     query = """
#     SELECT courses.course_code, courses.name AS course_name, taken.grade
#     FROM students
#     JOIN taken ON students.idnr = taken.student_idnr
#     JOIN courses ON taken.course_code = courses.course_code
#     WHERE students.idnr = %s;
#     """
#
#     parameters = (student_idnr,)
#
#     query_result = execute_query(query, parameters, fetchall=True)
#     if query_result is None:
#         query_result = []
#     return render_template("index.html", data=query_result)


if __name__ == "__main__":
    app.run(debug=True)
