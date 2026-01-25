//
//  NotificationsView.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//
import SwiftUI

struct NotificationsView: View {
    @StateObject var viewModel: NotificationsViewModel

    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                }

                ForEach(viewModel.sortedKeys, id: \.self) { key in
                    let items = viewModel.groupedNotifications[key] ?? []

                    Section(header: SectionHeader(key: key, items: items, viewModel: viewModel)) {
                        ForEach(items) { notif in
                            NotificationRow(notif: notif)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Notifications")
            .refreshable { viewModel.fetchNotifications() }
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let key: String
    let items: [NotificationItem]
    let viewModel: NotificationsViewModel

    var body: some View {
        HStack {
            Text(key)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Button("Mark all as read") {
                viewModel.markAllAsRead(for: items)
            }
            .font(.subheadline)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Notification Row (Simplified Icon)
struct NotificationRow: View {
    let notif: NotificationItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "bell.fill")
                .frame(width: 36, height: 36)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(notif.message)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(timeAgo(from: notif.createdAt))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }

    func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        if minutes < 60 { return "\(minutes)m" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h" }
        let days = hours / 24
        return "\(days)d"
    }
}
