//
//  HealthPalApp.swift
//  HealthPal
//
//  Created by LILIANA on 1/11/26.
//

import SwiftUI

@main
struct HealthPalApp: App {
    init() {
        if UserDefaults.standard.string(forKey: "authToken") != nil {
            CurrentUserManager.shared.loadCurrentUser()
        }
        FavoritesManager.shared.loadFavorites(userId: UserDefaults.standard.integer(forKey: "userId"))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
