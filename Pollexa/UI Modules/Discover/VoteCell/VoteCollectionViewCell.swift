//
//  VoteCollectionViewCell.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 22.05.2024.
//

import UIKit
import SwiftUI
import Combine

class VoteCollectionViewCell: UICollectionViewCell {
    weak var delegate: PostUpdateProtocol?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastVoteDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var option1Image: UIImageView!
    @IBOutlet weak var option2Image: UIImageView!
    @IBOutlet weak var totalVotesCountLabel: UILabel!
    
    @IBOutlet weak var threeEllipses: UIButton!
    @IBOutlet weak var optionOnePercentage: UILabel!
    @IBOutlet weak var optionTwoPercentage: UILabel!
    
    private var optionOneThumbsUp: UIView?
    private var optionTwoThumbsUp: UIView?
    
    var index: Int? = nil
    var post: Post? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        
        option1Image.clipsToBounds = true
        option1Image.layer.cornerRadius = 10
        option1Image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        option2Image.clipsToBounds = true
        option2Image.layer.cornerRadius = 10
        option2Image.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        setupSwiftUIViews()
    }
    
    func configure(with postCell: PostCellModel) {
        self.index = postCell.index
        self.post = postCell.post
        guard let post else { return }
        
        let diffDate = Date().timeIntervalSince(post.createdAt)
        avatarImageView.image = post.user.image
        dateLabel.text =  diffDate.timeAgoDisplay()
        descriptionLabel.text = post.content
        lastVoteDateLabel.text = "LAST VOTED \(Date().timeIntervalSince(post.lastVoted).timeAgoDisplay().uppercased())"
        nameLabel.text = post.user.username
        option1Image.image = post.options[0].image.scaleImage(width: self.option1Image.bounds.width, height: self.option1Image.bounds.height)
        option2Image.image = post.options[1].image.scaleImage(width: self.option2Image.bounds.width, height: self.option2Image.bounds.height)
        totalVotesCountLabel.text = String(post.totalVotes)
        optionOnePercentage.text = String(format: "%.0f%%", calculatePercentage(post.options[0].votes))
        optionTwoPercentage.text = String(format: "%.0f%%", calculatePercentage(post.options[1].votes))
        
        showPercentages(showingPercentages: postCell.showingPercentages)
        
        func calculatePercentage(_ votes: Int) -> Double {
            return Double(votes) / Double(post.options[0].votes + post.options[1].votes) * 100
        }
    }
    
    func showPercentages(showingPercentages: Bool = false) {
        optionOnePercentage.isHidden = showingPercentages ? false : true
        optionTwoPercentage.isHidden = showingPercentages ? false : true
        optionOneThumbsUp?.isHidden = showingPercentages ? true: false
        optionTwoThumbsUp?.isHidden = showingPercentages ? true: false
        threeEllipses?.isHidden = showingPercentages ? false: true
    }
    
    private func setupSwiftUIViews() {
        let voteButtons = [
            option1Image: ThumbsUpContainerView { [weak self] in
                self?.voteButtonTapped(0)
            },
            option2Image: ThumbsUpContainerView { [weak self] in
                self?.voteButtonTapped(1)
            }
        ]
        
        self.optionOneThumbsUp = voteButtons[option1Image]
        self.optionTwoThumbsUp = voteButtons[option2Image]
        
        voteButtons.forEach { view in
            if let key = view.key {
                addThumbsUpView(view.value, to: key)
            }
        }
    }
    
    private func addThumbsUpView(_ thumbsUpView: UIView, to imageView: UIImageView) {
        thumbsUpView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbsUpView)
        contentView.bringSubviewToFront(thumbsUpView)
        
        NSLayoutConstraint.activate([
            thumbsUpView.heightAnchor.constraint(equalToConstant: 30.0),
            thumbsUpView.widthAnchor.constraint(equalToConstant: 30.0),
            thumbsUpView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            thumbsUpView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
        ])
    }
    
    private func voteButtonTapped(_ index: Int) {
        if let post {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                
                self?.delegate?.updatePosts(voteID: post.options[index].id, index: self?.index ?? 0)
                
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
