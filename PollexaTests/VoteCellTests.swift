//
//  VoteCellTests.swift
//  PollexaTests
//
//  Created by Fikret Onur ÖZDİL on 21.05.2024.
//

import XCTest
import Combine
@testable import Pollexa

final class VoteCellTests: XCTestCase {
    var viewModel: VoteCellViewModel!

    override func setUpWithError() throws {
        viewModel = VoteCellViewModel(post: .preview, service: MockContentProvider(network: NetworkManager()))
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testVoteButtonPressed() throws {
        viewModel.vote(for: 1) { result in
            switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(let failure):
                XCTFail("Failure during getting data")
            }
        }
    }
}
