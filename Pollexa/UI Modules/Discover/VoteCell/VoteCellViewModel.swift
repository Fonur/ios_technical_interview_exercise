//
//  VoteViewModel.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 21.05.2024.
//

import Foundation
import Combine
import UIKit

final class VoteCellViewModel {
    private let service: ContentProviding
    @Published var showingPercentages: Bool = false

    let post: Post
    let avatarImage: UIImage?
    let dateText: String
    let descriptionText: String
    let lastVoteDateText: String
    let nameText: String
    let option1Image: UIImage?
    let option2Image: UIImage?
    let totalVotesText: String
    let option1Percentage: Double
    let option2Percentage: Double

    init(post: Post, service: ContentProviding) {
        let diffDate = Date().timeIntervalSince(post.createdAt)
        self.post = post
        self.avatarImage = post.user.image
        self.dateText = diffDate.timeAgoDisplay()
        self.descriptionText = post.content
        self.lastVoteDateText = "LAST VOTED \(Date().timeIntervalSince(post.lastVoted).timeAgoDisplay().uppercased())"
        self.nameText = post.user.username
        self.option1Image = post.options[0].image.scaleImage(width: 100, height: 100)
        self.option2Image = post.options[1].image.scaleImage(width: 100, height: 100)
        self.totalVotesText = "\(post.totalVotes) Total Votes"
        self.option1Percentage = (Double(post.options[0].votes) / Double(post.totalVotes))
        self.option2Percentage = Double(post.options[1].votes) / Double(post.totalVotes)
        self.service = service
    }
}

extension VoteCellViewModel {
    func vote(for id: Int, _ completion: @escaping (Result<[Post], any Error>) -> Void) {
        service.postVote(optionId: id) { [weak self] result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.showingPercentages = true
                }
            case .failure(let error):
                print("error \(error.localizedDescription)")
            }
        }
    }
}
