//
//  LaunchScreenView.swift
//  HealthPal
//
//  Created by LILIANA on 1/11/26.
//
import SwiftUI

struct LaunchScreenView: View {
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Image("launchScreen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()       
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onFinish()
            }
        }
    }
}

