//
//  SettingsScreen.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import SwiftUI
import UserNotifications

struct SettingsScreen: View {
    
    // MARK: - Properties
    @AppStorage("selectedAppearance") private var selectedAppearance = Appearance.system
    @AppStorage("itemsPerPage") private var itemsPerPage = 20
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @State private var notificationPermissionDenied = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            SettingsView(
                selectedAppearance: $selectedAppearance,
                itemsPerPage: $itemsPerPage,
                notificationsEnabled: $notificationsEnabled,
                notificationPermissionDenied: notificationPermissionDenied,
                setNotificationsEnabled: setNotificationsEnabled,
                resetSettings: resetSettings
            )
            .navigationTitle("Settings")
        }
    }
    
    // MARK: - Private Methods
    private func setNotificationsEnabled(_ isEnabled: Bool) {
        if isEnabled {
            Task {
                let isAllowed = await requestNotificationPermission()
                await MainActor.run {
                    notificationsEnabled = isAllowed
                    notificationPermissionDenied = !isAllowed
                }
            }
        } else {
            notificationsEnabled = false
            notificationPermissionDenied = false
        }
    }
    
    private func requestNotificationPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
        } catch {
            return false
        }
    }
    
    private func resetSettings() {
        selectedAppearance = .system
        itemsPerPage = 20
        notificationsEnabled = false
        notificationPermissionDenied = false
    }
    
}

#Preview {
    SettingsScreen()
}
