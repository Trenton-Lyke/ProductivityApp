import json

from db import Assignment, User, Course, db
from flask import Flask, request

app = Flask(__name__)
db_filename = "cms.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()


def success_response(data, code=200):
    """
    Formats successful response
    """
    return json.dumps(data), code


def failure_response(message, code=404):
    """
    Formats failure response
    """
    return json.dumps({"error": message}), code


# your routes here
@app.route("/")
@app.route("/api/courses/")
def get_courses():
    """
    Endpoint for getting all courses
    """
    return success_response({"courses": [c.serialize() for c in Course.query.all()]})


@app.route("/api/courses/", methods=["POST"])
def create_course():
    """
    Endpoint for creating a new course
    """
    body = json.loads(request.data)
    code = body.get("code", None)
    name = body.get("name", None)

    error = ""

    if code is None:
        error += "Missing code in request body. "

    if name is None:
        error += "Missing name in request body. "

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    new_course = Course(code=code, name=name)
    db.session.add(new_course)
    db.session.commit()
    return success_response(new_course.serialize(), 201)


@app.route("/api/courses/<int:course_id>/")
def get_course(course_id):
    """
    Endpoint for getting specific course
    """
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found")
    return success_response(course.serialize())


@app.route("/api/courses/<int:course_id>/", methods=["DELETE"])
def delete_course(course_id):
    """
    Endpoint for deleting course
    """
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found")
    db.session.delete(course)
    db.session.commit()
    return success_response(course.serialize())


@app.route("/api/users/", methods=["POST"])
def create_user():
    """
    Endpoint for creating a new user
    """
    body = json.loads(request.data)
    name = body.get("name", None)
    netid = body.get("netid", None)

    error = ""

    if name is None:
        error += "Missing name in request body. "

    if netid is None:
        error += "Missing netid in request body. "

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    new_user = User(name=name, netid=netid)
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)


@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    """
    Endpoint for getting specific user
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")
    return success_response(user.serialize())


@app.route("/api/courses/<int:course_id>/add/", methods=["POST"])
def add_user_to_course(course_id):
    body = json.loads(request.data)
    user_id = body.get("user_id", None)
    type = body.get("type", None)

    error = ""

    if user_id is None:
        error += "Missing user_id in request body. "

    if type is None:
        error += "Missing type in request body."
    elif type != "student" and type != "instructor":
        error += "type must be student or instructor"

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found")

    if type == "instructor":
        course.instructors.append(user)
    else:
        course.students.append(user)

    db.session.commit()
    return success_response(course.serialize())


@app.route("/api/courses/<int:course_id>/assignment/", methods=["POST"])
def add_assignment_to_course(course_id):
    body = json.loads(request.data)
    title = body.get("title", None)
    due_date = body.get("due_date", None)

    error = ""

    if title is None:
        error += "Missing title in request body. "

    if due_date is None:
        error += "Missing due_date in request body. "

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found")

    assignment = Assignment(title=title, due_date=due_date, course_id=course_id)
    db.session.add(assignment)
    db.session.commit()

    return success_response(assignment.serialize(), 201)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
