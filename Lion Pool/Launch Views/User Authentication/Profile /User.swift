//
//  User.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import Foundation

struct User: Identifiable, Codable{
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    let UNI: String
    let phone: String
}

extension User {
    static var MOCK_USER = (id: NSUUID().uuidString, firstname: "Phillip", lastname: "Le", email: "pnl2111@columbia.edu", UNI: "pnl2111")
}
