//
//  HospitalsFavoritesList.swift
//  HealthPal
//
//  Created by LILIANA on 1/18/26.
//
import SwiftUI

struct HospitalsFavoritesList: View {
    let userId: Int
    @StateObject private var vm = FavoritesViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(vm.favoriteHospitals) { hospital in
                    HospitalCard(hospital: hospital, userId: userId, isFavorite: true)
                        .padding(.horizontal)
                        .onTapGesture {
                            showNativeSheet(for: hospital)
                        }
                }
            }
            .padding(.top)
        }
        .onAppear { vm.loadFavoriteHospitals(for: userId) }
    }

    private func showNativeSheet(for hospital: Hospital) {
        let sheetVC = FavoritesBottomSheetViewController(
            userId: userId,
            favorite: .hospital(hospital)
        )
        sheetVC.onRemove = { fav in
            if case let .hospital(h) = fav {
                vm.favoriteHospitals.removeAll { $0.id == h.id }
                removeHospitalAPI(h)
            }
        }
        presentSheet(sheetVC)
    }

    private func removeHospitalAPI(_ hospital: Hospital) {
        guard let url = URL(string: "http://localhost:3000/api/favorites/remove/hospital") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["user_id": userId, "hospital_id": hospital.id])
        URLSession.shared.dataTask(with: request).resume()
    }

    private func presentSheet(_ vc: UIViewController) {
        guard let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first else { return }
        rootVC.present(vc, animated: true)
    }
}
