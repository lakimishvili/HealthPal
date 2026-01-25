//
//  SignInView.swift
//  HealthPal
//
//  Created by LILIANA on 1/14/26.
//

import SwiftUI

struct SignInView: View {

    @AppStorage("authToken") private var authToken = ""
    @AppStorage("userId") private var userId: Int = 0
    @AppStorage("userFullName") private var userFullName: String = ""

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false

    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSuccess = false

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {

                        // MARK: - Logo
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

                        // MARK: - Welcome
                        VStack(spacing: 8) {
                            Text("Hi, welcome back!")
                                .font(.title.bold())

                            Text("Hope you're doing fine.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        // MARK: - Inputs
                        VStack(spacing: 16) {
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

                        // MARK: - Sign In Button
                        Button(action: signIn) {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity, minHeight: 52)
                            } else {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, minHeight: 52)
                            }
                        }
                        .background(Color(red: 24/255, green: 36/255, blue: 52/255))
                        .foregroundColor(.white)
                        .cornerRadius(26)
                        .padding(.top, 8)
                        .disabled(isLoading)

                        // MARK: - Error
                        if let errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                        }

                        // MARK: - Forgot Password
                        HStack {
                            Spacer()
                            NavigationLink("Forgot Password?") {
                                ForgotPasswordView()
                            }
                            .font(.subheadline)
                        }

                        // MARK: - Divider
                        HStack {
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                            Text("or").foregroundColor(.gray)
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                        }

                        // MARK: - Google
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)

                                Text("Continue with Google")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(Color.gray.opacity(0.3))
                            )
                        }

                        // MARK: - Sign Up
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)

                            NavigationLink("Create Account") {
                                CreateAccountView()
                            }
                            .fontWeight(.semibold)
                        }

                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 24)
                }
            }

            // MARK: - Success Overlay
            if showSuccess {
                SuccessOverlay(
                    title: "Login Successful!",
                    message: "Redirecting to Home..."
                )
            }
        }
    }

    // MARK: - Login
    private func signIn() {
        errorMessage = nil

        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        isLoading = true

        AuthAPI.shared.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    authToken = token
                    fetchCurrentUser(token: token)

                case .failure:
                    isLoading = false
                    errorMessage = "Invalid credentials"
                }
            }
        }
    }

    // MARK: - Fetch Current User
    private func fetchCurrentUser(token: String) {
        guard let url = URL(string: "http://localhost:3000/users/me") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }

                guard let data else {
                    errorMessage = "No data received"
                    return
                }

                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    userId = user.id
                    userFullName = user.fullName
                    showSuccess = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        showSuccess = false
                        switchToMainApp()
                    }
                } catch {
                    errorMessage = "Failed to decode user data"
                }
            }
        }.resume()
    }

    // MARK: - Root Switch
    private func switchToMainApp() {
        let tabBar = MainTabBarController()

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {

            window.rootViewController = tabBar
            window.makeKeyAndVisible()

            UIView.transition(
                with: window,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: nil
            )
        }
    }

    // MARK: - Email Validation
    private func isValidEmail(_ value: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return value.range(of: pattern, options: .regularExpression) != nil
    }
}


#Preview {
    SignInView()
}
