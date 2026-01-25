//
//  AppointmentViewController.swift
//  HealthPal
//
//  Created by LILIANA on 1/20/26.
//
import UIKit
import SwiftUI

final class AppointmentViewController: UIViewController {

    private let doctor: Doctor
    private let datePicker = UIDatePicker()
    private let collectionView: UICollectionView
    private let confirmButton = UIButton(type: .system)
    private let bottomMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var slots: [TimeSlot] = []
    private var selectedIndexPath: IndexPath?
    private let currentUser = CurrentUserManager.shared

    // MARK: - Init
    init(doctor: Doctor) {
        self.doctor = doctor

        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            let spacing: CGFloat = 12
            let slotsPerRow: CGFloat = 4

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / slotsPerRow),
                heightDimension: .absolute(50)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: spacing)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

            return section
        }

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.alwaysBounceVertical = true
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Book Appointment"

        setupDatePicker()
        setupCollectionView()
        setupConfirmButton()
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground

        let stack = UIStackView(arrangedSubviews: [datePicker, collectionView, bottomMessageLabel, confirmButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),

            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            bottomMessageLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        loadSlots(for: Date())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Setup UI
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    private func setupCollectionView() {
        collectionView.register(TimeSlotCell.self, forCellWithReuseIdentifier: "TimeSlotCell")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupConfirmButton() {
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.backgroundColor = .black
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 12
        confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func dateChanged() {
        selectedIndexPath = nil
        bottomMessageLabel.isHidden = true
        loadSlots(for: datePicker.date)
    }

    private func loadSlots(for date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: date)

        APIService.shared.fetchSlots(doctorId: doctor.id, date: dateStr) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let slots):
                    let now = Date()
                    let filteredSlots = slots.filter { slot in
                        let slotFormatter = DateFormatter()
                        slotFormatter.dateFormat = "HH:mm"
                        guard let slotTime = slotFormatter.date(from: slot.time) else { return false }

                        let calendar = Calendar.current
                        let slotComponents = calendar.dateComponents([.hour, .minute], from: slotTime)
                        guard let slotDateTime = calendar.date(
                            bySettingHour: slotComponents.hour ?? 0,
                            minute: slotComponents.minute ?? 0,
                            second: 0,
                            of: date
                        ) else { return false }

                        return !(date.isToday && slotDateTime < now)
                    }

                    self.slots = filteredSlots
                    self.collectionView.reloadData()
                    self.selectedIndexPath = nil

                    if filteredSlots.isEmpty {
                        self.bottomMessageLabel.text = "Doctor is not available on this day."
                        self.bottomMessageLabel.isHidden = false
                    } else {
                        self.bottomMessageLabel.isHidden = true
                    }

                case .failure(let error):
                    self.slots = []
                    self.collectionView.reloadData()
                    self.bottomMessageLabel.text = "Failed to load slots: \(error.localizedDescription)"
                    self.bottomMessageLabel.isHidden = false
                }
            }
        }
    }

    @objc private func confirmTapped() {
        guard let indexPath = selectedIndexPath else {
            bottomMessageLabel.text = "Please select a time slot."
            bottomMessageLabel.isHidden = false
            return
        }

        let slot = slots[indexPath.item]

        guard slot.available, let userId = currentUser.user?.id else {
            bottomMessageLabel.text = "Cannot book. User not logged in or slot unavailable."
            bottomMessageLabel.isHidden = false
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: datePicker.date)

        APIService.shared.bookAppointment(
            userId: userId,
            doctorId: doctor.id,
            hospitalId: doctor.hospitalId,
            date: dateStr,
            time: slot.time
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let overlay = UIHostingController(
                        rootView: SuccessOverlay(
                            title: "Success",
                            message: response.message + " (ID: \(response.appointmentId))"
                        )
                    )
                    overlay.modalPresentationStyle = .overFullScreen
                    overlay.modalTransitionStyle = .crossDissolve
                    self.present(overlay, animated: true)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        overlay.dismiss(animated: true) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }

                case .failure(let error):
                    self.bottomMessageLabel.text = "Booking failed: \(error.localizedDescription)"
                    self.bottomMessageLabel.isHidden = false
                }
            }
        }
    }
}

// MARK: - UICollectionView
extension AppointmentViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCell", for: indexPath) as! TimeSlotCell
        let slot = slots[indexPath.item]
        cell.configure(with: slot, selected: indexPath == selectedIndexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slot = slots[indexPath.item]
        guard slot.available else {
            bottomMessageLabel.text = "This slot is unavailable."
            bottomMessageLabel.isHidden = false
            return
        }

        selectedIndexPath = indexPath
        bottomMessageLabel.isHidden = true
        collectionView.reloadData()
    }
}

// MARK: - Date Helper
extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
