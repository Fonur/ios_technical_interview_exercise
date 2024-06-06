//
//  DiscoverViewModel.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 21.05.2024.
//

import Combine
import Foundation
import UIKit

typealias ContentProviding = ContentGetProviding & ContentPostProviding

struct PostCellModel {
    let index: Int
    let post: Post
    var showingPercentages: Bool
}

class DiscoverViewModel {
    private let output: PassthroughSubject<Output, Never> = .init()
    let service: ContentProviding
    var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()

    init(service: ContentProviding) {
        self.service = service
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink(receiveValue: { [weak self] event in
            switch event {
            case .viewDidAppear:
                self?.getPosts()
            case .updatePosts(let posts):
                self?.output.send(.fetchPosts(posts: posts))
            case .vote(let id, let index):
                self?.postPoll(id: id)
                self?.output.send(.showPercentages(index))
            }
        })
        .store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }

    private func postPoll(id: String) {
        service.postVote(optionId: id) { [weak self] result in
            self?.output.send(.postVote(id))
        }
    }

    private func getPosts() {
        service.getPosts { [weak self] result in
            do {
                try self?.output.send(.fetchPosts(posts: result.get()))
            } catch {
                self?.output.send(.requestFailed(error: error))
            }
        }
    }
}

extension DiscoverViewModel {
    enum Input {
        case viewDidAppear
        case updatePosts([Post])
        case vote(String, Int)
    }

    enum Output {
        case fetchPosts(posts: [Post])
        case postVote(String)
        case requestFailed(error: Error)
        case showPercentages(Int)
    }
}
