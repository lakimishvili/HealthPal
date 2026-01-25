//
//  FavoritesViewController.swift
//  HealthPal
//
//  Created by LILIANA on 1/18/26.
//

import UIKit
import SwiftUI

class FavoritesViewController: UIViewController {

    private let userId: Int
    private let segmentedControl = UISegmentedControl(items: ["Doctors", "Hospitals"])
    private let containerView = UIView()
    
    private var doctorsHosting: UIHostingController<DoctorsFavoritesList>?
    private var hospitalsHosting: UIHostingController<HospitalsFavoritesList>?

    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
        self.title = "Favorites"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSegmentedControl()
        setupContainerView()
        setupChildViews()
        updateTab(selectedIndex: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }


    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(tabChanged), for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }

    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupChildViews() {
        let doctorsView = DoctorsFavoritesList(userId: userId)
        doctorsHosting = UIHostingController(rootView: doctorsView)
        addChild(doctorsHosting!)
        doctorsHosting!.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(doctorsHosting!.view)
        NSLayoutConstraint.activate([
            doctorsHosting!.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            doctorsHosting!.view.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            doctorsHosting!.view.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            doctorsHosting!.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        doctorsHosting!.didMove(toParent: self)
        
        let hospitalsView = HospitalsFavoritesList(userId: userId)
        hospitalsHosting = UIHostingController(rootView: hospitalsView)
        addChild(hospitalsHosting!)
        hospitalsHosting!.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(hospitalsHosting!.view)
        NSLayoutConstraint.activate([
            hospitalsHosting!.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            hospitalsHosting!.view.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            hospitalsHosting!.view.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            hospitalsHosting!.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        hospitalsHosting!.didMove(toParent: self)
    }

    @objc private func tabChanged() {
        updateTab(selectedIndex: segmentedControl.selectedSegmentIndex)
    }

    private func updateTab(selectedIndex: Int) {
        doctorsHosting?.view.isHidden = selectedIndex != 0
        hospitalsHosting?.view.isHidden = selectedIndex != 1
    }
}
