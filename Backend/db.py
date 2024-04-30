from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

student_association_table = db.Table(
    "student_association",
    db.Model.metadata,
    db.Column("user_id", db.Integer, db.ForeignKey("user.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("course.id")),
)

instructor_association_table = db.Table(
    "instructor_association",
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
    netid = db.Column(db.String, nullable=False)
    student_courses = db.relationship(
        "Course", secondary=student_association_table, back_populates="students"
    )
    instructor_courses = db.relationship(
        "Course", secondary=instructor_association_table, back_populates="instructors"
    )

    def __init__(self, **kwargs):
        """
        Initialize User Entry
        """
        self.name = kwargs.get("name")
        self.netid = kwargs.get("netid")

    def simple_serialize(self):
        """
        Serialize User object without courses
        """
        return {"id": self.id, "name": self.name, "netid": self.netid}

    def serialize(self):
        """
        Serialize User object
        """
        return {
            **self.simple_serialize(),
            "courses": [c.simple_serialize() for c in self.student_courses]
            + [c.simple_serialize() for c in self.instructor_courses],
        }


class Course(db.Model):
    """
    Course Model
    """

    __tablename__ = "course"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    code = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)
    assignments = db.relationship("Assignment", cascade="delete")
    instructors = db.relationship(
        "User",
        secondary=instructor_association_table,
        back_populates="instructor_courses",
    )
    students = db.relationship(
        "User", secondary=student_association_table, back_populates="student_courses"
    )

    def __init__(self, **kwargs):
        """
        Initialize Course Object
        """
        self.code = kwargs.get("code")
        self.name = kwargs.get("name")

    def simple_serialize(self):
        """
        Serialize Course without assignments, instructors, or students
        """
        return {"id": self.id, "code": self.code, "name": self.name}

    def serialize(self):
        """
        Serialize Course
        """
        return {
            **self.simple_serialize(),
            "assignments": [a.simple_serialize() for a in self.assignments],
            "instructors": [i.simple_serialize() for i in self.instructors],
            "students": [s.simple_serialize() for s in self.students],
        }


class Assignment(db.Model):
    """
    Assignment Model
    """

    __tablename__ = "assignment"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    title = db.Column(db.String, nullable=False)
    due_date = db.Column(db.Integer, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("course.id"), nullable=False)
    course = db.relationship("Course", foreign_keys="Assignment.course_id")

    def __init__(self, **kwargs):
        """
        Initialize Assignment Object
        """
        self.title = kwargs.get("title")
        self.due_date = kwargs.get("due_date")
        self.course_id = kwargs.get("course_id")

    def simple_serialize(self):
        """
        Serialize Assignment without course
        """
        return {"id": self.id, "title": self.title, "due_date": self.due_date}

    def serialize(self):
        """
        Serialize Assignment
        """
        return {**self.simple_serialize(), "course": self.course.simple_serialize()}
