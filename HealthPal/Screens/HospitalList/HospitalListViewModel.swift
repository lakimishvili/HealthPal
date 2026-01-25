//
//  HospitalListViewModel.swift
//  HealthPal
//
//  Created by LILIANA on 1/22/26.
//
import Foundation

final class HospitalsListViewModel {

    private(set) var hospitals: [Hospital] = []

    private let baseURL = "http://localhost:3000/hospitals"

    func loadAll(completion: @escaping () -> Void) {
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data,
               let result = try? JSONDecoder().decode([Hospital].self, from: data) {
                DispatchQueue.main.async {
                    self.hospitals = result
                    completion()
                }
            }
        }.resume()
    }

    func loadByType(_ type: HospitalType, completion: @escaping () -> Void) {
        loadAll { [weak self] in
            guard let self = self else { return }
            self.hospitals = self.hospitals.filter { $0.type.lowercased() == type.rawValue }
            completion()
        }
    }

    func search(query: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(baseURL)/search?q=\(query)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data,
               let result = try? JSONDecoder().decode([Hospital].self, from: data) {
                DispatchQueue.main.async {
                    self.hospitals = result
                    completion()
                }
            }
        }.resume()
    }
}
