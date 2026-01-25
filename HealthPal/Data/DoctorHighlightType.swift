//
//  DoctorHighlightType.swift
//  HealthPal
//
//  Created by LILIANA on 1/23/26.
//
import Foundation

enum DoctorHighlightType {
    case topRated
    case mostReviewed
    case mostPatients

    var title: String {
        switch self {
        case .topRated:
            return "Top Rated Doctor"
        case .mostReviewed:
            return "Most Reviewed Doctor"
        case .mostPatients:
            return "Most Trusted Doctor"
        }
    }

    var subtitle: String {
        switch self {
        case .topRated:
            return "Highest rating by patients"
        case .mostReviewed:
            return "Most reviews received"
        case .mostPatients:
            return "Treated the most patients"
        }
    }

    var icon: String {
        switch self {
        case .topRated:
            return "star.fill"
        case .mostReviewed:
            return "text.bubble.fill"
        case .mostPatients:
            return "person.3.fill"
        }
    }
}
