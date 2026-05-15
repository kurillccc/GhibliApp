//
//  SettingsView.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    @Binding var selectedAppearance: Appearance
    @Binding var itemsPerPage: Int
    @Binding var notificationsEnabled: Bool
    let notificationPermissionDenied: Bool
    let setNotificationsEnabled: (Bool) -> Void
    let resetSettings: () -> Void
    
    // MARK: - Body
    var body: some View {
        Form {
            Section {
                Picker("Theme", selection: $selectedAppearance) {
                    ForEach(Appearance.allCases) { appearance in
                        Text(appearance.title)
                            .tag(appearance)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Appearance")
            } footer: {
                Text("Changes the app appearance immediately and saves the choice.")
            }
            
            Section {
                Stepper(value: $itemsPerPage, in: 5...50, step: 5) {
                    Text("Films per page: \(itemsPerPage)")
                }
            } header: {
                Text("Films")
            } footer: {
                Text("Controls how many films are shown in the Films tab.")
            }
            
            Section {
                Toggle(
                    "Enable notifications",
                    isOn: Binding(
                        get: { notificationsEnabled },
                        set: { setNotificationsEnabled($0) }
                    )
                )
                
                if notificationPermissionDenied {
                    Text("Notifications are disabled in system settings.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            } header: {
                Text("Notifications")
            }
            
            Section {
                LabeledContent("Registration") {
                    Text("Not available")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Account")
            } footer: {
                Text("User registration is not implemented in this version.")
            }
            
            Section {
                Button(role: .destructive) {
                    resetSettings()
                } label: {
                    Text("Reset to Defaults")
                }
            }
        }
    }
    
}

enum Appearance: String, CaseIterable, Identifiable {
    
    // MARK: - Cases
    case system
    case light
    case dark
    
    // MARK: - Properties
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

// MARK: - Preview
#Preview("View") {
    SettingsView(
        selectedAppearance: .constant(.system),
        itemsPerPage: .constant(20),
        notificationsEnabled: .constant(false),
        notificationPermissionDenied: false,
        setNotificationsEnabled: { _ in },
        resetSettings: {}
    )
}
