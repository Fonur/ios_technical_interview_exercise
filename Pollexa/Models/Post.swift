//
//  Post.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

struct Post: Decodable {
    
    // MARK: - Properties
    let id: String
    let createdAt: Date
    let content: String
    var options: [Option]
    let user: User
    let lastVoted: Date
    let totalVotes: Int

    static var preview: Post {
        Post(
            id: "post1",
            createdAt: Date(),
            content: "This is a sample post content.",
            options: Option.preview,
            user: User.preview,
            lastVoted: .now,
            totalVotes: 120
        )
    }
}
