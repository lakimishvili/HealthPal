//
//  BookingCell.swift
//  HealthPal
//
//  Created by LILIANA on 1/20/26.
//
import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func load(from url: URL, placeholder: UIImage? = nil) {
        image = placeholder

        if let cached = imageCache.object(forKey: url.absoluteString as NSString) {
            image = cached
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url),
               let img = UIImage(data: data) {
                imageCache.setObject(img, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }
    }
}

final class BookingCell: UITableViewCell {

    var onCancelTapped: (() -> Void)?
    var onRescheduleTapped: (() -> Void)?

    // MARK: - UI
    private let cardView = UIView()
    private let dateLabel = UILabel()
    private let statusLabel = UILabel() 
    private let topSeparator = UIView()
    private let doctorImageView = UIImageView()
    private let doctorNameLabel = UILabel()
    private let specialtyLabel = UILabel()
    private let clinicLabel = UILabel()
    private let buttonStack = UIStackView()
    private let cancelButton = UIButton(type: .system)
    private let rescheduleButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        rescheduleButton.addTarget(self, action: #selector(rescheduleTapped), for: .touchUpInside)
    }

    @objc private func cancelTapped() { onCancelTapped?() }
    @objc private func rescheduleTapped() { onRescheduleTapped?() }

    func configure(appointment: Appointment, isUpcoming: Bool) {
        dateLabel.text = appointment.date + " • " + appointment.time

        statusLabel.isHidden = false
        if isUpcoming {
            statusLabel.text = appointment.status.capitalized
            statusLabel.textColor = .systemBlue
        } else {
            statusLabel.text = appointment.status.capitalized
            statusLabel.textColor = appointment.status == "cancelled" ? .systemRed : .systemGreen
        }

        doctorNameLabel.text = "\(appointment.doctorName ?? "") \(appointment.doctorSurname ?? "")"
        if let category = appointment.doctorCategory {
            specialtyLabel.text = category.prefix(1).uppercased() + category.dropFirst()
        } else {
            specialtyLabel.text = "Doctor"
        }
        clinicLabel.text = appointment.hospitalName

        if let image = appointment.doctorImage, let url = URL(string: image) {
            doctorImageView.load(from: url, placeholder: UIImage(systemName: "photo"))
        } else {
            doctorImageView.image = UIImage(systemName: "photo")
        }

        cancelButton.isHidden = !isUpcoming
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal) // make sure text is black
        rescheduleButton.setTitle(isUpcoming ? "Reschedule" : "Re-book", for: .normal)
    }

    // MARK: - UI Setup
    private func setupUI() {
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        dateLabel.font = .boldSystemFont(ofSize: 15)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        topSeparator.backgroundColor = UIColor.systemGray5
        topSeparator.translatesAutoresizingMaskIntoConstraints = false

        doctorImageView.layer.cornerRadius = 10
        doctorImageView.clipsToBounds = true
        doctorImageView.translatesAutoresizingMaskIntoConstraints = false

        doctorNameLabel.font = .boldSystemFont(ofSize: 16)
        specialtyLabel.font = .systemFont(ofSize: 14)
        specialtyLabel.textColor = .gray
        clinicLabel.font = .systemFont(ofSize: 14)
        clinicLabel.textColor = .gray

        cancelButton.backgroundColor = .systemGray5
        cancelButton.layer.cornerRadius = 16
        cancelButton.titleLabel?.font = .boldSystemFont(ofSize: 14)

        rescheduleButton.backgroundColor = .black
        rescheduleButton.setTitleColor(.white, for: .normal)
        rescheduleButton.layer.cornerRadius = 16
        rescheduleButton.titleLabel?.font = .boldSystemFont(ofSize: 14)

        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(rescheduleButton)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        let infoStack = UIStackView(arrangedSubviews: [
            doctorNameLabel,
            specialtyLabel,
            clinicLabel
        ])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        let doctorStack = UIStackView(arrangedSubviews: [
            doctorImageView,
            infoStack
        ])
        doctorStack.spacing = 8
        doctorStack.alignment = .top
        doctorStack.translatesAutoresizingMaskIntoConstraints = false

        [dateLabel, statusLabel, topSeparator, doctorStack, buttonStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            dateLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

            statusLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            topSeparator.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            topSeparator.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1),

            doctorStack.topAnchor.constraint(equalTo: topSeparator.bottomAnchor, constant: 12),
            doctorStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            doctorStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            doctorImageView.widthAnchor.constraint(equalToConstant: 90),
            doctorImageView.heightAnchor.constraint(equalToConstant: 90),

            buttonStack.topAnchor.constraint(equalTo: doctorStack.bottomAnchor, constant: 12),
            buttonStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            buttonStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 36),
            rescheduleButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}
