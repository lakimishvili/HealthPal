//
//  DoctorsListView.swift
//  HealthPal
//
//  Created by LILIANA on 1/17/26.
//

import SwiftUI
internal import Combine

struct DoctorsListView: View {
    let hospitalId: Int?
    let initialCategory: DoctorCategory?

    @State private var selectedCategory: DoctorCategory?
    @StateObject private var currentUser = CurrentUserManager.shared
    @State private var searchText = ""
    @State private var sortDescending = true

    @StateObject private var vm = DoctorsListViewModel()

    var body: some View {
        VStack(spacing: 16) {

            // MARK: - Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search doctor...", text: $searchText)
                    .foregroundColor(.primary)
                    .padding(.vertical, 10)
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal)

            // MARK: - Category Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    filterButton(title: "All", category: nil)

                    ForEach(DoctorCategory.allCases.filter { $0 != .other }) { cat in
                        filterButton(title: cat.title, category: cat)
                    }
                }
                .padding(.horizontal)
            }

            // MARK: - Header
            HStack {
                Text("\(sortedDoctors.count) Founds")
                    .font(.body)
                    .fontWeight(.medium)

                Spacer()

                Button {
                    sortDescending.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Text("Rating")
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            // MARK: - Doctors List
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(sortedDoctors) { doctor in
                        NavigationLink {
                            DoctorDetailView(doctor: doctor)
                        } label: {
                            DoctorCardView(
                                doctor: doctor,
                                userId: currentUser.user?.id ?? 0
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Doctors")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedCategory = initialCategory
            vm.loadHospitals()
            loadDoctors()
        }
        .onChange(of: selectedCategory) { _ in
            loadDoctors()
        }
        .onChange(of: searchText) { text in
            if text.isEmpty {
                loadDoctors()
            } else if let hospitalId {
                vm.search(hospitalId: hospitalId, query: text)
            } else {
                vm.searchAll(query: text)
            }
        }
    }

    // MARK: - Helpers

    private func filterButton(title: String, category: DoctorCategory?) -> some View {
        let isSelected = selectedCategory == category

        return Button {
            selectedCategory = category
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.black : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                )
                .cornerRadius(20)
        }
    }

    private var sortedDoctors: [Doctor] {
        vm.doctors.sorted {
            sortDescending ? $0.rating > $1.rating : $0.rating < $1.rating
        }
    }

    private func loadDoctors() {
        if let hospitalId {
            if let cat = selectedCategory {
                vm.loadByCategory(hospitalId: hospitalId, category: cat)
            } else {
                vm.loadAll(hospitalId: hospitalId)
            }
        } else {
            if let cat = selectedCategory {
                vm.loadAllByCategory(category: cat)
            } else {
                vm.loadAllDoctors()
            }
        }
    }
}
