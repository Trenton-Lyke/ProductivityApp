from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

association_table = db.Table(
    "association",
    db.Model.metadata,
    db.Column("user_id", db.Integer, db.ForeignKey("user.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("course.id")),
)


# your classes here
class User(db.Model):
    """
    User Model
    """

    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    timers = db.relationship("Timer", cascade="delete")
    courses = db.relationship(
        "Course", secondary=association_table, back_populates="users"
    )

    def __init__(self, **kwargs):
        """
        Initialize User Entry
        """
        self.name = kwargs.get("name")

    def simple_serialize(self):
        """
        Serialize User object without courses
        """
        return {"id": self.id, "name": self.name}

    def serialize(self):
        """
        Serialize User object
        """
        return {
            **self.simple_serialize(),
            "courses": [c.simple_serialize() for c in self.courses],
            "timers": [t.simple_serialize() for t in self.timers],
        }


class Course(db.Model):
    """
    Course Model
    """

    __tablename__ = "course"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    assignments = db.relationship("Assignment", cascade="delete")
    users = db.relationship(
        "User", secondary=association_table, back_populates="courses"
    )

    def __init__(self, **kwargs):
        """
        Initialize Course Object
        """
        self.name = kwargs.get("name")
        self.description = kwargs.get("description")

    def simple_serialize(self):
        """
        Serialize Course without assignments or users
        """
        return {"id": self.id, "name": self.name, "description": self.description}

    def serialize(self):
        """
        Serialize Course
        """
        return {
            **self.simple_serialize(),
            "assignments": [a.simple_serialize() for a in self.assignments],
            "users": [u.simple_serialize() for u in self.users],
        }


class Assignment(db.Model):
    """
    Assignment Model
    """

    __tablename__ = "assignment"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    due_date = db.Column(db.Integer, nullable=False)
    done = db.Column(db.Boolean, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("course.id"), nullable=False)
    course = db.relationship("Course", foreign_keys="Assignment.course_id")

    def __init__(self, **kwargs):
        """
        Initialize Assignment Object
        """
        self.name = kwargs.get("name")
        self.description = kwargs.get("description")
        self.due_date = kwargs.get("due_date")
        self.done = kwargs.get("done")
        self.course_id = kwargs.get("course_id")

    def simple_serialize(self):
        """
        Serialize Assignment without course
        """
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "due_date": self.due_date,
            "done": self.done,
        }

    def serialize(self):
        """
        Serialize Assignment
        """
        return {**self.simple_serialize(), "course": self.course.simple_serialize()}


class Timer(db.Model):
    """
    Timer Model
    """

    __tablename__ = "timer"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    elapsed_time = db.Column(db.Integer, nullable=False)
    hours = db.Column(db.Integer, nullable=False)
    minutes = db.Column(db.Integer, nullable=False)
    seconds = db.Column(db.Integer, nullable=False)
    date = db.Column(db.Integer, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    user = db.relationship("User", foreign_keys="Timer.user_id")

    def __init__(self, **kwargs):
        """
        Initialize Assignment Object
        """
        self.elapsed_time = kwargs.get("elapsed_time")
        self.hours = kwargs.get("hours")
        self.minutes = kwargs.get("minutes")
        self.seconds = kwargs.get("seconds")
        self.date = kwargs.get("date")
        self.user_id = kwargs.get("user_id")

    def simple_serialize(self):
        """
        Serialize Assignment without course
        """
        return {
            "id": self.id,
            "elapsed_time": self.elapsed_time,
            "hours": self.hours,
            "minutes": self.minutes,
            "seconds": self.seconds,
            "date": self.date,
        }

    def serialize(self):
        """
        Serialize Assignment
        """
        return {**self.simple_serialize(), "user": self.user.simple_serialize()}
