//
//  FavoritesViewModel.swift
//  HealthPal
//
//  Created by LILIANA on 1/18/26.
//

import SwiftUI
internal import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    
    @Published var favoriteDoctors: [Doctor] = []
    @Published var favoriteHospitals: [Hospital] = []
    @Published var isLoadingDoctors: Bool = false
    @Published var isLoadingHospitals: Bool = false
    @Published var errorMessage: String?
    @StateObject private var currentUser = CurrentUserManager.shared
    
    private let baseURL = "http://localhost:3000/api/favorites"

    func loadFavoriteDoctors(for userId: Int) {
        FavoritesManager.shared.loadFavoriteDoctors(userId: userId) { [weak self] doctors in
            self?.favoriteDoctors = doctors
        }
    }

    // MARK: - Load Favorite Hospitals
    func loadFavoriteHospitals(for userId: Int) {
        guard let userId = currentUser.user?.id else { return }
        guard let url = URL(string: "http://localhost:3000/api/favorites/\(userId)/hospitals") else { return }
        
        isLoadingHospitals = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            Task { @MainActor in
                self.isLoadingHospitals = false
                
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    print(self.errorMessage!)
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    print(self.errorMessage!)
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON from favorites/hospitals:", jsonString)
                }
                
                do {
                    let hospitals = try JSONDecoder().decode([Hospital].self, from: data)
                    self.favoriteHospitals = hospitals
                } catch {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                    print(self.errorMessage!)
                    
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        print("JSON object:", json)
                    }
                }
            }
        }.resume()
    }

    
    // MARK: - Refresh All Favorites
    func refreshAll(for userId: Int) {
        loadFavoriteDoctors(for: userId)
        loadFavoriteHospitals(for: userId)
    }
}
