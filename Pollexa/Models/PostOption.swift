//
//  PostOption.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

extension Post {
    
    struct Option: Equatable, Decodable {

        // MARK: - Types
        enum CodingKeys: String, CodingKey {
            case id
            case imageName
            case votes
        }
        
        // MARK: - Properties
        let id: String
        let image: UIImage
        var votes: Int

        init(id: String, imageName: String, votes: Int) {
            self.id = id
            self.image = UIImage(named: imageName)!
            self.votes = votes
        }

        // MARK: - Life Cycle
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            
            let imageName = try container.decode(
                String.self,
                forKey: .imageName
            )
            
            if let image = UIImage(named: imageName) {
                self.image = image
            } else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: [CodingKeys.imageName],
                    debugDescription: "An image with name \(imageName) could not be loaded from the bundle.")
                )
            }

            votes = try container.decode(Int.self, forKey: .votes)
        }

        static var preview: [Option] {
            return [
                Option(id: "1", imageName: "post_1_option_1", votes: 80),
                Option(id: "2", imageName: "post_1_option_2", votes: 70)
            ]
        }
    }
}
