//
//  Endpoint.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 25.05.2024.
//

import Foundation

enum Endpoint {
    case fetchPosts
    case postVote(id: String)
}

extension Endpoint: RequestProviding {
    var urlRequest: URLRequest {
        guard let url = URL(string: "https://api.pollexa.com/") else {
            preconditionFailure("Invalid URL used to create URL instance")
        }

        switch self {
        case .fetchPosts:
            return URLRequest(url: url)
        case .postVote(_):
            return URLRequest(url: url)
        }
    }
}

protocol RequestProviding {
    var urlRequest: URLRequest { get }
}
