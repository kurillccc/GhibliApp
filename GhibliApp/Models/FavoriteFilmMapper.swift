//
//  FavoriteFilmMapper.swift
//  GhibliApp
//
//  Created by Кирилл on 14.05.2026.
//

import CoreData
import Foundation
import SwiftUI

struct FavoriteFilmsStore {
    
    static func isFavorite(_ film: Film, in favoriteFilms: FetchedResults<FavoriteFilm>) -> Bool {
        favoriteFilms.contains { $0.id == film.id }
    }
    
    static func toggle(_ film: Film, in context: NSManagedObjectContext) {
        if let favoriteFilm = fetchFavoriteFilm(id: film.id, in: context) {
            context.delete(favoriteFilm)
        } else {
            let favoriteFilm = FavoriteFilm(context: context)
            favoriteFilm.update(from: film)
        }
        
        save(context)
    }
    
    static func remove(_ favoriteFilm: FavoriteFilm, from context: NSManagedObjectContext) {
        context.delete(favoriteFilm)
        save(context)
    }
    
    private static func fetchFavoriteFilm(id: String, in context: NSManagedObjectContext) -> FavoriteFilm? {
        let request = FavoriteFilm.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            return try context.fetch(request).first
        } catch {
            return nil
        }
    }
    
    private static func save(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
    
}

extension FavoriteFilm {
    
    var displayTitle: String {
        title ?? "Unknown Film"
    }
    
    var displayDirector: String {
        director ?? "Unknown Director"
    }
    
    var displayReleaseYear: String {
        releaseYear ?? "Unknown Year"
    }
    
    var filmValue: Film {
        Film(
            id: id ?? UUID().uuidString,
            title: displayTitle,
            description: filmDescription ?? "",
            director: displayDirector,
            producer: producer ?? "",
            releaseYear: displayReleaseYear,
            score: score ?? "",
            duration: duration ?? "",
            image: image ?? "",
            bannerImage: bannerImage ?? "",
            people: decodedPeople
        )
    }
    
    func update(from film: Film) {
        id = film.id
        title = film.title
        filmDescription = film.description
        director = film.director
        producer = film.producer
        releaseYear = film.releaseYear
        score = film.score
        duration = film.duration
        image = film.image
        bannerImage = film.bannerImage
        peopleJSON = encodedPeople(from: film.people)
        addedAt = Date()
    }
    
    private var decodedPeople: [String] {
        guard
            let peopleJSON,
            let data = peopleJSON.data(using: .utf8),
            let people = try? JSONDecoder().decode([String].self, from: data)
        else {
            return []
        }
        
        return people
    }
    
    private func encodedPeople(from people: [String]) -> String {
        guard
            let data = try? JSONEncoder().encode(people),
            let json = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        
        return json
    }
    
}
