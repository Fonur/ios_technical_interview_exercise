//
//  GetProviding.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 4.06.2024.
//

import Foundation

protocol ContentGetProviding {
    var network: Networking { get }
    func getPosts(_ completion: @escaping (Result<[Post], Error>) -> Void)
}

extension ContentGetProviding {
    func getPosts(_ completion: @escaping (Result<[Post], Error>) -> Void) {
        network.execute(Endpoint.fetchPosts, completion: completion)
    }
}
