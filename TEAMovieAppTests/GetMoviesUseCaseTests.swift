//
//  GetMoviesUseCaseTests.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 12/08/2025.
//

import XCTest
import Combine
@testable import TEAMovieApp

final class GetMoviesUseCaseTests: XCTestCase {
    
    var sut: GetMoviesUseCase! // System Under Test
    var repositoryMock: MoviesRepositoryMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        repositoryMock = MoviesRepositoryMock()
        sut = GetMoviesUseCase(repository: repositoryMock)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        repositoryMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_execute_whenCacheHasData_returnsCachedMovies() {
        // Given
        let cachedMovies = [Movie(id: 1, title: "Test", posterPath: nil, backdropPath: nil, voteAverage: 7.5, releaseDate: "2025-01-01", originalLanguage: "en", overview: "Overview", isFavorite: false, voteCount: 100)]
        repositoryMock.cachedMovies = cachedMovies
        
        let expectation = XCTestExpectation(description: "Should return cached movies")
        
        // When
        sut.execute(page: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { movies in
                // Then
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "Test")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_execute_whenCacheEmptyAndInternetConnected_returnsApiMovies() {
        // Given
        let networkMock = MockNetworkMonitor()
            networkMock.isConnected = true
            
        repositoryMock.cachedMovies = []
        let apiMoviesDTO = [MovieDTO(id: 2, title: "API Movie", posterPath: nil, backdropPath: nil, voteAverage: 8.0, releaseDate: "2025-02-01", overview: "Overview", originalLanguage: "en", voteCount: 200)]
        repositoryMock.apiMovies = apiMoviesDTO
        
        let expectation = XCTestExpectation(description: "Should fetch movies from API when cache is empty")
        
        // When
        sut.execute(page: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { movies in
                // Then
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.title, "API Movie")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_execute_whenCacheEmptyAndNoInternet_returnsEmptyArray() {
        // Given
        let networkMock = MockNetworkMonitor()
            networkMock.isConnected = true
        networkMock.isConnected = false
        repositoryMock.cachedMovies = []
        
        let expectation = XCTestExpectation(description: "Should return empty array when no internet and cache is empty")
        
        // When
        sut.execute(page: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { movies in
                // Then
                XCTAssertTrue(movies.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
