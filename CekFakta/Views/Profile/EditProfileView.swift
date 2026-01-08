//
//  EditProfileView.swift
//  CekFakta
//
//  Created by Heical Chandra on 19/12/25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var user: ProfileManager
    @Environment(\.dismiss) private var dismiss

    // Profile fields
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    // Avatar picker
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    // UI state
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Form {

                // =====================
                // AVATAR
                // =====================
                Section {
                    HStack {
                        Spacer()

                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images
                        ) {
                            avatarView
                        }

                        Spacer()
                    }
                }

                // =====================
                // PROFILE
                // =====================
                Section(header: Text("Profile")) {
                    TextField("Name", text: $name)
                }

                // =====================
                // ACCOUNT
                // =====================
                Section(header: Text("Account")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)

                    SecureField("New Password", text: $password)
                }

                // =====================
                // ERROR
                // =====================
                if let error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                // Save
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Button("Save") {
                            updateProfile()
                        }
                        .disabled(!hasChanges)
                    }
                }
            }
            .onAppear {
                name = auth.userName ?? ""
                email = auth.userEmail ?? ""
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
    }

    // =====================
    // AVATAR VIEW
    // =====================
    private var avatarView: some View {
        Group {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if let avatar = auth.avatarURL,
                      let url = URL(string: avatar) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 110, height: 110)
        .clipShape(Circle())
    }

    // =====================
    // VALIDATION
    // =====================
    private var hasChanges: Bool {
        name != auth.userName ||
        email != auth.userEmail ||
        !password.isEmpty ||
        selectedImage != nil
    }

    // =====================
    // UPDATE LOGIC
    // =====================
    private func updateProfile() {
        isLoading = true
        error = nil

        Task {
            do {
                var avatarURL: String?

                if let image = selectedImage {
                    avatarURL = try await auth.uploadAvatar(image)
                }

                try await user.updateProfile(
                    name: name != auth.userName ? name : nil,
                    avatarURL: avatarURL,
                    email: email != auth.userEmail ? email : nil,
                    password: password.isEmpty ? nil : password
                )

                await auth.fetchCurrentUser()
                dismiss()

            } catch {
                self.error = "Failed to update profile"
            }

            isLoading = false
        }
    }


}
