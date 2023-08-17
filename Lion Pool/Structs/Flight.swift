//
//  Flight.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/7/23.
//

import Foundation
import FirebaseFirestore

protocol IdentifiableObjectType {
    var objectType: String { get }
}
struct Flight: Codable, Identifiable, Hashable, IdentifiableObjectType{
    let id: UUID
    let userId: String
    let airport: String
    let date: String
    let foundMatch: Bool
    var objectType: String {
        return "Flight"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func dateFromISOString(_ dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return dateFormatter.date(from: dateString)
    }
    

}

class sharedFlightData: ObservableObject{
    @Published var oldFlightDate = Date()
    @Published var oldAirport = ""
}

