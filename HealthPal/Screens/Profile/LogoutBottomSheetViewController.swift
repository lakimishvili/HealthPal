//
//  LogoutBottomSheetViewController.swift
//  HealthPal
//
//  Created by LILIANA on 1/25/26.
//
import UIKit

final class LogoutBottomSheetViewController: UIViewController {

    var onLogout: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24

        setupUI()
    }

    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Logout"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        let messageLabel = UILabel()
        messageLabel.text = "Are you sure you want to log out?"
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .systemGray5
        cancelButton.layer.cornerRadius = 24
        cancelButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Yes, Logout", for: .normal)
        logoutButton.backgroundColor = .black
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 24
        logoutButton.addTarget(self, action: #selector(confirmLogout), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, logoutButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            messageLabel,
            buttonStack
        ])
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            cancelButton.heightAnchor.constraint(equalToConstant: 48),
            logoutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    @objc private func confirmLogout() {
        dismissEnsureThenLogout()
    }

    private func dismissEnsureThenLogout() {
        dismiss(animated: true) {
            self.onLogout?()
        }
    }
}
