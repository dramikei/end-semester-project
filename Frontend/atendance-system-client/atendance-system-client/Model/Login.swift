//
//  Login.swift
//  atendance-system-client
//
//  Created by Raghav Vashisht on 01/11/19.
//  Copyright © 2019 Raghav Vashisht. All rights reserved.
//

import Foundation
struct Login: Codable {
    let result: String
    
    private enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}
