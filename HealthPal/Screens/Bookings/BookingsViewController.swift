//
//  BookingsViewController.swift
//  HealthPal
//
//  Created by LILIANA on 1/20/26.
//

import UIKit
import SwiftUI

final class BookingsViewController: UIViewController {

    private let tableView = UITableView()
    private let segmentControl = UISegmentedControl(items: ["Upcoming", "Past"])
    private let emptyLabel = UILabel()

    private let userId = 2
    private lazy var viewModel = BookingsViewModel(userId: userId)

    private var overlayHosting: UIHostingController<SuccessOverlay>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupSegmentInNavigationBar()
        setupTableView()
        setupEmptyLabel()

        viewModel.onDataUpdated = { [weak self] in
            self?.updateEmptyState()
            self?.tableView.reloadData()
        }

        viewModel.loadAppointments()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false

        let isUpcoming = segmentControl.selectedSegmentIndex == 0
        viewModel.loadAppointmentsAndFilter(upcoming: isUpcoming)
    }

    // MARK: - Navigation Bar Segment
    private func setupSegmentInNavigationBar() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentTintColor = .black
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 32))
        segmentControl.frame = container.bounds
        segmentControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(segmentControl)
        navigationItem.titleView = container
    }

    @objc private func segmentChanged() {
        let upcoming = segmentControl.selectedSegmentIndex == 0
        viewModel.filterAppointments(upcoming: upcoming)
        updateEmptyState()
    }

    // MARK: - TableView Setup
    private func setupTableView() {
        tableView.register(BookingCell.self, forCellReuseIdentifier: "BookingCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Empty Label
    private func setupEmptyLabel() {
        emptyLabel.text = "No appointments found."
        emptyLabel.textColor = .gray
        emptyLabel.font = .systemFont(ofSize: 16)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.isHidden = true

        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func updateEmptyState() {
        let isEmpty = viewModel.filteredAppointments.isEmpty
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    // MARK: - Success Overlay
    private func showSuccessOverlay(title: String, message: String) {
        overlayHosting = UIHostingController(
            rootView: SuccessOverlay(title: title, message: message)
        )

        guard let overlayHosting = overlayHosting else { return }

        overlayHosting.view.translatesAutoresizingMaskIntoConstraints = false
        overlayHosting.view.backgroundColor = .clear
        addChild(overlayHosting)
        view.addSubview(overlayHosting.view)
        overlayHosting.didMove(toParent: self)

        NSLayoutConstraint.activate([
            overlayHosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayHosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayHosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            overlayHosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            overlayHosting.willMove(toParent: nil)
            overlayHosting.view.removeFromSuperview()
            overlayHosting.removeFromParent()
            self?.overlayHosting = nil
        }
    }
}

// MARK: - TableView
extension BookingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredAppointments.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BookingCell",
            for: indexPath
        ) as! BookingCell

        let appointment = viewModel.filteredAppointments[indexPath.row]
        let isUpcoming = segmentControl.selectedSegmentIndex == 0

        cell.configure(appointment: appointment, isUpcoming: isUpcoming)

        cell.onCancelTapped = { [weak self] in
            guard let self = self else { return }

            let sheet = CancelConfirmationBottomSheet()
            sheet.onConfirm = {
                self.viewModel.cancelAppointment(appointment)
                self.showSuccessOverlay(
                    title: "Appointment Cancelled",
                    message: "Your appointment has been successfully cancelled."
                )
            }

            self.present(sheet, animated: true)
        }

        cell.onRescheduleTapped = { [weak self] in
            guard let self = self else { return }

            let doctor = appointment.toDoctor()
            let vc = AppointmentViewController(doctor: doctor)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        return cell
    }
}

