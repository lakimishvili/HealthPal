//
//  DoctorsListViewModel.swift
//  HealthPal
//
//  Created by LILIANA on 1/17/26.
//
import Foundation
internal import Combine

@MainActor
final class DoctorsListViewModel: ObservableObject {
    @Published var doctors: [Doctor] = []
    @Published var isLoading = false
    @Published var hospitals: [Int: String] = [:] 

    private let baseURL = "http://localhost:3000/doctors"
    private let hospitalsURL = "http://localhost:3000/hospitals"

    // MARK: - Fetch hospitals
    func loadHospitals() {
        guard let url = URL(string: hospitalsURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            Task { @MainActor in
                if let data {
                    do {
                        let list = try JSONDecoder().decode([Hospital].self, from: data)
                        self.hospitals = Dictionary(uniqueKeysWithValues: list.map { ($0.id, $0.name) })
                    } catch {
                        print("Hospital decode error:", error)
                    }
                } else if let error {
                    print("Hospital network error:", error)
                }
            }
        }.resume()
    }

    // MARK: - Hospital-specific
    func loadAll(hospitalId: Int) {
        let url = "\(baseURL)/hospital/\(hospitalId)"
        fetch(url: url)
    }

    func loadByCategory(hospitalId: Int, category: DoctorCategory) {
        let url = "\(baseURL)/hospital/\(hospitalId)/category/\(category.rawValue)"
        fetch(url: url)
    }

    func search(hospitalId: Int, query: String) {
        guard !query.isEmpty else {
            loadAll(hospitalId: hospitalId)
            return
        }
        let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "\(baseURL)/search?q=\(q)&hospitalId=\(hospitalId)"
        fetch(url: url)
    }

    // MARK: - All doctors
    func loadAllDoctors() {
        fetch(url: baseURL)
    }

    func loadAllByCategory(category: DoctorCategory) {
        let url = "\(baseURL)/category/\(category.rawValue)"
        fetch(url: url)
    }

    func searchAll(query: String) {
        guard !query.isEmpty else {
            loadAllDoctors()
            return
        }
        let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = "\(baseURL)/search?q=\(q)"
        fetch(url: url)
    }

    // MARK: - Private fetch
    private func fetch(url: String) {
        guard let url = URL(string: url) else { return }

        isLoading = true

        URLSession.shared.dataTask(with: url) { data, _, error in
            Task { @MainActor in
                self.isLoading = false

                if let data {
                    do {
                        var list = try JSONDecoder().decode([Doctor].self, from: data)
                        for i in 0..<list.count {
                            list[i].hospitalName = self.hospitals[list[i].hospitalId] ?? "Unknown"
                        }
                        self.doctors = list
                    } catch {
                        print("Decode error:", error)
                    }
                } else if let error {
                    print("Network error:", error)
                }
            }
        }.resume()
    }
}
