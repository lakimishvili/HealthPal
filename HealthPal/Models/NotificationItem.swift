//
//  Untitled.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//
import Foundation

enum NotificationType: String, Decodable {
    case success
    case cancelled
    case changed
}

struct NotificationItem: Identifiable, Decodable {
    let id: Int
    let message: String
    let createdAt: Date
    var read: Bool

    enum CodingKeys: String, CodingKey {
        case id, message, read
        case createdAt = "created_at"
    }
}
