//
//  ContentProvider.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 26.05.2024.
//

import Foundation

struct ContentProvider: ContentGetProviding, ContentPostProviding {
    var network: Networking

    init(network: Networking) {
        self.network = network
    }
}
