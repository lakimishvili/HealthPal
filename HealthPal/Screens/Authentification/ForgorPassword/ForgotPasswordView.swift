//
//  ForgotPasswordView.swift
//  HealthPal
//
//  Created by LILIANA on 1/12/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSuccess = false
    @State private var showResetPassword = false

    var body: some View {
        ZStack {
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
                        Text("Forgot Password?")
                            .font(.title.bold())

                        Text("Enter your email to receive a verification code.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 16) {
                        InputField(icon: "envelope", placeholder: "Your Email", text: $email, keyboard: .emailAddress)
                    }

                    Button(action: sendResetCode) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity, minHeight: 52)
                        } else {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, minHeight: 52)
                        }
                    }
                    .background(Color(red: 24/255, green: 36/255, blue: 52/255))
                    .foregroundColor(.white)
                    .cornerRadius(26)
                    .padding(.top, 8)
                    .disabled(isLoading)

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }

                    Spacer(minLength: 24)

                    NavigationLink("", destination: ResetPasswordView(), isActive: $showResetPassword)
                }
                .padding(.horizontal, 24)
            }

            if showSuccess {
                SuccessOverlay(title: "Email Sent!", message: "Check your email for the verification code.")
            }
        }
    }

    private func sendResetCode() {
        errorMessage = nil
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email."
            return
        }

        isLoading = true

        guard let url = URL(string: "http://localhost:3000/auth/forgot-password") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                guard let httpResp = response as? HTTPURLResponse else { return }

                if httpResp.statusCode == 200 {
                    showSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showSuccess = false
                        showResetPassword = true
                    }
                } else {
                    errorMessage = "Email not found or invalid"
                }
            }
        }.resume()
    }
}


#Preview {
    ForgotPasswordView()
}

