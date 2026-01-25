//
//  HospitalCardCompactView.swift
//  HealthPal
//
//  Created by LILIANA on 1/25/26.
//

import SwiftUI

struct HospitalCardCompactView: View {
    let hospital: Hospital
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: hospital.image ?? "")) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    Image(systemName: "building.2.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(16)
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hospital.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(hospital.type.capitalized)
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
