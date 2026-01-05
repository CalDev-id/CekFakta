//
//  RegisterView.swift
//  CekFakta
//
//  Created by Heical Chandra on 18/12/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var auth: AuthManager

    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var error: String?
    @State private var isLoading = false
    @State private var name = ""


    var body: some View {
        VStack(spacing: 16) {
            Text("Create Account")
                .font(.largeTitle)
                .bold()
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)

            if let error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button {
                register()
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            Button("Already have an account? Login") {
                dismiss()
            }
            .font(.footnote)
        }
        .padding()
    }

    // MARK: - REGISTER LOGIC
    private func register() {
        guard !name.isEmpty else {
            error = "Name is required"
            return
        }

        guard password == confirmPassword else {
            error = "Passwords do not match"
            return
        }

        error = nil
        isLoading = true

        Task {
            do {
                try await auth.signup(
                    email: email,
                    password: password,
                    name: name
                )
                dismiss() // balik ke login
            } catch {
                self.error = "Registration failed"
            }
            isLoading = false
        }
    }

}
