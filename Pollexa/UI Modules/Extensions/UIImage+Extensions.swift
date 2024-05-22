//
//  UIImage+Extensions.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 22.05.2024.
//

import Foundation
import UIKit

extension UIImage {
    func scaleImage(width: CGFloat, height: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        let img = renderer.image { context in
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        return img
    }
}
