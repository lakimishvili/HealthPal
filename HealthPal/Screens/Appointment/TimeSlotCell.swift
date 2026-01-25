//
//  TimeSlotCell.swift
//  HealthPal
//
//  Created by LILIANA on 1/20/26.
//

import UIKit

final class TimeSlotCell: UICollectionViewCell {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 0
        contentView.backgroundColor = .systemGray6

        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with slot: TimeSlot, selected: Bool) {
        label.text = slot.time

        if selected {
            contentView.backgroundColor = .black
            label.textColor = .white
        } else {
            contentView.backgroundColor = .systemGray6
            label.textColor = .black
        }

        contentView.layer.borderWidth = 0
        isUserInteractionEnabled = slot.available
        label.alpha = slot.available ? 1 : 0.5
    }
}
