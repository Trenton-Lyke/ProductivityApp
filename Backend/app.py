from db import db
from flask import Flask, json, request
from db import Course, User, Assignment

app = Flask(__name__)
db_filename = "cms.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(data, code=200):
    return json.dumps(data), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

@app.route("/api/courses/")
def get_courses():
    courses = []
    for course in Course.query.all():
        courses.append(course.serialize())
    return success_response({"courses": courses})

@app.route("/api/courses/", methods=["POST"])
def create_course():
    body = json.loads(request.data)
    new_course = Course(
        code=body.get('code'),
        name=body.get('name'),
        assignments = [],
        instructors = [],
        students = []
    )
    db.session.add(new_course)
    db.session.commit()
    return success_response(new_course.serialize(), 201)

@app.route("/api/courses/<int:course_id>/")
def get_course(course_id):
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course Not Found")
    return success_response(course.serialize())

@app.route("/api/courses/<int:course_id>/", methods=["DELETE"])
def delete_course(course_id):
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course Not Found")
    db.session.delete(course)
    db.session.commit()
    return success_response(course.serialize())

@app.route("/api/users/", methods=["POST"])
def create_user():
    body = json.loads(request.data)
    new_user = User(
        name=body.get('name'),
        netid=body.get('netid')
    )
    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)

@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User Not Found")
    return success_response(user.serialize())

@app.route("/api/courses/<int:course_id>/add/", methods=["POST"])
def add_user_to_course(course_id):
    body = json.loads(request.data)
    user_id = body.get('user_id')
    user_type = body.get('type')

    course = Course.query.filter_by(id=course_id).first()
    user = User.query.filter_by(id=user_id).first()
    if course is None:
        return failure_response("Course Not Found")
    if user is None:
        return failure_response("User Not Found")
    if user_type == "student":
        course.students.append(user)
    elif user_type == "instructor":
        course.instructors.append(user)
    else:
        return failure_response("Invalid user type")
    db.session.commit()
    return success_response(course.serialize())

@app.route("/api/courses/<int:course_id>/assignment/", methods=["POST"])
def create_assignment(course_id):
    body = json.loads(request.data)
    title = body.get('title')
    due_date = body.get('due_date')
    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course Not Found")
    new_assignment = Assignment(
        title=title,
        due_date=due_date,
        course_id=course_id
    )
    db.session.add(new_assignment)
    db.session.commit()
    return success_response(new_assignment.serialize(), 201)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)