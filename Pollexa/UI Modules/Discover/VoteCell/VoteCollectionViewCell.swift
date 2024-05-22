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

    private var viewModel: VoteCellViewModel!

    private var optionOneThumbsUp: UIView?
    private var optionTwoThumbsUp: UIView?

    private var cancellables: Set<AnyCancellable> = []

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
    
    func configure(with viewModel: VoteCellViewModel) {
        self.viewModel = viewModel
        avatarImageView.image = viewModel.avatarImage
        dateLabel.text = viewModel.dateText
        descriptionLabel.text = viewModel.descriptionText
        lastVoteDateLabel.text = viewModel.lastVoteDateText
        nameLabel.text = viewModel.nameText
        option1Image.image = viewModel.option1Image?.scaleImage(width: self.option1Image.bounds.width, height: self.option1Image.bounds.height)
        option2Image.image = viewModel.option2Image?.scaleImage(width: self.option2Image.bounds.width, height: self.option2Image.bounds.height)
        totalVotesCountLabel.text = viewModel.totalVotesText
        optionOnePercentage.text = String(format: "%.0f%%", viewModel.option1Percentage * 100)
        optionTwoPercentage.text = String(format: "%.0f%%", viewModel.option2Percentage * 100)
        showPercentages()

        viewModel.$showingPercentages
            .receive(on: RunLoop.main)
            .sink { [weak self] showingPercentages in
                self?.showPercentages()
            }
            .store(in: &cancellables)
    }

    private func showPercentages() {
        optionOnePercentage.isHidden = viewModel.showingPercentages ? false : true
        optionTwoPercentage.isHidden = viewModel.showingPercentages ? false : true
        optionOneThumbsUp?.isHidden = viewModel.showingPercentages ? true: false
        optionTwoThumbsUp?.isHidden = viewModel.showingPercentages ? true: false
        threeEllipses?.isHidden = viewModel.showingPercentages ? false: true
    }

    private func setupSwiftUIViews() {
        let voteButtonView1 = ThumbsUpView(id: 1, onTap: { [weak self] index in self?.voteButtonTapped(index) })
        let voteButtonView2 = ThumbsUpView(id: 2, onTap: { [weak self] index in self?.voteButtonTapped(index) })
        
        let hostingController1 = UIHostingController(rootView: voteButtonView1)
        hostingController1.view.backgroundColor = .clear
        optionOneThumbsUp = hostingController1.view
        optionOneThumbsUp?.translatesAutoresizingMaskIntoConstraints = false
        
        let hostingController2 = UIHostingController(rootView: voteButtonView2)
        hostingController2.view.backgroundColor = .clear
        optionTwoThumbsUp = hostingController2.view
        optionTwoThumbsUp?.translatesAutoresizingMaskIntoConstraints = false
        
        if let optionOneThumbsUp = optionOneThumbsUp, let optionTwoThumbsUp = optionTwoThumbsUp {
            contentView.addSubview(optionOneThumbsUp)
            contentView.addSubview(optionTwoThumbsUp)
            contentView.bringSubviewToFront(optionOneThumbsUp)
            contentView.bringSubviewToFront(optionTwoThumbsUp)
            
            NSLayoutConstraint.activate([
                optionOneThumbsUp.heightAnchor.constraint(equalToConstant: 30.0),
                optionOneThumbsUp.widthAnchor.constraint(equalToConstant: 30.0),
                optionTwoThumbsUp.heightAnchor.constraint(equalToConstant: 30.0),
                optionTwoThumbsUp.widthAnchor.constraint(equalToConstant: 30.0),
                optionOneThumbsUp.leadingAnchor.constraint(equalTo: option1Image.leadingAnchor, constant: 10),
                optionTwoThumbsUp.leadingAnchor.constraint(equalTo: option2Image.leadingAnchor, constant: 10),
                optionOneThumbsUp.bottomAnchor.constraint(equalTo: option1Image.bottomAnchor, constant: -10),
                optionTwoThumbsUp.bottomAnchor.constraint(equalTo: option2Image.bottomAnchor, constant: -10),
            ])
        }
    }
    
    private func voteButtonTapped(_ index: Int) {
        self.viewModel.vote(for: index) { result in
            switch result {
                case .success(let posts):
                    self.delegate?.updatePosts(posts: posts)
            case .failure(_):
                print("error!")
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.optionOnePercentage.isHidden = true
        self.optionTwoPercentage.isHidden = true
        cancellables.removeAll()
    }
}
