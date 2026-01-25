//
//  SearchDoctorsSheet.swift
//  HealthPal
//
//  Created by LILIANA on 1/24/26.
//

import SwiftUI


struct SearchDoctorsSheet: View {

    let doctors: [Doctor]
    @Binding var searchText: String
    let onSelect: (Doctor) -> Void

    private var filteredDoctors: [Doctor] {
        guard !searchText.isEmpty else { return [] }
        return doctors.filter {
            $0.fullName.lowercased().contains(searchText.lowercased()) ||
            $0.category.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search doctor...", text: $searchText)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(14)
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(filteredDoctors) { doctor in
                            Button {
                                onSelect(doctor) 
                            } label: {
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: doctor.image ?? "")) { phase in
                                        if let image = phase.image {
                                            image.resizable().scaledToFill()
                                        } else {
                                            Color.gray
                                        }
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(doctor.fullName)
                                            .font(.subheadline)
                                        Text(doctor.category.capitalized)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Search Doctors")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
