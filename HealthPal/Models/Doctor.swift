//
//  Doctor.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//

import Foundation

struct Doctor: Identifiable, Decodable {
    let id: Int
    let name: String
    let surname: String
    let category: String
    let experience: Int
    let rating: Double
    let hospitalId: Int
    let image: String?
    let about: String?
    let working_hours: String?
    var hospitalName: String?

    let reviewsCount: Int?
    let patientsCount: Int?

    var fullName: String {
        "\(name) \(surname)"
    }

    enum CodingKeys: String, CodingKey {
        case id, name, surname, category, experience, rating, image, about, working_hours
        case reviewsCount
        case patientsCount = "patients_count"
        case hospitalId = "hospital_id"
        case hospitalName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        category = try container.decode(String.self, forKey: .category)
        experience = try container.decode(Int.self, forKey: .experience)
        rating = try container.decode(Double.self, forKey: .rating)
        hospitalId = try container.decode(Int.self, forKey: .hospitalId)

        image = try? container.decode(String.self, forKey: .image)
        about = try? container.decode(String.self, forKey: .about)
        working_hours = try? container.decode(String.self, forKey: .working_hours)
        hospitalName = try? container.decode(String.self, forKey: .hospitalName)

        if let count = try? container.decode(Int.self, forKey: .reviewsCount) {
            reviewsCount = count
        } else if let countString = try? container.decode(String.self, forKey: .reviewsCount),
                  let count = Int(countString) {
            reviewsCount = count
        } else {
            reviewsCount = 0
        }

        if let count = try? container.decode(Int.self, forKey: .patientsCount) {
            patientsCount = count
        } else if let countString = try? container.decode(String.self, forKey: .patientsCount),
                  let count = Int(countString) {
            patientsCount = count
        } else {
            patientsCount = 0
        }
    }
}
