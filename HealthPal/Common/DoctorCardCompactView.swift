//
//  DoctorCardCompactView.swift
//  HealthPal
//
//  Created by LILIANA on 1/25/26.
//
import SwiftUI

struct DoctorCardCompactView: View {
    let doctor: Doctor
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: doctor.image ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(16)
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.fullName)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(doctor.category.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
