//
//  FavoritesManager.swift
//  HealthPal
//
//  Created by LILIANA on 1/24/26.
//
import Foundation
internal import Combine

final class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published private(set) var favoriteDoctorIDs: Set<Int> = []

    private init() {}

    func loadFavorites(userId: Int) {
        guard let url = URL(string: "http://localhost:3000/api/favorites/\(userId)/doctors") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print("Failed to load favorite IDs:", error ?? "")
                return
            }

            do {
                let ids = try JSONDecoder().decode([Int].self, from: data)
                DispatchQueue.main.async {
                    self.favoriteDoctorIDs = Set(ids)
                }
            } catch {
                print("Failed to decode favorite IDs:", error)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON:", jsonString)
                }
            }
        }.resume()
    }
    
    // MARK: - Load favorite doctors (full objects)
    func loadFavoriteDoctors(userId: Int, completion: @escaping ([Doctor]) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/favorites/\(userId)/favoriteDoctors") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print("Failed to load favorite doctors:", error ?? "")
                DispatchQueue.main.async { completion([]) }
                return
            }

            do {
                let doctors = try JSONDecoder().decode([Doctor].self, from: data)
                DispatchQueue.main.async {
                    completion(doctors)
                }
            } catch {
                print("Failed to decode favorite doctors:", error)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON:", jsonString)
                }
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }


    // MARK: - Toggle favorite (IDs only)
    func toggleDoctorFavorite(_ doctorId: Int, userId: Int) {
        if favoriteDoctorIDs.contains(doctorId) {
            removeFavorite(doctorId, userId: userId)
        } else {
            addFavorite(doctorId, userId: userId)
        }
    }

    // MARK: - Add favorite
    private func addFavorite(_ doctorId: Int, userId: Int) {
        guard let url = URL(string: "http://localhost:3000/api/favorites/add") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "user_id": userId,
            "doctor_id": doctorId
        ])

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.favoriteDoctorIDs.insert(doctorId)
            }
        }.resume()
    }

    // MARK: - Remove favorite
    private func removeFavorite(_ doctorId: Int, userId: Int) {
        guard let url = URL(string: "http://localhost:3000/api/favorites/remove/doctor") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "user_id": userId,
            "doctor_id": doctorId
        ])

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.favoriteDoctorIDs.remove(doctorId)
            }
        }.resume()
    }
}
