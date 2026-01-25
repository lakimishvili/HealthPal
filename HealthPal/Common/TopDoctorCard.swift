//
//  TopDoctorCard 2.swift
//  HealthPal
//
//  Created by LILIANA on 1/15/26.
//
import SwiftUI

struct TopDoctorCard: View {
    let doctor: Doctor

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: doctor.imageUrl)) { phase in
                switch phase {
                case .empty:
                    Color(.systemGray4)
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Image(systemName: "person.crop.circle.badge.exclam")
                        .resizable()
                        .scaledToFit()
                        .padding(40)
                        .foregroundColor(.gray)
                @unknown default:
                    Color(.systemGray4)
                }
            }
            .frame(height: 180)
            .clipped()
            .cornerRadius(20)

            LinearGradient(
                colors: [.black.opacity(0.0), .black.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(20)

            VStack(alignment: .leading, spacing: 6) {
                Text("Top Doctor")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                Text(doctor.fullName)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Text(doctor.category)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
    }
}
