//
//  CreateAccountView.swift
//  HealthPal
//
//  Created by LILIANA on 1/12/26.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

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
                    Text("Create Account")
                        .font(.title.bold())

                    Text("We are here to help you!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                VStack(spacing: 16) {
                    InputField(icon: "person", placeholder: "Your Name", text: $name)
                    InputField(icon: "envelope", placeholder: "Your Email", text: $email)
                    InputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                }

                Button(action: {}) {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Color(red: 24/255, green: 36/255, blue: 52/255))
                        .foregroundColor(.white)
                        .cornerRadius(26)
                }
                .padding(.top, 8)

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

                // Sign In
                HStack(spacing: 4) {
                    Text("Do you have an account ?")
                        .foregroundColor(.gray)

                    Button("Sign In") {
                        // navigate to sign in
                    }
                    .fontWeight(.semibold)
                }
                .padding(.top, 8)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Reusable Input Field

struct InputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)

            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
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
