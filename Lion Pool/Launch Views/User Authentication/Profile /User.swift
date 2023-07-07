//
//  User.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import Foundation

struct User: Identifiable, Codable{
    let id: String
    let fullname: String
    let email: String
}

extension User {
    static var MOCK_USER = (id: NSUUID().uuidString, fullname: "Phillip Le", email: "pnl2111@columbia.edu")
}
