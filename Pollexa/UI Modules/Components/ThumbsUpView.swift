//
//  ThumbsUpView.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 24.05.2024.
//

import SwiftUI
import UIKit

class ThumbsUpContainerView: UIView {

    init(onTap: @escaping () -> Void) {
        super.init(frame: .zero)
        setupThumbsUpView(onTap: onTap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupThumbsUpView(onTap: @escaping () -> Void) {
        let thumbsUpView = ThumbsUpView(onTap: onTap)
        let hostingController = UIHostingController(rootView: thumbsUpView)

        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 30.0),
            hostingController.view.widthAnchor.constraint(equalToConstant: 30.0),
        ])
    }
}

struct ThumbsUpView: View {
    var onTap: () -> Void
    @State private var isSelected = false

    @ViewBuilder
    func thumbsUpIcon() -> some View {
        if #available(iOS 17.0, *) {
            Button {
                isSelected = true
                self.onTap()
            } label: {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 14.0))
            }
            .accessibilityIdentifier("ThumbsUp")
            .symbolEffect(.bounce.up, value: isSelected)
        } else {
            Button {
                isSelected = true
                self.onTap()
            } label: {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 14.0))
            }
        }
    }

    var body: some View {
        ZStack(content: {
            thumbsUpIcon()
                .background {
                    Circle()
                        .fill(.white)
                        .frame(width: 30, height: 30)
                        .shadow(color: Color.black.opacity(0.25), radius: 4.0, x: 0, y: 4)
                }
        })
    }
}
