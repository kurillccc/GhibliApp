//
//  FilmsViewModel.swift
//  GhibliApp
//
//  Created by Кирилл on 21.03.2026.
//

import Foundation
import Observation

@Observable
final class FilmsViewModel {
    
    // MARK: - Properties
    var state: LoadingState<[Film]> = .idle
    private let service: GhibliService
    
    // MARK: - Initializers
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func fetch() async {
        guard !state.isLoading || state.error != nil else { return }
        
        state = .loading
        
        do {
            let films = try await service.fetchFilms()
            self.state = .loaded(films)
        } catch let error as APIError {
            self.state = .error(error.errorDescription ?? "unknown error")
        } catch {
            self.state = .error("unknown error")
        }
    }
    
}
