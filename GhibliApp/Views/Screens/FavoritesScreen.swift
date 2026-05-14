//
//  FavoritesScreen.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import SwiftUI

struct FavoritesScreen: View {
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            FavoritesView()
                .navigationTitle("Favorites")
        }
    }
    
}
