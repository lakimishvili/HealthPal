//
//  Hospital.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//

import Foundation

struct Hospital: Identifiable, Decodable {
    let id: Int
    let name: String
    let type: String
    let address: String
    let image: String?
    let rating: Double
    let working_hours: String?
    let created_at: String?    
}
