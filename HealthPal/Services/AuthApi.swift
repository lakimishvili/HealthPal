//
//  Untitled.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//
import Foundation

final class AuthAPI {
    static let shared = AuthAPI()
    private let baseURL = "http://localhost:3000/auth"

    func register(
        fullName: String,
        email: String,
        password: String,
        completion: @escaping (Result<Int, Error>) -> Void
    ) {
        let url = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "fullName": fullName,
            "email": email,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let userId = json?["userId"] as? Int {
                    completion(.success(userId))
                } else {
                    let message = json?["message"] as? String ?? "Unknown error"
                    completion(.failure(NSError(domain: message, code: 0)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func updateProfile(
        token: String,
        phone: String,
        personalId: String,
        birthYear: Int,
        gender: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let url = URL(string: "\(baseURL)/update-profile")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") 

        let body: [String: Any] = [
            "phone": phone,
            "personalId": personalId,
            "birthYear": birthYear,
            "gender": gender
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }

    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "No data received", code: 0)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let token = json?["token"] as? String {
                    completion(.success(token))
                } else {
                    let message = json?["message"] as? String ?? "Unknown error"
                    completion(.failure(NSError(domain: message, code: 0)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
