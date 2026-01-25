//
//  NotificationsViewModel.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//
import Foundation
internal import Combine

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    let userId: Int

    init(userId: Int) {
        self.userId = userId
        fetchNotifications()
    }

    func fetchNotifications() {
        isLoading = true
        errorMessage = nil

        NotificationService.shared.fetchNotifications(userId: userId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let items):
                    self.notifications = items.sorted(by: { $0.createdAt > $1.createdAt })
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func markAsRead(_ notification: NotificationItem) {
        NotificationService.shared.markAsRead(notificationId: notification.id) { success in
            if success {
                DispatchQueue.main.async {
                    if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                        self.notifications[index].read = true
                    }
                }
            }
        }
    }

    func markAllAsRead(for dates: [NotificationItem]) {
        for notif in dates {
            markAsRead(notif)
        }
    }

    var groupedNotifications: [String: [NotificationItem]] {
        Dictionary(grouping: notifications) { notif in
            let calendar = Calendar.current
            if calendar.isDateInToday(notif.createdAt) {
                return "Today"
            } else if calendar.isDateInYesterday(notif.createdAt) {
                return "Yesterday"
            } else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter.string(from: notif.createdAt)
            }
        }
    }

    var sortedKeys: [String] {
        groupedNotifications.keys.sorted { key1, key2 in
            if key1 == "Today" { return true }
            if key2 == "Today" { return false }
            if key1 == "Yesterday" { return true }
            if key2 == "Yesterday" { return false }
            return key1 > key2
        }
    }
}
