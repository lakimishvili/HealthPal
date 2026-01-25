//
//  DoctorCategory.swift
//  HealthPal
//
//  Created by LILIANA on 1/15/26.
//

import SwiftUI

enum DoctorCategory: String, CaseIterable, Identifiable {
    case cardiologist
    case gynecologist
    case dermatologist
    case pediatrician
    case neurologist
    case orthopedist
    case dentist
    case ophthalmologist
    case psychiatrist
    case endocrinologist
    case oncologist
    case urologist
    case ent
    case generalPractitioner
    case surgeon
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cardiologist: return "Cardiologist"
        case .gynecologist: return "Gynecologist"
        case .dermatologist: return "Dermatologist"
        case .pediatrician: return "Pediatrician"
        case .neurologist: return "Neurologist"
        case .orthopedist: return "Orthopedist"
        case .dentist: return "Dentist"
        case .ophthalmologist: return "Ophthalmologist"
        case .psychiatrist: return "Psychiatrist"
        case .endocrinologist: return "Endocrinologist"
        case .oncologist: return "Oncologist"
        case .urologist: return "Urologist"
        case .ent: return "ENT"
        case .generalPractitioner: return "General"
        case .surgeon: return "Surgeon"
        case .other: return "Other"
        }
    }

    var icon: String {
        switch self {
        case .cardiologist: return "heart.fill"
        case .gynecologist: return "figure.stand.dress"
        case .dermatologist: return "face.smiling"
        case .pediatrician: return "figure.child"
        case .neurologist: return "brain.head.profile"
        case .orthopedist: return "figure.walk"
        case .dentist: return "mouth"
        case .ophthalmologist: return "eye"
        case .psychiatrist: return "brain"
        case .endocrinologist: return "waveform.path.ecg"
        case .oncologist: return "cross.case.fill"
        case .urologist: return "drop.fill"
        case .ent: return "ear"
        case .generalPractitioner: return "stethoscope"
        case .surgeon: return "scissors"
        case .other: return "ellipsis.circle"
        }
    }

    var color: Color {
        switch self {
        case .cardiologist: return Color(red: 0.95, green: 0.45, blue: 0.45)
        case .gynecologist: return Color(red: 0.93, green: 0.55, blue: 0.70)
        case .dermatologist: return Color(red: 0.96, green: 0.76, blue: 0.50)
        case .pediatrician: return Color(red: 0.55, green: 0.80, blue: 0.95)
        case .neurologist: return Color(red: 0.70, green: 0.65, blue: 0.95)
        case .orthopedist: return Color(red: 0.65, green: 0.75, blue: 0.85)
        case .dentist: return Color(red: 0.60, green: 0.90, blue: 0.85)
        case .ophthalmologist: return Color(red: 0.55, green: 0.85, blue: 0.70)
        case .psychiatrist: return Color(red: 0.75, green: 0.70, blue: 0.90)
        case .endocrinologist: return Color(red: 0.85, green: 0.80, blue: 0.60)
        case .oncologist: return Color(red: 0.90, green: 0.60, blue: 0.60)
        case .urologist: return Color(red: 0.60, green: 0.80, blue: 0.75)
        case .ent: return Color(red: 0.70, green: 0.85, blue: 0.65)
        case .generalPractitioner: return Color(red: 0.65, green: 0.90, blue: 0.70)
        case .surgeon: return Color(red: 0.55, green: 0.75, blue: 0.95)
        case .other: return Color(.systemGray4)
        }
    }
}
