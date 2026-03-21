//
//  GhibliService.swift
//  GhibliApp
//
//  Created by Кирилл on 21.03.2026.
//

import Foundation

protocol GhibliService: Sendable {
    func fetchFilms() async throws -> [Film]
    func fetchPerson(from URLString: String) async throws -> Person
    
    func searchFilm(for searchTerm: String) async throws -> [Film]
}
