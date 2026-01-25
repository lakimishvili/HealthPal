//
//  CurrentUser.swift
//  HealthPal
//
//  Created by LILIANA on 1/25/26.
//
import Foundation
internal import Combine

final class CurrentUser: ObservableObject {
    static let shared = CurrentUser()
    
    @Published var userId: Int?
    @Published var authToken: String?
    @Published var email: String?
    
    private init() {}
    
    var isLoggedIn: Bool { userId != nil && authToken != nil }
}
