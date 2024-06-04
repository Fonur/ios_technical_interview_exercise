//
//  MockContentProvider.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 26.05.2024.
//

import Foundation

struct MockContentProvider: ContentPostProviding, ContentGetProviding {
    var network: Networking
    private var responseData: [Post] = []
    private let postProvider: PostProvider = .shared

    init(network: Networking) {
        self.network = network
        postProvider.fetchAll { result in
            switch result {
            case .success(let posts):
                self.responseData = posts
            case .failure(_):
                print("error")
            }
        }
    }

    func getPosts(_ completion: @escaping (Result<[Post], any Error>) -> Void) {
        DispatchQueue.main.async {
            completion(.success(responseData))
        }
    }

    func postVote(optionId: Int, _ completion: @escaping (Result<[Post], any Error>) -> Void) {
        let updatedData = responseData.map { post in
            var updatedPost = post
            updatedPost.options = post.options.map { option in
                if option.id == String(optionId) {
                    var updatedOption = option
                    updatedOption.votes += 1
                    return updatedOption
                } else {
                    return option
                }
            }
            return updatedPost
        }

        DispatchQueue.main.async {
            completion(.success(updatedData))
        }
    }
}
