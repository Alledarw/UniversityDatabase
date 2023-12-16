from dotenv import load_dotenv
from flask import Flask, render_template, request
from psycopg2 import connect, DatabaseError
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


@app.route("/submit", methods=["POST"])
def submit():
    idnr = request.form.get("idnr")
    first_name = request.form.get("first_name")
    last_name = request.form.get("last_name")
    program_code = request.form.get("program_code")

    # SQL INJECTION - SAFE
    # Using parameterized queries (like %s) helps prevent SQL injection by automatically escaping and quoting the values.
    query = "INSERT INTO students (idnr, first_name, last_name, program_code) VALUES (%s, %s, %s, %s)"
    parameters = (idnr, first_name, last_name, program_code)

    # SQL INJECTION - UNSAFE
    # To test an SQL injection, try the following in any of the data fields in index.html: ' OR '1'='1
    # See if the SQL error message disappears. If it disappears it could be a sign that the site is vulnerable to an SQL injection attack.

    # query = (
    #    f"INSERT INTO students (idnr, first_name, last_name, program_code) "
    #    f"VALUES ('{idnr}', '{first_name}', '{last_name}', '{program_code}')"
    # )

    try:
        execute_query(query, parameters)
        message = "Student registered successfully!"
    except DatabaseError as e:
        print(e)
        message = "Error registering student. Please try again."

    return render_template("index.html", message=message)


if __name__ == "__main__":
    app.run(debug=True)
