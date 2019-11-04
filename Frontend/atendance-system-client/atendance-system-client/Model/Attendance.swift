//
//  Attendance.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 31/10/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import Foundation
struct Attendance: Codable {
    let date: String
    let subject: String
    let ispresent: String
    let isOn: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case subject = "subject"
        case ispresent = "ispresent"
        case isOn = "isattendanceon"
    }
}
