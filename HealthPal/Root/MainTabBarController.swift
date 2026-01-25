//
//  MainTabBarController.swift
//  HealthPal
//
//  Created by LILIANA on 1/11/26.
//
import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let home = UIHostingController(rootView: HomeView())
        let bookings = UINavigationController(rootViewController: BookingsViewController())
        let profile = UINavigationController(rootViewController: ProfileViewController())

        let hospitalsListVC = HospitalsListViewController()
        let hospitalsNav = UINavigationController(rootViewController: hospitalsListVC)

        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        hospitalsNav.tabBarItem = UITabBarItem(title: "Hospitals", image: UIImage(systemName: "bandage"), tag: 1)
        bookings.tabBarItem = UITabBarItem(title: "Bookings", image: UIImage(systemName: "calendar"), tag: 2)
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)

        viewControllers = [home, hospitalsNav, bookings, profile]

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openHospitalsTab),
            name: .switchToHospitalsTab,
            object: nil
        )
    }

    @objc private func openHospitalsTab() {
        selectedIndex = 1 
    }
}
