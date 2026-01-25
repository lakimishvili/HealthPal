//
//  NotificationService.swift
//  HealthPal
//
//  Created by LILIANA on 1/24/26.
//
import Foundation

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    private let baseURL = "http://localhost:3000"

    func fetchNotifications(userId: Int, completion: @escaping (Result<[NotificationItem], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/notifications/\(userId)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error { completion(.failure(error)); return }
            guard let data else { return }

            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(formatter)
                
                let decoded = try decoder.decode([NotificationItem].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func markAsRead(notificationId: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/notifications/\(notificationId)/read") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if error != nil { completion(false); return }
            completion(true)
        }.resume()
    }
}
