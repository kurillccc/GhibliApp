//
//  FavoriteButton.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import SwiftUI

struct FavoriteButton: View {
    
    // MARK: - Properties
    let isFavorite: Bool
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(isFavorite ? .red : .secondary)
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }
    
}

// MARK: - Preview
#Preview {
    FavoriteButton(isFavorite: true) {}
}
