//
//  DiscoverViewController.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit
import Combine

class DiscoverViewController: UIViewController {
    // MARK: - Properties
    var viewModel: DiscoverViewModel!
    var cellViewModels: [VoteCellViewModel] = []
    private var input: PassthroughSubject<DiscoverViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var posts: [Post] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Discover"
        setupViews()
        
        let nib = UINib(nibName: "VoteCellView", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "VoteCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchPosts(let posts):
                    self?.posts = posts.sorted(by: { lhs, rhs in
                        lhs.createdAt > rhs.createdAt
                    })
                case .fetchPostsFailed(_):
                    print("error")
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        input.send(.viewDidAppear)
    }
    
    private func setupViews() {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "avatar_1.png"), for: .normal)
        button.addTarget(self, action: #selector(avatarButtonPressed), for: .touchUpInside)
        let buttonSize: CGFloat = 34
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.layer.cornerRadius = buttonSize / 2
        button.clipsToBounds = true
        button.accessibilityIdentifier = "avatarButton"
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        containerView.addSubview(button)
        button.center = containerView.center
        let barButton = UIBarButtonItem(customView: containerView)
        self.navigationItem.leftBarButtonItem = barButton
        
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.25
        headerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerView.layer.shadowRadius = 4
        headerView.layer.masksToBounds = false
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.25)
        shadow.shadowOffset = CGSize(width: 0, height: 4)
        shadow.shadowBlurRadius = 4
        let font = UIFont(name: "SFProText-Semibold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .semibold)
        
        let attributedString = NSAttributedString(
            string: "􀄍",
            attributes: [
                .font: font,
                .shadow: shadow,
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -4.0
            ]
        )
        nextButton.setAttributedTitle(attributedString, for: .normal)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .shadow: shadow,
            .foregroundColor: UIColor.label,
            .font: UIFont(name: "SFProText-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        
    }
    
    @objc func avatarButtonPressed() {
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoteCell", for: indexPath) as! VoteCollectionViewCell
        let post = posts[indexPath.row]
        let cellViewModel = VoteCellViewModel(post: post, service: MockContentProvider(network: NetworkManager()))
        cell.configure(with: cellViewModel)
        cell.delegate = self
        cell.accessibilityIdentifier = "VoteCell"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 338)
    }
}

extension DiscoverViewController: PostUpdateProtocol {
    func updatePosts(posts: [Post]) {
        //TODO: update posts here
    }
}

protocol PostUpdateProtocol: NSObject {
    func updatePosts(posts: [Post])
}
