//
//  FilmListView.swift
//  GhibliApp
//
//  Created by Кирилл on 21.03.2026.
//

import SwiftUI

struct FilmListView: View {
    
    // MARK: - Properties
    @State private var filmsViewModel = FilmsViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            switch filmsViewModel.state {
            case .idle:
                Text("No films yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let films):
                List(films) { film in
                    NavigationLink(value: film) {
                        FilmRow(film: film)
                    }
                    
                }
                .navigationDestination(for: Film.self) { film in
                    FilmDetailView(film: film)
                }
            case .error(let error):
                Text(error)
            }
        }
        .task {
            await filmsViewModel.fetch()
        }
    }
    
}

private struct FilmRow: View {
    
    // MARK: - Properties
    let film: Film
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            FilmImageView(urlPath: film.image)
                .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(film.title)
                        .bold()
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

// MARK: - Preview
#Preview {
    FilmListView()
}
