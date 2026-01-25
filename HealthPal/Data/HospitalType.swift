//
//  HospitalType.swift
//  HealthPal
//
//  Created by LILIANA on 1/22/26.
//
import Foundation
enum HospitalType: String, CaseIterable, Identifiable {
    case hospital
    case clinic

    var id: String { rawValue }

    var title: String {
        switch self {
        case .hospital: return "Hospital"
        case .clinic: return "Clinic"
        }
    }
}
