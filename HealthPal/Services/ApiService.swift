//
//  ApiService.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//

import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = "http://localhost:3000"

    private func makeRequest<T: Decodable>(
        _ path: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + path) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                print("[DEBUG] No data returned from path: \(path)")
                return
            }

            if let raw = String(data: data, encoding: .utf8) {
                print("[DEBUG] Raw API response for path \(path):\n\(raw)")
            } else {
                print("[DEBUG] Raw API response is not UTF-8 string, length: \(data.count) bytes")
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print("[DEBUG] JSON decode error for path \(path): \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Hospitals
    func fetchHospitals(completion: @escaping (Result<[Hospital], Error>) -> Void) {
        makeRequest("/hospitals", completion: completion)
    }

    func fetchHospitalCategories(
        hospitalId: Int,
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        makeRequest("/hospitals/\(hospitalId)/categories", completion: completion)
    }

    // MARK: - Doctors
    func fetchDoctors(
        hospitalId: Int,
        completion: @escaping (Result<[Doctor], Error>) -> Void
    ) {
        makeRequest("/doctors/hospital/\(hospitalId)", completion: completion)
    }

    func fetchDoctors(
        hospitalId: Int,
        category: String,
        completion: @escaping (Result<[Doctor], Error>) -> Void
    ) {
        makeRequest("/doctors/hospital/\(hospitalId)/category/\(category)", completion: completion)
    }
    
    // MARK: - Appointments
    func fetchSlots(
        doctorId: Int,
        date: String,
        completion: @escaping (Result<[TimeSlot], Error>) -> Void
    ) {
        makeRequest("/api/appointments/slots/\(doctorId)/\(date)", completion: completion)
    }

    func bookAppointment(
        userId: Int,
        doctorId: Int,
        hospitalId: Int,
        date: String,
        time: String,
        completion: @escaping (Result<BookResponse, Error>) -> Void
    ) {
        let body: [String: Any] = [
            "userId": userId,
            "doctorId": doctorId,
            "hospitalId": hospitalId,
            "date": date,
            "time": time
        ]

        guard let url = URL(string: baseURL + "/api/appointments/book") else {
            print("[DEBUG] Invalid URL for booking appointment")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("[DEBUG] Booking request body:\n\(jsonString)")
            }
        } catch {
            print("[DEBUG] Failed to serialize booking body: \(error)")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("[DEBUG] Network error while booking: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data else {
                print("[DEBUG] No data returned from booking request")
                return
            }

            if let raw = String(data: data, encoding: .utf8) {
                print("[DEBUG] Raw booking response:\n\(raw)")
            } else {
                print("[DEBUG] Booking response is not UTF-8 string, length: \(data.count) bytes")
            }

            do {
                let decoded = try JSONDecoder().decode(BookResponse.self, from: data)
                print("[DEBUG] Successfully decoded booking response: \(decoded)")
                completion(.success(decoded))
            } catch {
                print("[DEBUG] JSON decode error for booking: \(error)")
                if let snippet = String(data: data.prefix(500), encoding: .utf8) {
                    print("[DEBUG] Snippet of response causing decode error:\n\(snippet)")
                }
                completion(.failure(error))
            }
        }.resume()
    }

}
