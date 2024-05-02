import json
import datetime

from db import Assignment, User, Course, Timer, db
from sqlalchemy import func
from sqlalchemy.sql import text
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
    name = body.get("name", None)
    description = body.get("description", None)

    error = ""

    if name is None:
        error += "Missing name in request body. "

    if description is None:
        error += "Missing description in request body. "

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    new_course = Course(name=name, description=description)
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

    error = ""

    if name is None:
        error += "Missing name in request body. "

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    new_user = User(name=name)
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

    error = ""

    if user_id is None:
        error += "Missing user_id in request body. "

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found")

    course.users.append(user)

    db.session.commit()
    return success_response(course.serialize())


@app.route("/api/courses/<int:course_id>/assignment/", methods=["POST"])
def add_assignment_to_course(course_id):
    body = json.loads(request.data)
    name = body.get("name", None)
    description = body.get("description", None)
    due_date = body.get("due_date", None)
    done = body.get("done", None)

    error = ""

    if name is None:
        error += "Missing name in request body. "

    if description is None:
        error += "Missing description in request body. "

    if due_date is None:
        error += "Missing due_date in request body. "

    if done is None:
        error += "Missing done in request body. "

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    course = Course.query.filter_by(id=course_id).first()
    if course is None:
        return failure_response("Course not found")

    assignment = Assignment(
        name=name,
        description=description,
        due_date=due_date,
        done=done,
        course_id=course_id,
    )
    db.session.add(assignment)
    db.session.commit()

    return success_response(assignment.serialize(), 201)


@app.route("/api/timer/", methods=["POST"])
def add_timer_to_user():
    body = json.loads(request.data)
    elapsed_time = body.get("elapsed_time", None)
    hours = body.get("hours", None)
    minutes = body.get("minutes", None)
    seconds = body.get("seconds", None)
    date = body.get("date", None)
    user_id = body.get("user_id", None)

    error = ""

    if elapsed_time is None:
        error += "Missing elapsed_time in request body. "
    if hours is None:
        error += "Missing hours in request body. "
    if minutes is None:
        error += "Missing minutes in request body. "
    if seconds is None:
        error += "Missing seconds in request body. "
    if date is None:
        error += "Missing date in request body. "
    if user_id is None:
        error += "Missing user_id in request body. "

    error = error.strip()

    if error != "":
        return failure_response(error, 400)

    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")

    timer = Timer(
        elapsed_time=elapsed_time,
        hours=hours,
        minutes=minutes,
        seconds=seconds,
        date=date,
        user_id=user_id,
    )
    db.session.add(timer)
    db.session.commit()

    return success_response(timer.serialize(), 201)


@app.route("/api/timer/<int:user_id>/")
def get_timers(user_id):
    """
    Endpoint for getting timers from specific user
    """
    timers = Timer.query.filter_by(user_id=user_id).all()
    print(timers)
    if timers is None:
        return failure_response("User not found")
    return success_response([t.serialize() for t in timers])


@app.route("/api/timer/leader_board/<time_span>/")
def get_leader_board(time_span):
    """
    Endpoint for work time leader board
    """
    if (
        time_span != "all"
        and time_span != "day"
        and time_span != "week"
        and time_span != "month"
        and time_span != "year"
    ):
        return failure_response(
            f"The time_span must be all, day, week, month, or year not {time_span}",
            code=400,
        )

    leader_board = get_leader_board(time_span)

    if leader_board is None:
        return failure_response("No timers found")
    return success_response(
        [{"user_id": l.user_id, "total": l.total} for l in leader_board]
    )


@app.route("/api/timer/leader_board/<time_span>/<int:user_id>/")
def get_leader_board_position(time_span, user_id):
    """
    Endpoint for user's position in work time leader board
    """
    if (
        time_span != "all"
        and time_span != "day"
        and time_span != "week"
        and time_span != "month"
        and time_span != "year"
    ):
        return failure_response(
            f"The time_span must be all, day, week, month, or year not {time_span}",
            code=400,
        )

    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("User not found")

    leader_board = [l.user_id for l in get_leader_board(time_span)]

    if leader_board is None:
        return failure_response("No timers found")

    if user_id in leader_board:
        return success_response({"position": leader_board.index(user_id) + 1})
    else:
        return success_response({"position": len(leader_board) + 1})


def get_leader_board(time_span):
    """
    Helper function for getting work time leader board
    """
    query = db.session.query(Timer.user_id, func.sum(Timer.elapsed_time).label("total"))

    leader_board = []
    if time_span == "all":
        leader_board = query.group_by(Timer.user_id).order_by(text("total DESC")).all()
    else:
        min_date = datetime.datetime.now().timestamp()
        if time_span == "day":
            min_date -= 60 * 60 * 24
        elif time_span == "week":
            min_date -= 60 * 60 * 24 * 7
        elif time_span == "month":
            min_date -= 60 * 60 * 24 * 31
        elif time_span == "year":
            min_date -= 60 * 60 * 24 * 365
        leader_board = (
            query.filter(Timer.date >= min_date)
            .group_by(Timer.user_id)
            .order_by(text("total DESC"))
            .all()
        )

    return leader_board


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
