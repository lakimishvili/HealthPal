//
//  VerifyCodeView.swift
//  HealthPal
//
//  Created by LILIANA on 1/12/26.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var code = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    var body: some View {
        ScrollView {
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
                .padding(.top, 32)

                VStack(spacing: 8) {
                    Text("Reset Password")
                        .font(.title.bold())

                    Text("Enter the code sent to your email and set a new password.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 16) {
                    InputField(icon: "key", placeholder: "Verification Code", text: $code)
                    InputField(icon: "lock", placeholder: "New Password", text: $newPassword, isSecure: true)
                    InputField(icon: "lock", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                }

                Button(action: {
                    // Resend code action
                }) {
                    Text("Didn’t get the code?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Resend")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)

                Button(action: {
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color(red: 24/255, green: 36/255, blue: 52/255))
                        .foregroundColor(.white)
                        .cornerRadius(26)
                }
                .padding(.top, 8)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ResetPasswordView()
}
