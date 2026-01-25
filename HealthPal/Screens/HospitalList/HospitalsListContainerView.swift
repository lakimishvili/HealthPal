//
//  HospitalsListContainerView.swift
//  HealthPal
//
//  Created by LILIANA on 1/22/26.
//

import SwiftUI

struct HospitalsListContainerView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> HospitalsListViewController {
        HospitalsListViewController()
    }

    func updateUIViewController(_ uiViewController: HospitalsListViewController,
                                context: Context) {}
}
