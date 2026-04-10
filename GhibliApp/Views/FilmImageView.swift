//
//  FilmImageView.swift
//  GhibliApp
//
//  Created by Кирилл on 10.04.2026.
//

import SwiftUI

struct FilmImageView: View {
    
    // MARK: - Properties
    let url: URL?
    
    // MARK: - Initializers
    init(urlPath: String) {
        self.url = URL(string: urlPath)
    }
    
    init(url: URL?) {
        self.url = url
    }
    
    // MARK: - Body
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Color(white: 0.8)
                    .overlay {
                        ProgressView()
                            .controlSize(.large)
                    }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
            case .failure(_):
                Text("Could not get image")
            @unknown default:
                fatalError()
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    FilmImageView(urlPath: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg")
}
