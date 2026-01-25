//
//  FavoritesBottomSheetViewController.swift
//  HealthPal
//
//  Created by LILIANA on 1/25/26.
//
import UIKit
import SwiftUI

final class FavoritesBottomSheetViewController: UIViewController {

    enum FavoriteType {
        case doctor(Doctor)
        case hospital(Hospital)
    }

    private let userId: Int
    private let favorite: FavoriteType
    var onRemove: ((FavoriteType) -> Void)?

    init(userId: Int, favorite: FavoriteType) {
        self.userId = userId
        self.favorite = favorite
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24

        if let sheet = sheetPresentationController {
            // Increase height to 380 points
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return 300
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }

        setupUI()
    }

    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Remove from Favorites?"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        let cardView: UIView
        switch favorite {
        case .doctor(let doctor):
            let vc = UIHostingController(rootView: DoctorCardCompactView(doctor: doctor))
            addChild(vc)
            vc.didMove(toParent: self)
            cardView = vc.view
        case .hospital(let hospital):
            let vc = UIHostingController(rootView: HospitalCardCompactView(hospital: hospital))
            addChild(vc)
            vc.didMove(toParent: self)
            cardView = vc.view
        }

        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .systemGray5
        cancelButton.layer.cornerRadius = 24
        cancelButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        let removeButton = UIButton(type: .system)
        removeButton.setTitle("Yes, Remove", for: .normal)
        removeButton.setTitleColor(.white, for: .normal)
        removeButton.backgroundColor = .black
        removeButton.layer.cornerRadius = 24
        removeButton.addTarget(self, action: #selector(confirmRemove), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, removeButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalToConstant: 160), // bigger card height

            buttonStack.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    @objc private func confirmRemove() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.onRemove?(self.favorite)
        }
    }
}
