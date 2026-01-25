//
//  StatIconView.swift
//  HealthPal
//
//  Created by LILIANA on 1/19/26.
//

import UIKit

final class StatIconView: UIView {

    let iconContainerView = UIView()
    let iconImageView = UIImageView()
    let valueLabel = UILabel()
    let titleLabel = UILabel()

    init(icon: String, value: String, title: String) {
        super.init(frame: .zero)
        setupUI()

        iconImageView.image = UIImage(systemName: icon)
        valueLabel.text = value
        titleLabel.text = title
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = .systemGray5
        iconContainerView.layer.cornerRadius = 18

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .black
        iconImageView.contentMode = .scaleAspectFit

        iconContainerView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconContainerView.widthAnchor.constraint(equalToConstant: 36),
            iconContainerView.heightAnchor.constraint(equalToConstant: 36),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 18)
        ])

        let stack = UIStackView(arrangedSubviews: [
            iconContainerView,
            valueLabel,
            titleLabel
        ])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        valueLabel.font = .boldSystemFont(ofSize: 16)

        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .gray
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
    }
}
