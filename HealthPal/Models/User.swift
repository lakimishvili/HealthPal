//
//  User.swift
//  HealthPal
//
//  Created by LILIANA on 1/25/26.
//
import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let fullName: String
    let email: String
    let phone: String?
    let gender: String?
    let personalId: String?
    let profileImageUrl: String?
}
