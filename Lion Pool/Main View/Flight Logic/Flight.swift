//
//  Flight.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/7/23.
//

import Foundation

struct Flight: Codable, Identifiable{
    let id: UUID
    let userId: String
    let date: Date
    let airport: String
}

