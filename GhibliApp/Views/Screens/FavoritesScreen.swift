//
//  FavoritesScreen.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import CoreData
import SwiftUI

struct FavoritesScreen: View {
    
    // MARK: - Properties
    @State private var searchText = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteFilm.addedAt, ascending: false)],
        animation: .default
    ) private var favoriteFilms: FetchedResults<FavoriteFilm>
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            FavoritesView(
                favoriteFilms: favoriteFilms,
                searchText: $searchText
            )
            .navigationTitle("Favorites")
            .searchable(text: $searchText, prompt: "Search favorites")
            .navigationDestination(for: Film.self) { film in
                FilmDetailView(film: film)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    FavoritesScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
