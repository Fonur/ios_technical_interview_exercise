//
//  FeedProviding.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 25.05.2024.
//

import Foundation

protocol ContentProviding {
    var network: Networking { get }
    func getPosts(_ completion: @escaping (Result<[Post], Error>) -> Void)
    func postVote(optionId: Int, _ completion: @escaping (Result<[Post], Error>) -> Void)
}

extension ContentProviding {
    func getPosts(_ completion: @escaping (Result<[Post], Error>) -> Void) {
        network.execute(Endpoint.fetchPosts, completion: completion)
    }

    func postVote(optionId: Int, _ completion: @escaping (Result<[Post], Error>) -> Void) {
        network.execute(Endpoint.postVote(id: optionId), completion: completion)
    }
}
