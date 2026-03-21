//
//  FilmListView.swift
//  GhibliApp
//
//  Created by Кирилл on 21.03.2026.
//

import SwiftUI

struct FilmListView: View {
    
    @State private var filmsViewModel = FilmsViewModel()
    
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
                    Text(film.title)
                        
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

#Preview {
    FilmListView()
}
