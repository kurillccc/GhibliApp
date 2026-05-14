//
//  FilmsScreen.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import SwiftUI

struct FilmsScreen: View {
    
    // MARK: - Properties
    @State private var searchText = ""
    let filmsViewModel: FilmsViewModel
    let itemsPerPage: Int
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            FilmListView(
                state: filmsViewModel.state,
                searchText: $searchText,
                itemsPerPage: itemsPerPage
            )
            .navigationTitle("Films")
            .searchable(text: $searchText, prompt: "Search films")
            .navigationDestination(for: Film.self) { film in
                FilmDetailView(film: film)
            }
        }
        .task {
            await filmsViewModel.fetch()
        }
    }
    
}
