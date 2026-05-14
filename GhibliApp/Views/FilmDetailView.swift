//
//  FilmDetailView.swift
//  GhibliApp
//
//  Created by Кирилл on 10.04.2026.
//

import CoreData
import SwiftUI

struct FilmDetailView: View {
    
    // MARK: - Properties
    let film: Film
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteFilm.addedAt, ascending: false)],
        animation: .default
    ) private var favoriteFilms: FetchedResults<FavoriteFilm>
    @State private var viewModel = FilmDetailViewModel()
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 7) {
                FilmImageView(urlPath: film.bannerImage)
                    .frame(height: 300)
                    .containerRelativeFrame(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(film.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Grid(alignment: .leading) {
                        InfoRow(label: "Director", value: film.director)
                        InfoRow(label: "Producer", value: film.producer)
                        InfoRow(label: "Release Date", value: film.releaseYear)
                        InfoRow(label: "Running Time", value: "\(film.duration) minutes")
                        InfoRow(label: "Score", value: "\(film.score)/100")
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    Text("Description")
                        .font(.headline)
                    
                    Text(film.description)
                    
                    Divider()
                    
                    CharacterSectionView(viewModel: viewModel)
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButton(
                    isFavorite: FavoriteFilmsStore.isFavorite(film, in: favoriteFilms)
                ) {
                    FavoriteFilmsStore.toggle(film, in: viewContext)
                }
            }
        }
        .task(id: film) {
            await viewModel.fetch(for: film)
        }
    }
    
}

// MARK: - Info Row Component
fileprivate struct InfoRow: View {
    
    let label: String
    let value: String
    
    var body: some View {
        GridRow {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
            
        }
    }
    
}

// MARK: - Character Section Component
fileprivate struct CharacterSectionView:  View {
    
    let viewModel: FilmDetailViewModel
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Text("Characters")
                    .font(.headline)
                
                switch viewModel.state {
                case .idle: EmptyView()
                case .loading:  ProgressView()
                    
                case .loaded(let people):
                    ForEach(people) { person in
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(person.name)
                            
                            HStack(spacing: 8) {
                                Label(person.gender, systemImage: "person.fill")
                                
                                Text("Age: \(person.age)")
                                Spacer()
                                Label(person.eyeColor, systemImage: "eye")
                                Text("Hair: \(person.hairColor)")
                            }
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .lineLimit(1)
                            
                        }
                    }
                    
                case .error(let error):
                    Text(error)
                        .foregroundStyle(.pink)
                }
            }
        }
    }
    
}
