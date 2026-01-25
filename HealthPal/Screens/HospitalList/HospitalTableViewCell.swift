//
//  HospitalTableViewCell.swift
//  HealthPal
//
//  Created by LILIANA on 1/22/26.
//
import UIKit
import SwiftUI

final class HospitalTableViewCell: UITableViewCell {

    private var hostingController: UIHostingController<HospitalCard>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        with hospital: Hospital,
        userId: Int,
        isFavorite: Bool = false,
        onSelect: (() -> Void)? = nil
    ) {
        hostingController?.view.removeFromSuperview()

        let cardView = HospitalCard(
            hospital: hospital,
            userId: userId,
            isFavorite: isFavorite,
            onSelect: onSelect
        )

        let hostingController = UIHostingController(rootView: cardView)
        self.hostingController = hostingController

        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

