//
//  Appointment.swift
//  HealthPal
//
//  Created by LILIANA on 1/20/26.
//
import Foundation

struct Appointment: Codable {
    let id: Int
    let userId: Int
    let doctorId: Int
    let hospitalId: Int
    let date: String
    let time: String
    var status: String

    let doctorName: String?
    let doctorSurname: String?
    let doctorImage: String?
    let doctorCategory: String?

    let hospitalName: String?
    let hospitalImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case doctorId = "doctor_id"
        case hospitalId = "hospital_id"
        case date
        case time
        case status
        case doctorName
        case doctorSurname
        case doctorImage
        case doctorCategory
        case hospitalName
        case hospitalImage
    }
}

extension Doctor {
    init(
        id: Int,
        name: String,
        surname: String,
        category: String,
        image: String?,
        hospitalId: Int
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.category = category
        self.image = image
        self.hospitalId = hospitalId

        self.about = nil
        self.working_hours = nil
        self.patientsCount = nil
        self.experience = 0
        self.rating = 0
        self.reviewsCount = nil
        self.hospitalName = nil
    }
}

extension Appointment {
    func toDoctor() -> Doctor {
        Doctor(
            id: doctorId,
            name: doctorName ?? "",
            surname: doctorSurname ?? "",
            category: doctorCategory ?? "",
            image: doctorImage,
            hospitalId: hospitalId
        )
    }
}
