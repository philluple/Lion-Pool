//
//  Matches.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/25/23.
//

import Foundation
import Firebase

struct Match: Decodable, Identifiable, Hashable{
    var id: UUID
    var flightId: UUID
    var matchFlightId: UUID
    var matchUserId: String
    var date: String
    var pfp: String
    var name: String
    var notify: Bool?
    var airport: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(flightId)
        hasher.combine(matchFlightId)
        hasher.combine(matchUserId)
        hasher.combine(date)
        hasher.combine(pfp)
        hasher.combine(name)
        hasher.combine(notify)
        hasher.combine(airport)
    }
}


