//
//  HospitalCard.swift
//  HealthPal
//
//  Created by LILIANA on 1/15/26.
//
import SwiftUI

struct HospitalCard: View {
    let hospital: Hospital
    let userId: Int
    var onSelect: (() -> Void)?
    
    @State private var isFavorite: Bool
    @State private var isAdding: Bool = false

    private var reviewsCount: Int { Int.random(in: 20...200) }
    private var distanceKm: Double { Double.random(in: 0.5...10).rounded(toPlaces: 1) }
    private var timeMin: Int { Int(distanceKm * Double.random(in: 10...15)) }

    init(hospital: Hospital, userId: Int, isFavorite: Bool = false, onSelect: (() -> Void)? = nil) {
        self.hospital = hospital
        self.userId = userId
        self.onSelect = onSelect
        self._isFavorite = State(initialValue: isFavorite)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: - Image with gradient overlay
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: hospital.image ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Color(.systemGray5)
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "building.2.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .padding(40)
                            .foregroundColor(.gray)
                    @unknown default:
                        Color(.systemGray5)
                    }
                }
                .frame(height: 160)
                .clipped()
                .cornerRadius(20)

                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.25)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(20)

                Text(hospital.type.uppercased())
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: addToFavorites) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart") 
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(8)
                .disabled(isFavorite || isAdding)
            }

            // MARK: - Name
            Text(hospital.name)
                .font(.title3.bold())
                .lineLimit(1)
                .foregroundColor(.primary)

            // MARK: - Address
            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.gray)
                    .font(.caption2)
                Text(hospital.address)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            // MARK: - Rating & Reviews
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption2)
                Text(String(format: "%.1f", hospital.rating))
                    .font(.caption2)
                    .fontWeight(.semibold)
                Text("(\(reviewsCount) Reviews)")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            Divider()

            // MARK: - Distance & Select
            HStack {
                Label("\(String(format: "%.1f km", distanceKm)) / \(timeMin) min", systemImage: "location")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                Spacer()
            }
        }
        .padding()
        .frame(width: 350)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    // MARK: - Networking
    private func addToFavorites() {
        guard !isFavorite,
              let url = URL(string: "http://localhost:3000/api/favorites/add") else { return }

        isAdding = true

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "user_id": userId,
            "hospital_id": hospital.id
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { isAdding = false }

            if let error = error {
                print("Network error:", error)
                return
            }

            if let http = response as? HTTPURLResponse {
                print("Status:", http.statusCode)
            }

            if let data = data,
               let text = String(data: data, encoding: .utf8) {
                print("Response:", text)
            }

            DispatchQueue.main.async {
                if let http = response as? HTTPURLResponse, http.statusCode == 201 {
                    isFavorite = true
                }
            }
        }.resume()
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
