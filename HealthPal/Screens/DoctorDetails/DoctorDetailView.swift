//
//  DoctorDetailView.swift
//  HealthPal
//
//  Created by LILIANA on 1/19/26.
//
import SwiftUI

struct DoctorDetailView: UIViewControllerRepresentable {
    let doctor: Doctor

    func makeUIViewController(context: Context) -> DoctorDetailViewController {
        return DoctorDetailViewController(doctor: doctor)
    }

    func updateUIViewController(_ uiViewController: DoctorDetailViewController, context: Context) {
    }
}
