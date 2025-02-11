//
//  Shimmer.swift
//  SDU App
//
//  Created by Nurkhat on 26.11.2024.
//

import SwiftUI

struct ShimmerView: View {
    @State private var gradientPosition: CGFloat = -1.0

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1), Color.gray.opacity(0.3)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 20)
            .opacity(0.8)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.white, Color.clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: gradientPosition * UIScreen.main.bounds.width)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    gradientPosition = 1.0
                }
            }
    }
}

struct ShimmerRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ShimmerView()
                .frame(height: 20)

            ShimmerView()
                .frame(height: 15)
                .padding(.trailing, 50)

            ShimmerView()
                .frame(height: 15)
                .padding(.trailing, 100)
        }
        .padding()
    }
}
