//
//  ThumbsUpView.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 24.05.2024.
//

import SwiftUI

struct ThumbsUpView: View {
    let id: Int
    var onTap: (Int) -> Void
    @State private var isSelected = false

    @ViewBuilder
    func thumbsUpIcon() -> some View {
        if #available(iOS 17.0, *) {
            Button {
                isSelected = true
                self.onTap(id)
            } label: {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 14.0))
            }
            .accessibilityIdentifier("ThumbsUp")
            .symbolEffect(.bounce.up, value: isSelected)
        } else {
            Button {
                isSelected = true
                self.onTap(id)
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

#Preview {
    ThumbsUpView(id: 1, onTap: {_ in

    })
}
