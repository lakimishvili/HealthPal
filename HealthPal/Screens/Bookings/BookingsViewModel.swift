//
//  BookingsViewModel.swift
//  HealthPal
//
//  Created by LILIANA on 1/20/26.
//

import Foundation

final class BookingsViewModel {

    private let userId: Int
    private(set) var appointments: [Appointment] = []
    private(set) var filteredAppointments: [Appointment] = []

    var onDataUpdated: (() -> Void)?

    init(userId: Int) {
        self.userId = userId
    }

    // MARK: - Load appointments
    func loadAppointments() {
        guard let url = URL(string: "http://localhost:3000/api/appointments/my/\(userId)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else { return }

            do {
                let appointments = try JSONDecoder().decode([Appointment].self, from: data)
                DispatchQueue.main.async {
                    self.appointments = appointments
                    self.filterAppointments(upcoming: true)
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }

    // MARK: - Filter
    func filterAppointments(upcoming: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let now = Date()

        filteredAppointments = appointments.filter { appt in
            let apptDate = formatter.date(from: "\(appt.date) \(appt.time)") ?? now

            if upcoming {
                return appt.status == "booked" && apptDate > now
            } else {
                return appt.status == "cancelled" || apptDate < now
            }
        }

        onDataUpdated?()
    }

    // MARK: - Cell info
    func appointment(at index: Int) -> Appointment {
        filteredAppointments[index]
    }

    func isUpcoming(at index: Int) -> Bool {
        filteredAppointments[index].status == "booked"
    }

    // MARK: - Cancel
    func cancelAppointment(_ appointment: Appointment) {

        guard let url = URL(
            string: "http://localhost:3000/api/appointments/cancel/\(appointment.id)/\(userId)"
        ) else {
            print("Invalid cancel URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error {
                print("Cancel error:", error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Cancel failed")
                return
            }

            DispatchQueue.main.async {
                if let idx = self.appointments.firstIndex(where: { $0.id == appointment.id }) {
                    self.appointments[idx].status = "cancelled"
                }

                self.filterAppointments(upcoming: true)
            }
        }.resume()
    }
    
    func loadAppointmentsAndFilter(upcoming: Bool) {
        guard let url = URL(string: "http://localhost:3000/api/appointments/my/\(userId)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else { return }

            do {
                let appointments = try JSONDecoder().decode([Appointment].self, from: data)

                DispatchQueue.main.async {
                    self.appointments = appointments
                    self.filterAppointments(upcoming: upcoming)
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }

}
