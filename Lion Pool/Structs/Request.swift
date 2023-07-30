//
//  Request.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/29/23.
//

import Foundation

struct Request: Identifiable, Decodable{
    var id: UUID
    var senderFlightId: UUID
    var recieverFlightId: UUID
    var recieverUserId: String
    var requestDate: String
    var flightDate: String
    var pfp: String
    var name: String
    var status: String
    var airport: String
}
