//
//  FillProfileView.swift
//  HealthPal
//
//  Created by LILIANA on 1/12/26.
//
import SwiftUI
import PhotosUI

struct FillProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("authToken") private var authToken = ""

    @State private var phone = ""
    @State private var personalId = ""
    @State private var birthDate = Date()
    @State private var gender = "Gender"

    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage: String?

    @State private var profileImage: UIImage?
    @State private var isShowingPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        ZStack {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(width: 140, height: 140)

                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 64, height: 64)
                                    .foregroundColor(.gray.opacity(0.6))
                            }

                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: { isShowingPhotoPicker = true }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.white)
                                            .frame(width: 36, height: 36)
                                            .background(Color(red: 24/255, green: 36/255, blue: 52/255))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .offset(x: 6, y: 6)
                                }
                            }
                            .frame(width: 140, height: 140)
                        }
                        .padding(.top, 32)
                        .photosPicker(isPresented: $isShowingPhotoPicker, selection: $selectedItem, matching: .images)
                        .onChange(of: selectedItem) { newItem in
                            if let newItem {
                                newItem.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let data):
                                        if let data, let uiImage = UIImage(data: data) {
                                            profileImage = uiImage
                                        }
                                    case .failure(let error):
                                        print("Photo picker error: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }

                        VStack(spacing: 16) {
                            InputField(icon: "phone", placeholder: "Phone number", text: $phone)
                                .keyboardType(.numberPad)

                            InputField(icon: "person.text.rectangle", placeholder: "Personal Id", text: $personalId)
                                .keyboardType(.numberPad)

                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)

                                DatePicker(
                                    "",
                                    selection: $birthDate,
                                    in: ...Date(),
                                    displayedComponents: .date
                                )
                                .labelsHidden()

                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Gender")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                HStack(spacing: 12) {
                                    ForEach(["Male", "Female", "Other"], id: \.self) { option in
                                        Button(action: { gender = option }) {
                                            Text(option)
                                                .font(.subheadline)
                                                .foregroundColor(gender == option ? .white : .black)
                                                .padding(.vertical, 10)
                                                .padding(.horizontal, 16)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(gender == option ? Color.black : Color.gray.opacity(0.2))
                                                )
                                        }
                                    }
                                    Spacer()
                                }
                            }

                            Button(action: saveProfile) {
                                if isLoading {
                                    ProgressView().tint(.white)
                                        .frame(maxWidth: .infinity, minHeight: 52)
                                } else {
                                    Text("Save")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, minHeight: 52)
                                }
                            }
                            .background(Color(red: 24/255, green: 36/255, blue: 52/255))
                            .foregroundColor(.white)
                            .cornerRadius(26)
                            .padding(.top, 24)
                            .disabled(isLoading)

                            if let errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                                    .padding(.top, 4)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }

                            Spacer(minLength: 24)
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }

            if showSuccess {
                SuccessOverlay(
                    title: "Congratulations!",
                    message: "Your account is ready to use. You will be redirected to the Home Page in a few seconds..."
                )
            }
        }
    }

    // MARK: - Validation
    private func validateFields() -> Bool {
        let phoneDigits = phone.filter { $0.isNumber }
        if phone.isEmpty {
            errorMessage = "Phone number is required"
            return false
        } else if phoneDigits.count > 15 {
            errorMessage = "Phone number cannot exceed 15 digits"
            return false
        }

        let idDigits = personalId.filter { $0.isNumber }
        if personalId.isEmpty {
            errorMessage = "Personal ID is required"
            return false
        } else if idDigits.count != 11 {
            errorMessage = "Personal ID must be exactly 11 digits"
            return false
        }

        if birthDate > Date() {
            errorMessage = "Birth date cannot be in the future"
            return false
        }

        if gender == "Gender" {
            errorMessage = "Please select a gender"
            return false
        }

        errorMessage = nil
        return true
    }

    // MARK: - Save Profile
    private func saveProfile() {
        guard validateFields() else { return }

        isLoading = true

        if let image = profileImage {
            uploadProfileImage(image) { success in
                completeProfileSave()
            }
        } else {
            completeProfileSave()
        }
    }

    private func completeProfileSave() {
        let year = Calendar.current.component(.year, from: birthDate)

        AuthAPI.shared.updateProfile(
            token: authToken,
            phone: phone,
            personalId: personalId,
            birthYear: year,
            gender: gender
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    showSuccess = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func uploadProfileImage(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false)
            return
        }

        var request = URLRequest(url: URL(string: "https://yourapi.com/upload-profile")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("Upload error: \(error)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}

#Preview {
    FillProfileView()
}
