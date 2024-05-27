//
//  DiscoverViewModel.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 21.05.2024.
//

import Combine
import Foundation
import UIKit

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
            }
        })
        .store(in: &cancellables)

        return output.eraseToAnyPublisher()
    }

    private func getPosts() {
        service.getPosts { [weak self] result in
            do {
                try self?.output.send(.fetchPosts(posts: result.get()))
            } catch {
                self?.output.send(.fetchPostsFailed(error: error))
            }
        }
    }
}

extension DiscoverViewModel {
    enum Input {
        case viewDidAppear
        case updatePosts([Post])
    }

    enum Output {
        case fetchPosts(posts: [Post])
        case fetchPostsFailed(error: Error)
    }
}
