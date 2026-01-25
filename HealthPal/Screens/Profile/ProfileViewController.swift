//
//  ProfileViewController.swift
//  HealthPal
//
//  Created by LILIANA on 1/25/26.
//
import UIKit
import SwiftUI
internal import Combine

final class ProfileViewController: UIViewController {

    // MARK: - UI
    private let titleLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let editButton = UIButton(type: .system)
    private let nameLabel = UILabel()
    private let phoneLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Data
    private let menuItems: [(title: String, icon: String)] = [
        ("Edit Profile", "person"),
        ("Favorite", "heart"),
        ("Notifications", "bell"),
        ("Settings", "gear"),
        ("Help and Support", "questionmark.circle"),
        ("Terms and Conditions", "doc.text"),
        ("Log Out", "arrow.uturn.backward")
    ]

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHeader()
        setupTableView()
        bindUser()
        CurrentUserManager.shared.loadCurrentUser()
    }

    // MARK: - Bind Current User
    private func bindUser() {
        CurrentUserManager.shared.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self, let user = user else { return }

                self.nameLabel.text = user.fullName
                self.phoneLabel.text = user.phone ?? "-"

                self.avatarImageView.setImage(from: user.profileImageUrl)
            }
            .store(in: &cancellables)
    }

    // MARK: - Header
    private func setupHeader() {
        titleLabel.text = "Profile"
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true

        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .white
        editButton.backgroundColor = .black
        editButton.layer.cornerRadius = 16

        nameLabel.font = .boldSystemFont(ofSize: 18)
        phoneLabel.textColor = .secondaryLabel

        let avatarContainer = UIView()
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatarImageView)
        avatarContainer.addSubview(editButton)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            editButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            editButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 32),
            editButton.heightAnchor.constraint(equalToConstant: 32),

            avatarContainer.heightAnchor.constraint(equalToConstant: 110)
        ])

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            avatarContainer,
            nameLabel,
            phoneLabel
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Table
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TableView
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let item = menuItems[indexPath.row]

        cell.textLabel?.text = item.title

        let icon = UIImage(systemName: item.icon)?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        cell.imageView?.image = icon

        cell.textLabel?.textColor = item.title == "Log Out" ? .systemRed : .gray
        cell.accessoryType = item.title == "Log Out" ? .none : .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedItem = menuItems[indexPath.row].title

        switch selectedItem {
        case "Log Out":
            presentLogoutSheet()
        case "Favorite":
            if let userId = CurrentUserManager.shared.user?.id {
                let favoritesVC = FavoritesViewController(userId: userId)
                favoritesVC.title = "Favorites"
                navigationController?.pushViewController(favoritesVC, animated: true)
            }
        default:
            break
        }
    }

    private func presentLogoutSheet() {
        let sheetVC = LogoutBottomSheetViewController()
        sheetVC.modalPresentationStyle = .pageSheet

        if let sheet = sheetVC.sheetPresentationController {
            let smallDetent = UISheetPresentationController.Detent.custom { _ in 200 }
            sheet.detents = [smallDetent]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        sheetVC.onLogout = { [weak self] in
            UserDefaults.standard.removeObject(forKey: "authToken")
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.removeObject(forKey: "userFullName")

            let signInView = SignInView()
            let vc = UIHostingController(rootView: signInView)

            UIApplication.shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first?
                .rootViewController = vc
        }

        present(sheetVC, animated: true)
    }
}

// MARK: - UIImageView Helper
private extension UIImageView {
    func setImage(from urlString: String?, placeholder: UIImage? = UIImage(systemName: "person.circle.fill")) {
        self.image = placeholder
        guard let urlString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
