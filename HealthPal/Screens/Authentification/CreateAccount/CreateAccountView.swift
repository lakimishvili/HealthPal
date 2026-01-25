//
//  CreateAccountView.swift
//  HealthPal
//
//  Created by LILIANA on 1/12/26.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false

    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showFillProfile = false
    @State private var showSignIn = false


    var body: some View {
        NavigationStack {
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
                        Text("Create Account")
                            .font(.title.bold())

                        Text("We are here to help you!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    VStack(spacing: 16) {
                        InputField(
                            icon: "person",
                            placeholder: "Full Name",
                            text: $fullName
                        )

                        InputField(
                            icon: "envelope",
                            placeholder: "Your Email",
                            text: $email,
                            keyboard: .emailAddress
                        )

                        PasswordField(
                            placeholder: "Password",
                            text: $password,
                            showPassword: $showPassword
                        )
                    }

                    Button(action: register) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity, minHeight: 52)
                        } else {
                            Text("Create Account")
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

                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))

                        Text("or")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    .padding(.vertical, 8)

                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Image("google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)

                            Text("Continue with Google")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }

                    HStack(spacing: 4) {
                        Text("Do you have an account ?")
                            .foregroundColor(.gray)

                        Button("Sign In") {
                            showSignIn = true
                        }
                        .fontWeight(.semibold)
                        .navigationDestination(isPresented: $showSignIn){
                            SignInView()
                        }
                    }
                    .padding(.top, 8)

                    Spacer(minLength: 24)

                    NavigationLink("", destination: FillProfileView(), isActive: $showFillProfile)
                }
                .padding(.horizontal, 24)
            }
        }
    }

    private func register() {
        errorMessage = nil

        if fullName.trimmingCharacters(in: .whitespaces).count < 5 {
            errorMessage = "Full name must be at least 5 characters."
            return
        }

        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return
        }

        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        isLoading = true

        AuthAPI.shared.register(fullName: fullName, email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    showFillProfile = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func isValidEmail(_ value: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}

struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .autocapitalization(.none)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock")
                .foregroundColor(.gray)

            Group {
                if showPassword {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }

            Button(action: { showPassword.toggle() }) {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    CreateAccountView()
}

