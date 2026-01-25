//
//  CurrentUserManager.swift
//  HealthPal
//
//  Created by LILIANA on 1/25/26.
//

import Foundation
internal import Combine

final class CurrentUserManager: ObservableObject {
    static let shared = CurrentUserManager()

    @Published var user: User?

    private init() {}

    func loadCurrentUser() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "http://localhost:3000/users/me")
        else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else { return }

            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.user = user
                    UserDefaults.standard.set(user.id, forKey: "userId")
                    UserDefaults.standard.set(user.fullName, forKey: "userFullName")
                }
            } catch {
                print("Failed to decode current user:", error)
            }
        }.resume()
    }
}
