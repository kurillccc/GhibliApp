//
//  FilmListView.swift
//  GhibliApp
//
//  Created by Кирилл on 21.03.2026.
//

import CoreData
import SwiftUI

struct FilmListView: View {
    
    // MARK: - Properties
    let state: LoadingState<[Film]>
    @Binding var searchText: String
    let itemsPerPage: Int
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteFilm.addedAt, ascending: false)],
        animation: .default
    ) private var favoriteFilms: FetchedResults<FavoriteFilm>
    
    // MARK: - Body
    var body: some View {
        switch state {
        case .idle:
            Text("No films yet")
        case .loading:
            ProgressView {
                Text("Loading...")
            }
        case .loaded(let films):
            let filteredFilms = filteredFilms(from: films)
            let visibleFilms = Array(filteredFilms.prefix(itemsPerPage))
            
            if filteredFilms.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                List {
                    ForEach(visibleFilms) { film in
                        NavigationLink(value: film) {
                            FilmRow(
                                film: film,
                                isFavorite: FavoriteFilmsStore.isFavorite(film, in: favoriteFilms)
                            ) {
                                FavoriteFilmsStore.toggle(film, in: viewContext)
                            }
                        }
                    }
                    
                    if filteredFilms.count > visibleFilms.count {
                        Text("Showing \(visibleFilms.count) of \(filteredFilms.count) films")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        case .error(let error):
            VStack(spacing: 8) {
                Text(error)
                    .multilineTextAlignment(.center)
                Text("Try turning on your VPN")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
    
    // MARK: - Private Methods
    private func filteredFilms(from films: [Film]) -> [Film] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedSearchText.isEmpty else {
            return films
        }
        
        return films.filter { film in
            film.title.localizedStandardContains(trimmedSearchText)
            || film.director.localizedStandardContains(trimmedSearchText)
            || film.releaseYear.localizedStandardContains(trimmedSearchText)
        }
    }
    
}

private struct FilmRow: View {
    
    // MARK: - Properties
    let film: Film
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            FilmImageView(urlPath: film.image)
                .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(film.title)
                        .bold()
                    
                    Spacer()
                    
                    FavoriteButton(isFavorite: isFavorite, action: toggleFavorite)
                }
                .padding(.bottom, 5)
                
                Text("Directed by \(film.director)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Released: \(film.releaseYear)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
        }
    }
    
}

