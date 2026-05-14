//
//  FavoritesView.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import SwiftUI

struct FavoritesView: View {
    
    // MARK: - Body
    var body: some View {
        ContentUnavailableView(
            "No Favorites Yet",
            systemImage: "heart",
            description: Text("Favorite films will appear here.")
        )
    }
    
}

#Preview("Screen") {
    FavoritesScreen()
}

#Preview("View") {
    FavoritesView()
}
