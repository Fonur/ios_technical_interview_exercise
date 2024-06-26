//
//  DiscoverViewTests.swift
//  PollexaTests
//
//  Created by Fikret Onur ÖZDİL on 21.05.2024.
//

import XCTest
import Combine
@testable import Pollexa

final class DiscoverViewTests: XCTestCase {
    var discoverViewModel: DiscoverViewModel!
    private var input: PassthroughSubject<DiscoverViewModel.Input, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        let mockedService = MockContentProvider(network: NetworkManager())
        discoverViewModel = DiscoverViewModel(service: mockedService)
    }

    override func tearDownWithError() throws {
        discoverViewModel = nil
        cancellables = []
    }

    func testViewDidAppeared() throws {
        let expectation = XCTestExpectation(description: "Posts loaded")

        let output = discoverViewModel.transform(input: input.eraseToAnyPublisher())

        output.sink {completion in
            if case .failure(let error) = completion {
                XCTFail("Failed with error \(error)")
            }
        } receiveValue: { state in
            switch state {
            case .fetchPosts(let posts):
                if posts.count > 0 {
                    expectation.fulfill()
                }
            default: break
            }
        }
        .store(in: &cancellables)

        input.send(.viewDidAppear)
        wait(for: [expectation], timeout: 5.0)
    }

    func testVoteForCell() throws {
        let id = "opt_011"
        let votesCount = 115
        let expectation = XCTestExpectation(description: "Posted vote")

        let output = discoverViewModel.transform(input: input.eraseToAnyPublisher())

        output.sink { state in
            switch state {
            case .postVote(let posts):
                if let updatedPost = posts.first(where: { $0.options.contains {
                    $0.id == id
                }}) {
                    XCTAssertEqual(updatedPost.options[0].votes, votesCount + 1)
                    expectation.fulfill()
                }
            default: break
            }
        }
        .store(in: &cancellables)

        input.send(.vote(id))
        wait(for: [expectation], timeout: 5.0)
    }
}
