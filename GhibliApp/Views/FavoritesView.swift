//
//  FavoritesView.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import CoreData
import SwiftUI

struct FavoritesView: View {
    
    // MARK: - Properties
    let favoriteFilms: FetchedResults<FavoriteFilm>
    @Binding var searchText: String
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - Body
    var body: some View {
        let filteredFilms = filteredFavoriteFilms
        
        Group {
            if favoriteFilms.isEmpty {
                ContentUnavailableView(
                    "No Favorites Yet",
                    systemImage: "heart",
                    description: Text("Favorite films will appear here.")
                )
            } else if filteredFilms.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                List {
                    ForEach(filteredFilms) { favoriteFilm in
                        HStack(spacing: 12) {
                            NavigationLink(value: favoriteFilm.filmValue) {
                                FavoriteFilmRow(favoriteFilm: favoriteFilm)
                            }
                            
                            FavoriteButton(isFavorite: true) {
                                FavoriteFilmsStore.remove(favoriteFilm, from: viewContext)
                            }
                        }
                    }
                    .onDelete { offsets in
                        deleteFavorites(at: offsets, from: filteredFilms)
                    }
                }
            }
        }
    }
    
    private var filteredFavoriteFilms: [FavoriteFilm] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let films = Array(favoriteFilms)
        
        guard !trimmedSearchText.isEmpty else {
            return films
        }
        
        return films.filter { favoriteFilm in
            favoriteFilm.displayTitle.localizedStandardContains(trimmedSearchText)
            || favoriteFilm.displayDirector.localizedStandardContains(trimmedSearchText)
            || favoriteFilm.displayReleaseYear.localizedStandardContains(trimmedSearchText)
        }
    }
    
    private func deleteFavorites(at offsets: IndexSet, from favoriteFilms: [FavoriteFilm]) {
        offsets
            .map { favoriteFilms[$0] }
            .forEach { FavoriteFilmsStore.remove($0, from: viewContext) }
    }
    
}

private struct FavoriteFilmRow: View {
    
    // MARK: - Properties
    let favoriteFilm: FavoriteFilm
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            FilmImageView(urlPath: favoriteFilm.image ?? "")
                .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                Text(favoriteFilm.displayTitle)
                    .bold()
                    .padding(.bottom, 5)
                
                Text("Directed by \(favoriteFilm.displayDirector)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Released: \(favoriteFilm.displayReleaseYear)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
        }
    }
    
}

#Preview("Screen") {
    FavoritesScreen()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
