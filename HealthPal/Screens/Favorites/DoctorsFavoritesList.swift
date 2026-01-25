//
//  Untitled.swift
//  HealthPal
//
//  Created by LILIANA on 1/18/26.
//
import SwiftUI

struct DoctorsFavoritesList: View {
    let userId: Int
    @StateObject private var vm = FavoritesViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(vm.favoriteDoctors) { doctor in
                    DoctorCardView(doctor: doctor, userId: userId)
                        .padding(.horizontal)
                        .onTapGesture {
                            showNativeSheet(for: doctor)
                        }
                }
            }
            .padding(.top)
        }
        .onAppear { vm.loadFavoriteDoctors(for: userId) }
    }

    private func showNativeSheet(for doctor: Doctor) {
        let sheetVC = FavoritesBottomSheetViewController(
            userId: userId,
            favorite: .doctor(doctor)
        )
        sheetVC.onRemove = { fav in
            if case let .doctor(d) = fav {
                vm.favoriteDoctors.removeAll { $0.id == d.id }
                removeDoctorAPI(d)
            }
        }
        presentSheet(sheetVC)
    }

    private func removeDoctorAPI(_ doctor: Doctor) {
        guard let url = URL(string: "http://localhost:3000/api/favorites/remove") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["user_id": userId, "doctor_id": doctor.id])
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
