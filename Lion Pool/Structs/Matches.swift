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
    var senderFlightId: UUID
    var recieverFlightId: UUID
    var recieverUserId: String
    var date: String
    var pfp: String
    var name: String
    
//    init(id: UUID, senderFlightId: UUID, recieverFlightId: UUID, recieverUserId: String, date: String, pfp: String, name: String){
//        self.id = id
//        self.senderFlightId = senderFlightId
//        self.recieverFlightId = recieverFlightId
//        self.recieverUserId = recieverUserId
//        self.date = date
//        self.pfp = pfp
//        self.name = name
//    }
    
}
