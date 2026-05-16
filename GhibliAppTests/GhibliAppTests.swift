//
//  GhibliAppTests.swift
//  GhibliAppTests
//
//  Created by Кирилл on 20.03.2026.
//

import Foundation
import Testing
@testable import GhibliApp

@MainActor
struct GhibliAppTests {
    
    actor MockGhibliService: GhibliService {
        
        // MARK: - Properties
        let films: [Film]
        let people: [String: Person]
        let shouldThrowFilmsError: Bool
        let shouldThrowPersonError: Bool
        let fetchDelay: Duration
        
        private(set) var fetchFilmsCallCount = 0
        private(set) var fetchPersonCallCount = 0
        private(set) var requestedPersonURLs: [String] = []
        
        // MARK: - Initializers
        init(
            films: [Film],
            people: [String: Person] = [:],
            shouldThrowFilmsError: Bool = false,
            shouldThrowPersonError: Bool = false,
            fetchDelay: Duration = .zero
        ) {
            self.films = films
            self.people = people
            self.shouldThrowFilmsError = shouldThrowFilmsError
            self.shouldThrowPersonError = shouldThrowPersonError
            self.fetchDelay = fetchDelay
        }
        
        // MARK: - GhibliService
        func fetchFilms() async throws -> [Film] {
            fetchFilmsCallCount += 1
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            if shouldThrowFilmsError {
                throw APIError.networkError(NSError(domain: "GhibliAppTests", code: -1))
            }
            
            return films
        }
        
        func fetchPerson(from URLString: String) async throws -> Person {
            fetchPersonCallCount += 1
            requestedPersonURLs.append(URLString)
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            if shouldThrowPersonError {
                throw APIError.networkError(NSError(domain: "GhibliAppTests", code: -2))
            }
            
            return people[URLString] ?? Person(
                id: URLString,
                name: "Unknown",
                gender: "Unknown",
                age: "Unknown",
                eyeColor: "Unknown",
                hairColor: "Unknown",
                films: [],
                species: "Unknown",
                url: URLString
            )
        }
        
        func searchFilm(for searchTerm: String) async throws -> [Film] {
            films
        }
        
    }
    
    // MARK: - Test Data
    let mockFilms = [
        Film(
            id: "1",
            title: "My Neighbor Totoro",
            description: "Two sisters discover Totoro.",
            director: "Hayao Miyazaki",
            producer: "Toru Hara",
            releaseYear: "1988",
            score: "93",
            duration: "86",
            image: "",
            bannerImage: "",
            people: ["people/1", "people/2"]
        ),
        Film(
            id: "2",
            title: "Spirited Away",
            description: "A girl enters a spirit world.",
            director: "Hayao Miyazaki",
            producer: "Toshio Suzuki",
            releaseYear: "2001",
            score: "97",
            duration: "125",
            image: "",
            bannerImage: "",
            people: []
        ),
        Film(
            id: "3",
            title: "Princess Mononoke",
            description: "A prince fights to save the forest.",
            director: "Hayao Miyazaki",
            producer: "Toshio Suzuki",
            releaseYear: "1997",
            score: "92",
            duration: "134",
            image: "",
            bannerImage: "",
            people: []
        )
    ]
    
    let mockPeople = [
        "people/1": Person(
            id: "person-1",
            name: "Satsuki Kusakabe",
            gender: "Female",
            age: "11",
            eyeColor: "Brown",
            hairColor: "Brown",
            films: ["1"],
            species: "Human",
            url: "people/1"
        ),
        "people/2": Person(
            id: "person-2",
            name: "Mei Kusakabe",
            gender: "Female",
            age: "4",
            eyeColor: "Brown",
            hairColor: "Brown",
            films: ["1"],
            species: "Human",
            url: "people/2"
        )
    ]
    
    // MARK: - FilmsViewModel Tests
    @Test("FilmsViewModel starts in idle state")
    func filmsViewModelInitialState() {
        let service = MockGhibliService(films: mockFilms)
        let viewModel = FilmsViewModel(service: service)
        
        #expect(viewModel.state.data == nil)
        #expect(viewModel.state.error == nil)
        #expect(viewModel.state == .idle)
    }
    
    @Test("FilmsViewModel loads films from service")
    func filmsViewModelFetchSuccess() async {
        let service = MockGhibliService(films: mockFilms)
        let viewModel = FilmsViewModel(service: service)
        
        await viewModel.fetch()
        
        #expect(viewModel.state.data == mockFilms)
        #expect(viewModel.state.error == nil)
        #expect(await service.fetchFilmsCallCount == 1)
    }
    
    @Test("FilmsViewModel exposes error when service fails")
    func filmsViewModelFetchError() async {
        let service = MockGhibliService(
            films: mockFilms,
            shouldThrowFilmsError: true
        )
        let viewModel = FilmsViewModel(service: service)
        
        await viewModel.fetch()
        
        #expect(viewModel.state.data == nil)
        #expect(viewModel.state.error != nil)
        #expect(await service.fetchFilmsCallCount == 1)
    }
    
    @Test("FilmsViewModel ignores a second fetch while loading")
    func filmsViewModelSkipsDuplicateLoadingRequest() async {
        let service = MockGhibliService(
            films: mockFilms,
            fetchDelay: .milliseconds(200)
        )
        let viewModel = FilmsViewModel(service: service)
        
        let firstFetch = Task {
            await viewModel.fetch()
        }
        
        try? await Task.sleep(for: .milliseconds(50))
        await viewModel.fetch()
        await firstFetch.value
        
        #expect(await service.fetchFilmsCallCount == 1)
        #expect(viewModel.state.data == mockFilms)
    }
    
    // MARK: - FilmDetailViewModel Tests
    @Test("FilmDetailViewModel loads people for film")
    func filmDetailViewModelFetchesPeople() async {
        let service = MockGhibliService(
            films: mockFilms,
            people: mockPeople
        )
        let viewModel = FilmDetailViewModel(service: service)
        
        await viewModel.fetch(for: mockFilms[0])
        
        let loadedNames = Set(viewModel.state.data?.map(\.name) ?? [])
        #expect(loadedNames == ["Satsuki Kusakabe", "Mei Kusakabe"])
        #expect(await service.fetchPersonCallCount == 2)
        #expect(Set(await service.requestedPersonURLs) == ["people/1", "people/2"])
    }
    
    @Test("FilmDetailViewModel exposes error when person loading fails")
    func filmDetailViewModelFetchPeopleError() async {
        let service = MockGhibliService(
            films: mockFilms,
            people: mockPeople,
            shouldThrowPersonError: true
        )
        let viewModel = FilmDetailViewModel(service: service)
        
        await viewModel.fetch(for: mockFilms[0])
        
        #expect(viewModel.state.data == nil)
        #expect(viewModel.state.error != nil)
    }
    
}
