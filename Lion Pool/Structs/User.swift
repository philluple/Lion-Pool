//
//  User.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/6/23.
//

import Foundation
import UIKit

struct User: Identifiable, Codable{
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    let UNI: String
    let pfpLocation: String
}
