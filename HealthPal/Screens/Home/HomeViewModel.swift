//
//  HomeViewModel.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//

import Foundation
internal import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var hospitals: [Hospital] = []
    @Published var selectedHospital: Hospital?
    @Published var categories: [String] = []
    @Published var doctors: [Doctor] = []

    @Published var isLoading = false
    @Published var error: String?

    func load() {
        fetchHospitals()
    }

    func fetchHospitals() {
        isLoading = true
        APIService.shared.fetchHospitals { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let hospitals):
                    self?.hospitals = hospitals
                    self?.selectedHospital = hospitals.first
                    if let first = hospitals.first {
                        self?.fetchCategories(for: first.id)
                        self?.fetchDoctors(for: first.id)
                    }
                case .failure(let err):
                    self?.error = err.localizedDescription
                }
            }
        }
    }

    func selectHospital(_ hospital: Hospital) {
        selectedHospital = hospital
        fetchCategories(for: hospital.id)
        fetchDoctors(for: hospital.id)
    }

    func fetchCategories(for hospitalId: Int) {
        APIService.shared.fetchHospitalCategories(hospitalId: hospitalId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cats):
                    self?.categories = cats
                case .failure(let err):
                    self?.error = err.localizedDescription
                }
            }
        }
    }

    func fetchDoctors(for hospitalId: Int) {
        APIService.shared.fetchDoctors(hospitalId: hospitalId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let docs):
                    self?.doctors = docs
                case .failure(let err):
                    self?.error = err.localizedDescription
                }
            }
        }
    }
}
