//
//  ContentView.swift
//  GhibliApp
//
//  Created by Кирилл on 20.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @AppStorage("selectedAppearance") private var selectedAppearance = Appearance.system
    @AppStorage("itemsPerPage") private var itemsPerPage = 20
    @State private var filmsViewModel = FilmsViewModel()

    // MARK: - Body
    var body: some View {
        TabView {
            FilmsScreen(
                filmsViewModel: filmsViewModel,
                itemsPerPage: itemsPerPage
            )
            .tabItem {
                Label("Films", systemImage: "film")
            }
            
            FavoritesScreen()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            
            SettingsScreen()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .preferredColorScheme(selectedAppearance.colorScheme)
    }
    
}

// MARK: - Preview
#Preview {
    ContentView()
}
