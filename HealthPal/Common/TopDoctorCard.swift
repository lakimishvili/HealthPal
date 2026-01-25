//
//  TopDoctorCard 2.swift
//  HealthPal
//
//  Created by LILIANA on 1/15/26.
//
import SwiftUI

struct TopDoctorCard: View {
    let doctor: Doctor
    let highlight: DoctorHighlightType

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            AsyncImage(url: URL(string: doctor.image ?? "")) { phase in
                switch phase {
                case .empty:
                    Color(.systemGray4)
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Color(.systemGray4)
                @unknown default:
                    Color(.systemGray4)
                }
            }
            .frame(height: 180)
            .clipped()
            .cornerRadius(20)

            LinearGradient(
                colors: [.black.opacity(0.0), .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(20)

            VStack(alignment: .leading, spacing: 6) {

                HStack(spacing: 6) {
                    Image(systemName: highlight.icon)
                        .font(.caption)
                    Text(highlight.title)
                        .font(.caption.bold())
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())

                Text(doctor.fullName)
                    .font(.title3.bold())
                    .foregroundColor(.white)

                Text(highlight.subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding()
        }
    }
}











