//
//  HospitalsListViewController.swift
//  HealthPal
//
//  Created by LILIANA on 1/22/26.
//

import UIKit
import SwiftUI

final class HospitalsListViewController: UIViewController,
                                         UISearchBarDelegate,
                                         UITableViewDelegate,
                                         UITableViewDataSource {

    // MARK: - UI
    private let searchBar = UISearchBar()
    private let filtersScrollView = UIScrollView()
    private let filtersStackView = UIStackView()
    private let headerStackView = UIStackView()
    private let countLabel = UILabel()
    private let sortButton = UIButton(type: .system)
    private let tableView = UITableView()

    // MARK: - State
    private var selectedType: HospitalType? = nil
    private var sortDescending = true
    private var currentUser: User? {
        CurrentUserManager.shared.user
    }

    private let cellSpacing: CGFloat = 16

    private let vm = HospitalsListViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Hospitals"

        setupSearchBar()
        setupFilters()
        setupHeader()
        setupTableView()
        view.insetsLayoutMarginsFromSafeArea = false
        
        loadHospitals()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Search Bar (UI updated to match Doctors list)
    private func setupSearchBar() {
        searchBar.placeholder = "Search hospital..."
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = UIColor.systemGray6
        searchBar.searchTextField.layer.cornerRadius = 16
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.textColor = .label
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.tintColor = .gray
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Filters
    private func setupFilters() {
        filtersStackView.axis = .horizontal
        filtersStackView.spacing = 10
        filtersStackView.alignment = .center
        filtersStackView.distribution = .fillProportionally
        filtersScrollView.showsHorizontalScrollIndicator = false

        filtersScrollView.addSubview(filtersStackView)
        view.addSubview(filtersScrollView)

        filtersScrollView.translatesAutoresizingMaskIntoConstraints = false
        filtersStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            filtersScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filtersScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filtersScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filtersScrollView.heightAnchor.constraint(equalToConstant: 44),

            filtersStackView.leadingAnchor.constraint(equalTo: filtersScrollView.leadingAnchor, constant: 16),
            filtersStackView.trailingAnchor.constraint(equalTo: filtersScrollView.trailingAnchor, constant: -16),
            filtersStackView.centerYAnchor.constraint(equalTo: filtersScrollView.centerYAnchor)
        ])

        addFilterButton(title: "All", type: nil)
        HospitalType.allCases.forEach { addFilterButton(title: $0.title, type: $0) }

        updateFilterButtons()
    }

    // MARK: - Filter Buttons
    private func addFilterButton(title: String, type: HospitalType?) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        button.sizeToFit()

        button.addAction(UIAction { [weak self] _ in
            self?.selectedType = type
            self?.updateFilterButtons()
            self?.loadHospitals()
        }, for: .touchUpInside)

        filtersStackView.addArrangedSubview(button)
    }

    // MARK: - Header
    private func setupHeader() {
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center

        countLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        countLabel.textColor = .black

        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        let image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: config)
        sortButton.setTitle("Rating", for: .normal)
        sortButton.setImage(image, for: .normal)
        sortButton.tintColor = .gray
        sortButton.setTitleColor(.gray, for: .normal)
        sortButton.titleLabel?.font = .systemFont(ofSize: 15)
        sortButton.semanticContentAttribute = .forceRightToLeft
        sortButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)

        sortButton.addAction(UIAction { [weak self] _ in
            self?.sortDescending.toggle()
            self?.tableView.reloadData()
        }, for: .touchUpInside)

        headerStackView.addArrangedSubview(countLabel)
        headerStackView.addArrangedSubview(UIView())
        headerStackView.addArrangedSubview(sortButton)

        view.addSubview(headerStackView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: filtersScrollView.bottomAnchor, constant: 8),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerStackView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }


    private func updateFilterButtons() {
        for case let button as UIButton in filtersStackView.arrangedSubviews {
            let isSelected = button.title(for: .normal) ==
                (selectedType?.title ?? "All")
            button.backgroundColor = isSelected ? .black : .white
            button.setTitleColor(isSelected ? .white : .black, for: .normal)
        }
    }

    // MARK: - TableView
    private func setupTableView() {
        tableView.register(HospitalTableViewCell.self,
                           forCellReuseIdentifier: "HospitalCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: cellSpacing, right: 0)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Data
    private func loadHospitals() {
        let completion = { [weak self] in
            guard let self else { return }
            self.countLabel.text = "\(self.sortedHospitals.count) Founds"
            self.tableView.reloadData()
        }

        if let type = selectedType {
            vm.loadByType(type, completion: completion)
        } else {
            vm.loadAll(completion: completion)
        }
    }

    private var sortedHospitals: [Hospital] {
        vm.hospitals.sorted {
            sortDescending ? $0.rating > $1.rating : $0.rating < $1.rating
        }
    }

    // MARK: - UITableViewDataSource / Delegate
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        sortedHospitals.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "HospitalCell",
            for: indexPath
        ) as! HospitalTableViewCell

        let hospital = sortedHospitals[indexPath.row]
        cell.configure(with: hospital, userId: currentUser?.id ?? 0)
        return cell
    }

    // MARK: - Present Doctors from bottom
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        let hospital = sortedHospitals[indexPath.row]

        let doctorsView = NavigationStack {
            DoctorsListView(
                hospitalId: hospital.id,
                initialCategory: nil
            )
        }

        let hostingVC = UIHostingController(rootView: doctorsView)
        hostingVC.modalPresentationStyle = .pageSheet

        if let sheet = hostingVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        present(hostingVC, animated: true)
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {

        if searchText.isEmpty {
            loadHospitals()
        } else {
            vm.search(query: searchText) { [weak self] in
                guard let self else { return }
                self.countLabel.text = "\(self.sortedHospitals.count) Founds"
                self.tableView.reloadData()
            }
        }
    }
}
