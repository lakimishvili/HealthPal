//
//  HomeView.swift
//  HealthPal
//
//  Created by LILIANA on 1/11/26.
//

import SwiftUI

struct HomeView: View {

    // MARK: - State
    @StateObject private var vm = HomeViewModel()
    @State private var showAllCategories = false
    @State private var searchText = ""
    @State private var showSearchSheet = false
    @State private var favoriteHospitalIds: Set<Int> = []
    @StateObject private var currentUser = CurrentUserManager.shared

    @State private var selectedDoctor: Doctor? = nil

    private let grid = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    // MARK: - Top Doctors Logic
    private var topRatedDoctor: Doctor? {
        vm.doctors.max { $0.rating < $1.rating }
    }

    private var mostReviewedDoctor: Doctor? {
        vm.doctors.max { ($0.reviewsCount ?? 0) < ($1.reviewsCount ?? 0) }
    }

    private var mostPatientsDoctor: Doctor? {
        vm.doctors.max { ($0.patientsCount ?? 0) < ($1.patientsCount ?? 0) }
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // MARK: - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hello, \(currentUser.user?.fullName ?? "Guest")")
                                .font(.caption)
                                .foregroundColor(.gray)

                            Text("Find your doctor")
                                .font(.headline)
                        }

                        Spacer()

                        NavigationLink(
                            destination: NotificationsView(viewModel: NotificationsViewModel(userId: currentUser.user?.id ?? 0))
                        ) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Search Bar
                    Button {
                        showSearchSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)

                            Text(
                                searchText.isEmpty
                                ? "Search doctor..."
                                : searchText
                            )
                            .foregroundColor(searchText.isEmpty ? .gray : .primary)

                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    // MARK: - Top Doctors Slider
                    if topRatedDoctor != nil ||
                        mostReviewedDoctor != nil ||
                        mostPatientsDoctor != nil {

                        TabView {
                            if let doctor = topRatedDoctor {
                                NavigationLink {
                                    DoctorDetailView(doctor: doctor)
                                } label: {
                                    TopDoctorCard(doctor: doctor, highlight: .topRated)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, 8)
                            }

                            if let doctor = mostReviewedDoctor {
                                NavigationLink {
                                    DoctorDetailView(doctor: doctor)
                                } label: {
                                    TopDoctorCard(doctor: doctor, highlight: .mostReviewed)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, 8)
                            }

                            if let doctor = mostPatientsDoctor {
                                NavigationLink {
                                    DoctorDetailView(doctor: doctor)
                                } label: {
                                    TopDoctorCard(doctor: doctor, highlight: .mostPatients)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, 8)
                            }
                        }
                        .frame(height: 180)
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                    }

                    // MARK: - Categories
                    HStack {
                        Text("Categories")
                            .font(.headline)

                        Spacer()

                        Button {
                            showAllCategories.toggle()
                        } label: {
                            Text(showAllCategories ? "Show Less" : "See All")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)

                    LazyVGrid(columns: grid, spacing: 16) {
                        let visibleCategories = showAllCategories
                            ? DoctorCategory.allCases
                            : Array(DoctorCategory.allCases.prefix(8))

                        ForEach(visibleCategories) { cat in
                            NavigationLink {
                                DoctorsListView(
                                    hospitalId: vm.selectedHospital?.id,
                                    initialCategory: cat
                                )
                            } label: {
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(cat.color.opacity(0.2))
                                        .frame(height: 60)
                                        .overlay(
                                            Image(systemName: cat.icon)
                                                .font(.title2)
                                                .foregroundColor(cat.color)
                                        )

                                    Text(cat.title)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground))
                                        .shadow(
                                            color: .black.opacity(0.03),
                                            radius: 5,
                                            x: 0,
                                            y: 2
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Nearby Hospitals
                    HStack {
                        Text("Top Medical Centers")
                            .font(.headline)

                        Spacer()

                        Button {
                            NotificationCenter.default.post(
                                name: .switchToHospitalsTab,
                                object: nil
                            )
                        } label: {
                            Text("See All")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(vm.hospitals) { hospital in
                                HospitalCard(
                                    hospital: hospital,
                                    userId: currentUser.user?.id ?? 0,
                                    isFavorite: favoriteHospitalIds.contains(hospital.id)
                                ) {
                                    vm.selectHospital(hospital)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationBarHidden(true)
            .onAppear {
                vm.load()
                loadFavoriteHospitals()
            }

            // MARK: - Search Sheet
            .sheet(isPresented: $showSearchSheet) {
                SearchDoctorsSheet(
                    doctors: vm.doctors,
                    searchText: $searchText
                ) { doctor in
                    showSearchSheet = false
                    selectedDoctor = doctor
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }

            if let doctor = selectedDoctor {
                NavigationLink(
                    destination: DoctorDetailView(doctor: doctor),
                    isActive: Binding(
                        get: { selectedDoctor != nil },
                        set: { isActive in
                            if !isActive { selectedDoctor = nil }
                        }
                    )
                ) {
                    EmptyView()
                }
            }
        }
    }

    // MARK: - Load Favorite Hospitals
    private func loadFavoriteHospitals() {
        guard let userId = currentUser.user?.id else { return }
        guard let url = URL(string: "http://localhost:3000/api/favorites/\(userId)/hospitals") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data,
                  let hospitals = try? JSONDecoder().decode([Hospital].self, from: data)
            else { return }

            DispatchQueue.main.async {
                favoriteHospitalIds = Set(hospitals.map { $0.id })
            }
        }.resume()
    }
}

#Preview {
    HomeView()
}
