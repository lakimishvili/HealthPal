//
//  ForgotPasswordView.swift
//  HealthPal
//
//  Created by LILIANA on 1/12/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)

                Text("HealthPal")
                    .font(.title3)
                    .foregroundColor(.gray)
            }

            VStack(spacing: 8) {
                Text("Forgot Password?")
                    .font(.title.bold())

                Text("Enter your email to receive a verification code.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 16) {
                InputField(icon: "envelope", placeholder: "Your Email", text: $email)
            }

            Button(action: {
                // Navigate to VerifyCodeView
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Color(red: 24/255, green: 36/255, blue: 52/255))
                    .foregroundColor(.white)
                    .cornerRadius(26)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // optional
    }
}

#Preview {
    ForgotPasswordView()
}

