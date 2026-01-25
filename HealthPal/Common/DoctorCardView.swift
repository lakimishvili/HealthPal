//
//  DoctorCardView.swift
//  HealthPal
//
//  Created by LILIANA on 1/17/26.
//
import SwiftUI
internal import Combine

struct DoctorCardView: View {
    let doctor: Doctor
    let userId: Int

    @State private var isAdding: Bool = false
    @State private var isFavorite: Bool = false
    @State private var cancellable: AnyCancellable?
    @StateObject private var currentUser = CurrentUserManager.shared


    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: doctor.image ?? "")) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray.opacity(0.4))
                }
            }
            .frame(width: 96, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(doctor.fullName)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.black)
                            .font(.title3)
                    }
                    .disabled(isAdding)
                }

                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(height: 1)

                Text(doctor.category.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(doctor.hospitalName ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        Text(String(format: "%.1f", doctor.rating))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(width: 1, height: 14)

                    Text("\(doctor.reviewsCount ?? 0) Reviews")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()
                }
            }

            Spacer()
        }
        .padding()
        .frame(height: 150)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
        .padding(.horizontal)
        .onAppear {
            isFavorite = FavoritesManager.shared.favoriteDoctorIDs.contains(doctor.id)

            cancellable = FavoritesManager.shared.$favoriteDoctorIDs
                .receive(on: DispatchQueue.main)
                .sink { favorites in
                    isFavorite = favorites.contains(doctor.id)
                }
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }

    // MARK: - Favorites
    private func toggleFavorite() {
        guard !isAdding else { return }
        guard let userId = currentUser.user?.id else { return }

        isAdding = true
        FavoritesManager.shared.toggleDoctorFavorite(doctor.id, userId: userId)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAdding = false
        }
    }
}
