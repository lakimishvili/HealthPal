//
//  CancelConfirmationBottomSheet.swift
//  HealthPal
//
//  Created by LILIANA on 1/20/26.
//
import UIKit

final class CancelConfirmationBottomSheet: UIViewController {

    var onConfirm: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        view.clipsToBounds = true

        if let sheet = sheetPresentationController {
            let detent = UISheetPresentationController.Detent.custom { _ in
                return 180
            }
            sheet.detents = [detent]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        setupUI()
    }

    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Are you sure you want to cancel this appointment?"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .systemGray5
        cancelButton.layer.cornerRadius = 20
        cancelButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Yes, Cancel", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .black
        confirmButton.layer.cornerRadius = 20
        confirmButton.addTarget(self, action: #selector(confirmCancel), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            buttonStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    @objc private func confirmCancel() {
        dismiss(animated: true) { [weak self] in
            self?.onConfirm?()
        }
    }
}
