//
//  TimeSlot.swift
//  HealthPal
//
//  Created by LILIANA on 1/20/26.
//
import Foundation

struct TimeSlot: Decodable {
    let time: String
    let available: Bool
}

struct BookResponse: Decodable {
    let message: String
    let appointmentId: Int
}
