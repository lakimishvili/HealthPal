//
//  OnboardingView.swift
//  HealthPal
//
//  Created by LILIANA on 1/11/26.
//
import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var index = 0

    let pages = [
        ("Find Doctors", "Search best doctors near you"),
        ("Book Easily", "Schedule appointments in seconds"),
        ("Stay Healthy", "Track visits and reminders")
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {

                Image("onboarding\(index + 1)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width,
                           height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Capsule()
                        .frame(width: 40, height: 5)
                        .foregroundColor(.gray.opacity(0.4))

                    Text(pages[index].0)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    Text(pages[index].1)
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(red: 24/255, green: 36/255, blue: 52/255))
                                .frame(width: i == index ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.3), value: index)
                        }
                    }
                    .padding(.vertical, 12)

                    Button(action: {
                        if index < pages.count - 1 {
                            withAnimation {
                                index += 1
                            }
                        } else {
                            onFinish()
                        }
                    }) {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(Color(red: 24/255, green: 36/255, blue: 52/255))
                            .foregroundColor(.white)
                            .cornerRadius(26)
                    }

                    Button("Skip") {
                        onFinish()
                    }
                    .foregroundColor(.gray)
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, 40 + geo.safeAreaInsets.bottom * 0.4)
                .frame(width: geo.size.width)
                .background(Color.white)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .shadow(radius: 10)
            }
        }
        .ignoresSafeArea()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 24.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
