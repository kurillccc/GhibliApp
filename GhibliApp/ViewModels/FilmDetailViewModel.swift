//
//  FilmDetailViewModel.swift
//  GhibliApp
//
//  Created by Кирилл on 09.04.2026.
//

import Foundation
import Observation

@Observable
final class FilmDetailViewModel {
    
    // MARK: - Properties
    var state: LoadingState<[Person]> = .idle
    private let service: GhibliService

    // MARK: - Initializers
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func fetch(for film: Film) async {
        guard !state.isLoading else { return }
        
        state = .loading
        
        var loadedPeople: [Person] = []
        
        do {
            try await withThrowingTaskGroup(of: Person.self) { group in
                
                for personInfoURL in film.people {
                    group.addTask {
                        try await self.service.fetchPerson(from: personInfoURL)
                    }
                }
                
                for try await person in group {
                    loadedPeople.append(person)
                }
            }
            
            state = .loaded(loadedPeople)
            
            
        }  catch let error as APIError {
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }
    
}
