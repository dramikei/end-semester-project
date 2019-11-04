//
//  Constants.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 31/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import Foundation

let loginURL = "http://localhost:5000/login"
let getAttendanceURL = "http://localhost:5000/getAttendance"
let markAttendanceURL = "http://localhost:5000/markAttendance"
let getTimeTableURL = "http://localhost:5000/timetable"

var userEnrolment = UserDefaults.standard.string(forKey: "Enrolment")
