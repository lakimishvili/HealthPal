//
//  MainTabBarWrapper.swift
//  HealthPal
//
//  Created by LILIANA on 1/11/26.
//
import UIKit
import SwiftUI

struct MainTabBarWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        MainTabBarController()
    }

    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
}
