//
//  SuccessOverlay.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//
import SwiftUI

struct SuccessOverlay: View {
    let title: String
    let message: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: 16) {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.green)
                    )

                Text(title)
                    .font(.title3.bold())

                Text(message)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                ProgressView()
            }
            .padding(24)
            .frame(maxWidth: 280)
            .background(Color.white)
            .cornerRadius(24)
        }
    }
}
