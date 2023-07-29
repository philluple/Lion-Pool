//
//  Matches.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import Foundation
import Firebase

struct Match: Decodable, Identifiable{
    var id: UUID
    var flightId: UUID
    var date: String
    var pfp: String
    var userId: String
    var name: String
}
