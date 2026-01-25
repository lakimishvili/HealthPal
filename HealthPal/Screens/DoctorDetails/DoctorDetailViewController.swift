//
//  DoctorDetailViewController.swift
//  HealthPal
//
//  Created by LILIANA on 1/19/26.
//

import UIKit
internal import Combine

final class DoctorDetailViewController: UIViewController {

    // MARK: - Data
    let doctor: Doctor
    private var isFavorite = false
    private var isShowingFullAbout = false

    private let favoritesManager = FavoritesManager.shared
    private let currentUser = CurrentUserManager.shared
    private var cancellable: AnyCancellable?

    // MARK: - Scroll
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Header
    private let doctorImageView = UIImageView()
    private let backButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)

    // MARK: - Stack
    private let stackView = UIStackView()

    // MARK: - Info
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let hospitalLabel = UILabel()
    private let hospitalIcon = UIImageView()

    // MARK: - Stats
    private let statsStack = UIStackView()
    private let patientsView = StatIconView(icon: "person.2.fill", value: "-", title: "Patients")
    private let experienceView = StatIconView(icon: "graduationcap.fill", value: "-", title: "Experience")
    private let ratingView = StatIconView(icon: "star.fill", value: "-", title: "Rating")
    private let reviewsView = StatIconView(icon: "bubble.left.and.bubble.right.fill", value: "-", title: "Reviews")

    // MARK: - About
    private let aboutTitleLabel = UILabel()
    private let aboutLabel = UILabel()
    private let showMoreButton = UIButton(type: .system)

    // MARK: - Working Time
    private let workingTimeTitleLabel = UILabel()
    private let workingHoursLabel = UILabel()

    // MARK: - Action
    private let bookButton = UIButton(type: .system)

    // MARK: - Init
    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupHeader()
        setupStackView()
        setupDoctorInfo()
        setupStats()
        setupAbout()
        setupWorkingTime()
        setupBookButton()
        configureData()

        isFavorite = favoritesManager.favoriteDoctorIDs.contains(doctor.id)
        updateFavoriteIcon()

        cancellable = favoritesManager.$favoriteDoctorIDs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                guard let self = self else { return }
                self.isFavorite = favorites.contains(self.doctor.id)
                self.updateFavoriteIcon()
            }
    }

    deinit {
        cancellable?.cancel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Scroll
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    // MARK: - Header
    private func setupHeader() {
        doctorImageView.contentMode = .scaleAspectFill
        doctorImageView.clipsToBounds = true
        doctorImageView.layer.cornerRadius = 24
        doctorImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(doctorImageView)

        NSLayoutConstraint.activate([
            doctorImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            doctorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            doctorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            doctorImageView.heightAnchor.constraint(equalToConstant: 260)
        ])

        setupHeaderButtons()
    }

    private func setupHeaderButtons() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backButton.layer.cornerRadius = 20
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)

        favoriteButton.backgroundColor = .white
        favoriteButton.tintColor = .black
        favoriteButton.layer.cornerRadius = 20
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOpacity = 0.15
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        favoriteButton.layer.shadowRadius = 4
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)

        [backButton, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Stack
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: doctorImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Info
    private func setupDoctorInfo() {
        nameLabel.font = .boldSystemFont(ofSize: 24)

        categoryLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        categoryLabel.backgroundColor = .systemGray6
        categoryLabel.layer.cornerRadius = 8
        categoryLabel.layer.masksToBounds = true
        categoryLabel.textAlignment = .center

        hospitalIcon.image = UIImage(systemName: "mappin.and.ellipse")
        hospitalIcon.tintColor = .black

        hospitalLabel.font = .systemFont(ofSize: 16)
        hospitalLabel.textColor = .darkGray

        let hospitalStack = UIStackView(arrangedSubviews: [hospitalLabel])
        hospitalStack.spacing = 6

        let infoStack = UIStackView(arrangedSubviews: [
            nameLabel,
            categoryLabel,
            hospitalStack
        ])
        infoStack.axis = .vertical
        infoStack.spacing = 8
        infoStack.alignment = .leading

        stackView.addArrangedSubview(infoStack)
    }

    // MARK: - Stats
    private func setupStats() {
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.spacing = 12

        [patientsView, experienceView, ratingView, reviewsView]
            .forEach { statsStack.addArrangedSubview($0) }

        stackView.addArrangedSubview(statsStack)
    }

    // MARK: - About
    private func setupAbout() {
        aboutTitleLabel.text = "About Doctor"
        aboutTitleLabel.font = .boldSystemFont(ofSize: 18)

        aboutLabel.font = .systemFont(ofSize: 14)
        aboutLabel.textColor = .darkGray
        aboutLabel.numberOfLines = 3

        showMoreButton.setTitle("View more", for: .normal)
        showMoreButton.tintColor = .black
        showMoreButton.addTarget(self, action: #selector(toggleAbout), for: .touchUpInside)

        stackView.addArrangedSubview(aboutTitleLabel)
        stackView.addArrangedSubview(aboutLabel)
        stackView.addArrangedSubview(showMoreButton)
    }

    // MARK: - Working Time
    private func setupWorkingTime() {
        workingTimeTitleLabel.text = "Working Time"
        workingTimeTitleLabel.font = .boldSystemFont(ofSize: 18)

        workingHoursLabel.font = .systemFont(ofSize: 16)
        workingHoursLabel.textColor = .darkGray

        stackView.addArrangedSubview(workingTimeTitleLabel)
        stackView.addArrangedSubview(workingHoursLabel)
    }

    // MARK: - Book Button
    private func setupBookButton() {
        bookButton.setTitle("Book Appointment", for: .normal)
        bookButton.backgroundColor = .black
        bookButton.setTitleColor(.white, for: .normal)
        bookButton.layer.cornerRadius = 14
        bookButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bookButton.addTarget(self, action: #selector(bookTapped), for: .touchUpInside)

        view.addSubview(bookButton)
        bookButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bookButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bookButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        scrollView.contentInset.bottom = 86
    }

    // MARK: - Data
    private func configureData() {
        nameLabel.text = doctor.fullName
        categoryLabel.text = "  \(doctor.category.uppercased())  "
        hospitalLabel.text = doctor.hospitalName
        aboutLabel.text = doctor.about ?? "No description available"
        workingHoursLabel.text = doctor.working_hours ?? "N/A"

        patientsView.valueLabel.text = doctor.patientsCount.map { "\($0)+" } ?? "N/A"
        experienceView.valueLabel.text = "\(doctor.experience)+ yrs"
        ratingView.valueLabel.text = String(format: "%.1f", doctor.rating)
        reviewsView.valueLabel.text = "\(doctor.reviewsCount ?? 0)"

        showMoreButton.isHidden = (doctor.about?.count ?? 0) < 120

        if let img = doctor.image, let url = URL(string: img) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.doctorImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    // MARK: - Favorites UI
    private func updateFavoriteIcon() {
        let name = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: name)?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = .black
    }

    // MARK: - Actions
    @objc private func toggleFavorite() {
        guard let userId = currentUser.user?.id else {
            let alert = UIAlertController(
                title: "Error",
                message: "You must be logged in to favorite a doctor",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        favoritesManager.toggleDoctorFavorite(doctor.id, userId: userId)
    }

    @objc private func toggleAbout() {
        isShowingFullAbout.toggle()
        aboutLabel.numberOfLines = isShowingFullAbout ? 0 : 3
        showMoreButton.setTitle(isShowingFullAbout ? "View less" : "View more", for: .normal)
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func bookTapped() {
        let vc = AppointmentViewController(doctor: doctor)
        navigationController?.pushViewController(vc, animated: true)
    }
}
