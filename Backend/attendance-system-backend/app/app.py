import os
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime


############### Setup ###############

app = Flask(__name__)

project_dir = os.path.dirname(os.path.abspath(__file__))
database_file = "sqlite:///{}".format(os.path.join(project_dir, "attendance.db"))
app.config["SQLALCHEMY_DATABASE_URI"] = database_file
db = SQLAlchemy(app)


############### Models ###############

class User(db.Model):
    __tablename__ = 'user'
    enrolment = db.Column(db.String(20), nullable=False, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    password = db.Column(db.String(255), nullable=False)
    batch = db.Column(db.String(10))
    # timetable = db.relationship("TimeTable", backref="User")

    def __init__(self, enrolment, name, password, batch):
        self.enrolment = enrolment
        self.name = name
        self.password = password
        self.batch = batch
    def serialize(self):
        return {
            'enrolment': self.enrolment, 
            'name': self.name,
            'batch': self.batch
            # 'timetable':self.timetable
        }

class Attendance(db.Model):
    __tablename__ = 'attendance'
    id = db.Column(db.String(100), nullable=False, primary_key = True)
    enrolment = db.Column(db.String(20), nullable=False)
    date = db.Column(db.String(15), nullable = False)
    subject = db.Column(db.String(30), nullable = False)
    isattendanceon = db.Column(db.String(6), nullable = False)
    ispresent = db.Column(db.String(6), nullable = False)
    table_id = db.Column(db.String(10), db.ForeignKey('timetable.id'))

    def __init__(self,enrolment,date,subject,isattendanceon,ispresent,table_id):
        self.enrolment = enrolment
        self.date = date
        self.subject = subject
        self.isattendanceon = isattendanceon
        self.ispresent = ispresent
        self.table_id = table_id
    
    def serialize(self):
        return {
            'enrolment': self.enrolment,
            'date': self.date,
            'subject': self.subject,
            'isattendanceon': self.isattendanceon,
            'ispresent': self.ispresent,
            'table_id': self.table_id
        }

class TimeTable(db.Model):
    __tablename__ = 'timetable'
    id = db.Column(db.Integer, primary_key=True)
    day = db.Column(db.String(10), nullable = False)
    batch = db.Column(db.String(10))
    teacherName = db.Column(db.String(255), nullable = False)
    hallName = db.Column(db.String(40), nullable = False)
    time = db.Column(db.String(25), nullable = False)
    subject = db.Column(db.String(30), nullable = False)
    enrolment = db.Column(db.String(20), db.ForeignKey('user.enrolment'))
    # hall = db.relationship("LectureHall", backref="TimeTable")

    def __init__(self,day,batch,teacherName,hallName,time,subject):
        self.day = day
        self.batch = batch
        self.teacherName = teacherName
        self.hallName = hallName
        self.time = time
        self.subject = subject

    def serialize(self):
        return {
            'day': self.day, 
            'batch': self.batch,
            'teacherName': self.teacherName,
            'hallName': self.hallName,
            'time': self.time,
            'subject': self.subject
        }

class LectureHall(db.Model):
    __tablename__ = 'lecturehall'
    name = db.Column(db.String(40), primary_key = True)
    macAddress = db.Column(db.Text, nullable = False)
    table_id = db.Column(db.String(10), db.ForeignKey('timetable.id'))

    def __init__(self,name,address):
        self.name = name
        self.macAddress = address
    def serialize(self):
        return {
            'name': self.name,
            'macaddress': self.macAddress
        }

############### Routes ###############
# Routes required: getTimeTable(), login, markAttendance(), getAttendance(),

@app.route('/timetable', methods=['POST'])
def getTimeTable():
    json = request.json
    enrolment = json['enrolment']
    data = db.session.query(TimeTable).join(User, enrolment == User.enrolment).all()
    print("length: ",len(data))
    response = []
    for row in data:
        response.append(row.serialize())
    return jsonify({
        "timetables": response
        })


@app.route('/login', methods=['POST'])
def login():
    # TODO: add authorization
    json = request.json
    enrolment = json['enrolment']
    password = json['password']
    isValid = False
    data = db.session.query(User).filter(User.enrolment == enrolment).all()
    for user in data:
        if user.password == password:
            isValid = True
            break
    response = {
        "result": str(isValid)
    }
    return jsonify(response)


@app.route('/getAttendance', methods=['POST'])
def getAttendance():
    json = request.json
    enrolment = json['enrolment']
    subject = json['subject']
    data = db.session.query(Attendance).filter(Attendance.enrolment == enrolment).filter(Attendance.subject == subject).all()
    response = []
    for attendance in data:
        response.append(attendance.serialize())
    return jsonify({
        "attendances":response
        })

@app.route('/markAttendance', methods=['POST'])
def markAttendance():
    json = request.json
    enrolment = json['enrolment']
    macAddress = json['macaddress']
    subject = json['subject']
    date = datetime.now()
    day = date.strftime('%d')
    year = date.strftime('%Y')
    month = date.strftime('%m')
    today = "{}_{}_{}".format(year,month,day)
    timetable_id = 0
    isAttendanceOn = False
    isMacCorrect = False
    data = db.session.query(Attendance).filter(Attendance.enrolment == enrolment).filter(Attendance.subject == subject).filter(Attendance.date == today).filter(Attendance.isattendanceon == "True").all()
    
    for attendance in data:
        isAttendanceOn = True
        timetable_id = attendance.table_id
    if isAttendanceOn:
        data = db.session.query(LectureHall).filter(LectureHall.table_id == timetable_id).all()
        for hall in data:
            macaddress = hall.macAddress.split(";")
            for mac in macaddress:
                if macAddress == mac:
                    isMacCorrect = True
                else:
                    continue
    else:
        return jsonify({
            "result": "attendance not on."
        }), 403


    if isMacCorrect:
        #Finally, mark attendance
        try:
            db.session.query(Attendance).filter(Attendance.subject == subject).filter(Attendance.date == today).update({'ispresent':'True'})
            db.session.commit()
            return jsonify({
                "result": 'Success'
                }), 200
        except:
            return jsonify({
                'result': 'cannot mark attendance'
            }), 500
    else:
        return jsonify({
            "result": "wrong mac-address"
        }), 403

if __name__ == '__main__':
    app.run(debug=True)