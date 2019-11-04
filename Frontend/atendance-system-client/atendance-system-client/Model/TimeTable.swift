//
//  TimeTable.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 01/11/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import Foundation

struct TimeTable: Codable {
    let batch: String
    let day: String
    let hallName: String
    let subject: String
    let teacherName: String
    let time: String
    
    private enum CodingKeys: String, CodingKey {
        case batch = "batch"
        case day = "day"
        case hallName = "hallName"
        case subject = "subject"
        case teacherName = "teacherName"
        case time = "time"
    }
}
