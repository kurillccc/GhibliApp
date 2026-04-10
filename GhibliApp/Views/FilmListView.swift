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
                    NavigationLink(film.title, value: film)
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

// MARK: - Preview
#Preview {
    FilmListView()
}
