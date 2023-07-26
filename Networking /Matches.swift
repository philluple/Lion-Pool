//
//  Matches.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import Foundation
import Firebase

struct match: Decodable{
    var date: String
    var pfp: String
    var userId: String
    var name: String
}
