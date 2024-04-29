from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

course_user_association = db.Table(
    'course_user',
    db.Column('course_id', db.Integer, db.ForeignKey('course.id')),
    db.Column('user_id', db.Integer, db.ForeignKey('user.id'))
)

class Course(db.Model):
    __tablename__ = "course"
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)
    assignments = db.relationship('Assignment')
    students = db.relationship('User', secondary=course_user_association)

    def __init__(self, **kwargs):
      self.code = kwargs.get("code", "")
      self.name = kwargs.get("name", "")

    def serialize(self):
      return {
        "id": self.id,
        "code": self.code,
        "name": self.name,
        "assignments": [assignment.serialize() for assignment in self.assignments],  
        "students": [student.serialize() for student in self.students]
      }

class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    netid = db.Column(db.String, nullable=False)
    courses = db.relationship('Course', secondary=course_user_association)

    def __init__(self, **kwargs):
      self.name = kwargs.get("name", "")
      self.netid = kwargs.get("netid", "")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "netid": self.netid,
            "courses": [course.serialize() for course in self.courses]
        }

class Assignment(db.Model):
    __tablename__ = "assignment"
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    due_date = db.Column(db.Integer, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey('course.id'), nullable=False)

    def __init__(self, **kwargs):
      self.title = kwargs.get("title", "")
      self.due_date = kwargs.get("due_date", 0)

    def serialize(self):
      return {
        "id": self.id,
        "title": self.title,
        "due_date": self.due_date,
        "course": {
          "id": self.course_id,
          "code": Course.query.get(self.course_id).code,
          "name": Course.query.get(self.course_id).name
        }
      }

class Timer(db.model):
    __tablename__ = "timer"
    id = db.Column(db.Integer, primary_key)
    time = db.Column(db.Integer, nullable=False)

    def __init__(self, **kwargs):
        self.time = kwargs.get("time", 0)

    def serialize(self):
        return {
            "id": self.id,
            "time": self.time
        }