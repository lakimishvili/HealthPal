//
//  RootView.swift
//  HealthPal
//
//  Created by LILIANA on 1/11/26.
//
import SwiftUI

struct RootView: View {
    @State private var showLaunch = true
    @State private var showOnboarding = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("authToken") private var authToken = ""

    var body: some View {
        Group {
            if showLaunch {
                LaunchScreenView {
                    showLaunch = false
                    showOnboarding = !hasSeenOnboarding
                }
            } else if showOnboarding {
                OnboardingView {
                    hasSeenOnboarding = true
                    showOnboarding = false
                }
            } else {
                if authToken.isEmpty {
                    SignInView()
                } else {
                    MainTabBarWrapper()  
                }
            }
        }
        .animation(.easeInOut, value: showLaunch)
        .animation(.easeInOut, value: showOnboarding)
        .animation(.easeInOut, value: authToken)
    }
}
