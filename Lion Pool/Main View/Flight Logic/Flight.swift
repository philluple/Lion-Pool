//
//  Flight.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/7/23.
//

import Foundation

struct Flight: Codable{
    let userId: String
    let date: Date
    let airport: String
}

extension User {    
    static var MOCK_FLIGHT = (id: NSUUID().uuidString, date: Date.now, airport: "JFK")
}
