//
//  FeedProviding.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 25.05.2024.
//

import Foundation

protocol ContentPostProviding {
    var network: Networking { get }
    func postVote(optionId: String, _ completion: @escaping (Result<[Post], Error>) -> Void)
}

extension ContentPostProviding {
    func postVote(optionId: String, _ completion: @escaping (Result<[Post], Error>) -> Void) {
        network.execute(Endpoint.postVote(id: optionId), completion: completion)
    }
}
