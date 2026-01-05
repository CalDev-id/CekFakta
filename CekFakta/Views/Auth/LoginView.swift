//
//  LoginView.swift
//  CekFakta
//
//  Created by Heical Chandra on 18/12/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var email = ""
    @State private var password = ""
    @State private var error: String?
    @State private var showRegister = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Login")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if let error {
                Text(error).foregroundColor(.red)
            }

            Button("Login") {
                Task {
                    do {
                        try await auth.login(email: email, password: password)
                    } catch {
                        self.error = "Invalid email or password"
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Create new account") {
                showRegister = true
            }
            .font(.footnote)
        }
        .padding()
        .navigationDestination(isPresented: $showRegister) {
            RegisterView()
        }
    }
}


#Preview {
    LoginView()
}
